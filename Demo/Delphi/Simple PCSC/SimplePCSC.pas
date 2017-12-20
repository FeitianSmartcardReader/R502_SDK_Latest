////////////////////////////////////////////////////////////////////////////////
//
// Company  : FTsafe, LTD.
//
// Name     : SimplePCSC
//
////////////////////////////////////////////////////////////////////////////////

unit SimplePCSC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, FTsafeModule;

Const MAX_BUFFER_LEN    = 256;
Const INVALID_SW1SW2    = -450;

type
  TMainReadWrite = class(TForm)
    cbReader: TComboBox;
    mMsg: TRichEdit;
    bInit: TButton;
    bReader: TButton;
    bReset: TButton;
    bQuit: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    bConnect: TButton;
    bBeginTran: TButton;
    bStatus: TButton;
    bTransmit: TButton;
    bEnd: TButton;
    bDisconnect: TButton;
    bRelease: TButton;
    Label1: TLabel;
    gbData: TGroupBox;
    Label7: TLabel;
    tDataIn: TEdit;
    bResetall: TButton;
    gbOutData: TGroupBox;
    Label2: TLabel;
    btStatus: TStatusBar;
    procedure bQuitClick(Sender: TObject);
    procedure bReaderClick(Sender: TObject);
    procedure bInitClick(Sender: TObject);
    procedure cbReaderChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure bResetClick(Sender: TObject);
    procedure bConnectClick(Sender: TObject);
    procedure bBeginTranClick(Sender: TObject);
    procedure bStatusClick(Sender: TObject);
    procedure bTransmitClick(Sender: TObject);
    procedure bEndClick(Sender: TObject);
    procedure bDisconnectClick(Sender: TObject);
    procedure bReleaseClick(Sender: TObject);
    procedure tDataInKeyPress(Sender: TObject; var Key: Char);
    procedure bResetallClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainReadWrite: TMainReadWrite;
  hContext    : SCARDCONTEXT;
  hCard       : SCARDCONTEXT;
  ioRequest   : SCARD_IO_REQUEST;
  retCode     : Integer;
  dwActProtocol, BufferLen  : DWORD;
  SendBuff, RecvBuff        : array [0..262] of Byte;
  SendLen, RecvLen          : DWORD;
  Buffer      : array [0..MAX_BUFFER_LEN] of char;
  ConnActive, diFlag  : Boolean;

procedure ClearBuffers();
procedure InitMenu();
procedure DisableAPDUInput();
procedure displayOut(errType: Integer; retVal: Integer; PrintText: String);
function SendAPDU(): integer;
function TrimInput(dataInput: String): String;

implementation

{$R *.dfm}

procedure ClearBuffers();
var indx: integer;
begin

  for indx := 0 to 262 do
    begin
      SendBuff[indx] := $00;
      RecvBuff[indx] := $00;
    end;

end;

procedure InitMenu();
begin

  MainReadWrite.cbReader.Clear;
  MainReadWrite.mMsg.Clear;
  DisableAPDUInput();
  MainReadWrite.btStatus.SimpleText := 'Program ready';

end;

procedure DisableAPDUInput();
begin

  MainReadWrite.tDataIn.Clear;
  MainReadWrite.gbData.Enabled := False;

end;
procedure displayOut(errType: Integer; retVal: Integer; PrintText: String);
begin

  case errType of
    0: MainReadWrite.mMsg.SelAttributes.Color := clTeal;      // Notifications
    1: begin                                                  // Error Messages
         MainReadWrite.mMsg.SelAttributes.Color := clRed;
         PrintText := GetScardErrMsg(retVal);
       end;
    2: begin
         MainReadWrite.mMsg.SelAttributes.Color := clBlack;
         PrintText := '< ' + PrintText;                       // Input data
       end;
    3: begin
         MainReadWrite.mMsg.SelAttributes.Color := clBlack;
         PrintText := '> ' + PrintText;                       // Output data
       end;
    4: begin                                                  // Critical Error Messages
         MainReadWrite.mMsg.SelAttributes.Color := clRed;
         PrintText := PrintText;
       end;
  end;
  MainReadWrite.mMsg.Lines.Add(PrintText);
  MainReadWrite.mMsg.SelAttributes.Color := clBlack;

end;

function SendAPDU(): integer;
begin

  ioRequest.dwProtocol := dwActProtocol;
  ioRequest.cbPciLength := sizeof(SCARD_IO_REQUEST);
  retCode := SCardTransmit(hCard,
                           @ioRequest,
                           @SendBuff,
                           SendLen,
                           Nil,
                           @RecvBuff,
                           @RecvLen);
  if retCode <> SCARD_S_SUCCESS then begin
    DisplayOut(1, retCode, '');
    SendAPDU := retCode;
    Exit;
  end;
  SendAPDU := retCode;

end;

function TrimInput(dataInput: String): String;
var indx: Integer;
    tmpStr: String;
begin
  tmpStr := '';
  dataInput := Trim(dataInput);
  for indx := 1 to Length(dataInput) do
    if dataInput[indx] <> chr(32) then
      tmpStr := tmpStr + dataInput[indx];
  diFlag := False;
  if (Length(tmpStr) mod 2) <> 0 then
    diFlag := True;
  TrimInput := tmpStr;
  
end;

procedure TMainReadWrite.bQuitClick(Sender: TObject);
begin

  if ConnActive then
    begin
      retCode := SCardDisconnect(hCard, SCARD_UNPOWER_CARD);
      ConnActive := False;
    end;

  retCode := SCardReleaseContext(hCard);
  Application.Terminate;

end;

procedure TMainReadWrite.bReaderClick(Sender: TObject);
begin
  // 2. List PC/SC card readers installed in the system
  BufferLen := MAX_BUFFER_LEN;
  retCode := SCardListReadersA(hContext,
                               nil,
                               @Buffer,
                               @BufferLen);
  if retCode <> SCARD_S_SUCCESS then
    begin
      DisplayOut(1, retCode, '');
      Exit;
    end
  else
    DisplayOut(0, 0, 'SCardListReaders... OK');

  MainReadWrite.cbReader.Clear;
  LoadListToControl(MainReadWrite.cbReader,@buffer,bufferLen);
  MainReadWrite.cbReader.ItemIndex := 0;
  bConnect.Enabled := True;
  bInit.Enabled := False;

end;

procedure TMainReadWrite.bInitClick(Sender: TObject);
begin

  // 1. Establish context and obtain hContext handle
  retCode := SCardEstablishContext(SCARD_SCOPE_USER,
                                   nil,
                                   nil,
                                   @hContext);
  if retCode <> SCARD_S_SUCCESS then
    begin
      DisplayOut(1, retCode, '');
      Exit;
    end
  else
    begin
      DisplayOut(0, 0, 'SCardEstablishContext... OK');
    end;

  bReader.Enabled := True;
  bRelease.Enabled := True;
  bInit.Enabled := False;

end;

procedure TMainReadWrite.cbReaderChange(Sender: TObject);
begin


  if ConnActive then
  begin
    retCode := SCardDisconnect(hCard, SCARD_UNPOWER_CARD);
    ConnActive := False;
  end;

end;

procedure TMainReadWrite.FormActivate(Sender: TObject);
begin

  InitMenu();

end;


procedure TMainReadWrite.bResetClick(Sender: TObject);
begin
    MainReadWrite.mMsg.Clear;
end;

procedure TMainReadWrite.bResetallClick(Sender: TObject);
begin
  MainReadWrite.mMsg.Clear;
  MainReadWrite.tDataIn.Clear;  
end;

procedure TMainReadWrite.bConnectClick(Sender: TObject);
begin
   if ConnActive then
  begin
    DisplayOut(0, 0,'Connection is already active.');
    Exit;
  end;

  // 1. Connect to selected reader using hContext handle
  //    and obtain valid hCard handle
  retCode := SCardConnectA(hContext,
                           PChar(cbReader.Text),
                           SCARD_SHARE_SHARED,
                           SCARD_PROTOCOL_T0 or SCARD_PROTOCOL_T1,
                           @hCard,
                           @dwActProtocol);
  if retCode <> SCARD_S_SUCCESS then
    begin
      DisplayOut(1,retCode, '');
      ConnActive := False;
      Exit;
    end
  else
    DisplayOut(0, 0,'SCardConnect...OK');

  ConnActive := True;
  bBeginTran.Enabled := True;
  bDisConnect.Enabled := True;
  bConnect.Enabled := False;
  bRelease.Enabled := False;
  bReader.Enabled := False;


end;

procedure TMainReadWrite.bBeginTranClick(Sender: TObject);
begin

    retCode := SCardBeginTransaction(hCard);
    If retCode <> SCARD_S_SUCCESS Then
      begin
        DisplayOut(1, retCode, '');
        Exit;
       end
    Else
        DisplayOut(0, 0, 'SCardBeginTransaction...OK');

    gbData.Enabled := True;
    tDataIn.SetFocus;

    bStatus.Enabled := True;
    bTransmit.Enabled := True;
    bEnd.Enabled := True;
    bBeginTran.Enabled := False;
    bDisconnect.Enabled := False;

end;

procedure TMainReadWrite.bStatusClick(Sender: TObject);
var ReaderLen, dwState: Integer;
    tmpStr: String;
    ATRVal: array [0..128] of byte;
    indx: Integer;
    ATRLen: DWORD;
begin

  // Invoke SCardStatus using hCard handle
  //    and valid reader name
  ATRLen := 32;
  ReaderLen := 0;
  dwState := 0;
  retCode := SCardStatusA(hCard,
                         PChar(cbReader.Text),
                         @ReaderLen,
                         @dwState,
                         @dwActProtocol,
                         @ATRVal,
                         @ATRLen);  //@ATRLen);
  if retCode <> SCARD_S_SUCCESS then
    begin
      DisplayOut(1,retCode, '');
      ConnActive := False;
      Exit;
    end
  else
    DisplayOut(0, 0, 'SCardStatus...OK');

  // Format ATRVal returned and display string as ATR value
  tmpStr := '';
  for indx := 0 to ATRLen-1 do
    begin
      tmpStr := tmpStr + Format('%.02X ',[ATRVal[indx]]);
    end;
  DisplayOut(3, 0,Format('ATR Value: %s',[tmpStr]));

    // Interpret dwState returned and display as active protocol
  tmpStr := '';
  case integer(dwState) of
    0: tmpStr := 'SCARD_UNKNOWN';
    1: tmpStr := 'SCARD_ABSENT';
    2: tmpStr := 'SCARD_PRESENT';
    3: tmpStr := 'SCARD_SWALLOWED';
    4: tmpStr := 'SCARD_POWERED';
    5: tmpStr := 'SCARD_NEGOTIABLE';
    6: tmpStr := 'SCARD_SPECIFIC';
    else
      tmpStr := '';
    end;
  DisplayOut(3, 0,Format('Reader State: %s',[tmpStr]));

  // Interpret dwActProtocol returned and display as active protocol
  tmpStr := '';
  case integer(dwActProtocol) of
    1: tmpStr := 'T=0';
    2: tmpStr := 'T=1';
    else
      tmpStr := 'No protocol is defined.';
    end;
  DisplayOut(3, 0,Format('Active Protocol: %s',[tmpStr]));
  ATRLen := 0;

end;
procedure TMainReadWrite.bTransmitClick(Sender: TObject);
var tmpStr, sw1sw2: String;
    indx: Integer;
begin

  if tDataIn.Text = '' then begin
    DisplayOut(4, 0, 'No data input');
    tDataIn.SetFocus;
    Exit;
  end;
  tmpStr := TrimInput(tDataIn.Text);
  if Length(tmpStr) <10 then begin
    DisplayOut(4, 0, 'Insufficient data input');
    tDataIn.SetFocus;
    Exit;
  end;
  if diFlag then begin
    DisplayOut(4, 0, 'Invalid data input, uneven number of characters');
    tDataIn.SetFocus;
    Exit;
  end;
  ClearBuffers();
  For indx := 0 to 4 do
    SendBuff[indx] := StrToInt('$' + Copy(tmpStr, indx*2+1, 2));

  // if APDU length < 6 then P3 is Le
  if Length(tmpStr) <12 then begin
    For indx := 0 to 4 do
      SendBuff[indx] := StrToInt('$' + Copy(tmpStr, indx*2+1, 2));
    SendLen := $05;
    RecvLen := SendBuff[4] + 2;
    tmpStr := '';
    for indx := 0 to 4 do
      tmpStr := tmpStr + Format('%.02X ',[SendBuff[indx]]);
    DisplayOut(2, 0, tmpStr);
    retCode := SendAPDU();
    if retCode = SCARD_S_SUCCESS then begin
      tmpStr :='';
      for indx := 0 to RecvLen-1 do
        tmpStr := tmpStr + Format('%.02X ',[RecvBuff[indx]]);
      DisplayOut(3, 0, tmpStr);
    end;
  end
  else begin
    // P3 is Lc
    For indx := 0 to 4 do
      SendBuff[indx] := StrToInt('$' + Copy(tmpStr, indx*2+1, 2));
    SendLen := $05 + SendBuff[4];
    if Length(tmpStr) <  SendLen*2 then begin
      DisplayOut(4, 0, 'Invalid data input, insufficient data length');
      tDataIn.SetFocus;
      Exit;
    end;
    For indx := 0 to SendBuff[4]-1 do
      SendBuff[indx+5] := StrToInt('$' + Copy(tmpStr, (indx+5)*2+1, 2));
    RecvLen := $02;
    tmpStr := '';
    for indx := 0 to SendLen-1 do
      tmpStr := tmpStr + Format('%.02X ',[SendBuff[indx]]);
    DisplayOut(2, 0, tmpStr);
    retCode := SendAPDU();
    if retCode = SCARD_S_SUCCESS then begin
      tmpStr :='';
      for indx := 0 to RecvLen-1 do
        tmpStr := tmpStr + Format('%.02X ',[RecvBuff[indx]]);
      DisplayOut(3, 0, tmpStr);
    end;
  end;

end;

procedure TMainReadWrite.bEndClick(Sender: TObject);
begin
    retCode := SCardEndTransaction(hCard, SCARD_LEAVE_CARD);
    If retCode <> SCARD_S_SUCCESS Then
    begin
        DisplayOut(1, retCode, '');
        Exit;
    end
    else
      DisplayOut(0, 0, 'SCardEndTransaction...OK');

    bBeginTran.Enabled := True;
    bDisconnect.Enabled := True;
    DisableAPDUInput();
    bStatus.Enabled := False;
    bTransmit.Enabled := False;
    bEnd.Enabled := False;

end;


procedure TMainReadWrite.bDisconnectClick(Sender: TObject);
begin
  If ConnActive Then
    retCode := SCardDisconnect(hCard, SCARD_UNPOWER_CARD);
    If retCode <> SCARD_S_SUCCESS Then
    begin
        DisplayOut(1, retCode, '');
        Exit;
    end
    else
      DisplayOut(0, 0, 'SCardDisconnect...OK');
  ConnActive := False;
  bConnect.Enabled := True;
  bReader.Enabled := True;
  bRelease.Enabled := True;
  bBeginTran.Enabled := False;
  bDisconnect.Enabled := False;


end;

procedure TMainReadWrite.bReleaseClick(Sender: TObject);
begin
    If ConnActive Then
     retCode := SCardReleaseContext(hContext);

    If retCode <> SCARD_S_SUCCESS Then
    begin
        DisplayOut(1, retCode, '');
        Exit;
    end
    else
      DisplayOut(0, 0, 'SCardReleaseContext...OK');
    cbReader.Items.Clear;
    cbReader.Refresh;
    cbReader.ItemIndex := 0;
    bInit.Enabled := True;
    bRelease.Enabled := False;
    bReader.Enabled := False;
    bConnect.Enabled := False;
end;

procedure TMainReadWrite.tDataInKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['a'..'z'] then Dec(Key,32);
  if Not(Key in ['0'..'9', 'A'..'F', chr(8), chr(32)]) then
    Key := #0;
end;

end.
