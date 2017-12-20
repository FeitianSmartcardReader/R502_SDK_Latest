////////////////////////////////////////////////////////////////////////////////
//
// Company  : FTsafe, LTD.
//
// Name     : Polling
//
////////////////////////////////////////////////////////////////////////////////

unit Polling;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FTsafeModule, StdCtrls, ComCtrls, ExtCtrls;

Const MAX_BUFFER_LEN    = 256;

type
  TMainPolling = class(TForm)
    Label1: TLabel;
    cbReader: TComboBox;
    bInit: TButton;
    bStart: TButton;
    bEnd: TButton;
    bReset: TButton;
    bQuit: TButton;
    PollTimer: TTimer;
    sbMsg: TStatusBar;
    tip: TLabel;
    slit: TLabel;
    procedure bQuitClick(Sender: TObject);
    procedure bInitClick(Sender: TObject);
    procedure bResetClick(Sender: TObject);
    procedure cbReaderChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure bStartClick(Sender: TObject);
    procedure bEndClick(Sender: TObject);
    procedure PollTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainPolling : TMainPolling;
  hContext    : SCARDCONTEXT;
  hCard       : SCARDCONTEXT;
  ioRequest   : SCARD_IO_REQUEST;
  RdrState    : SCARD_READERSTATE;
  retCode     : Integer;
  dwActProtocol, BufferLen  : DWORD;
  SendBuff, RecvBuff        : array [0..262] of Byte;
  SendLen, RecvLen          : DWORD;
  Buffer      : array [0..MAX_BUFFER_LEN] of char;

procedure InitMenu();
procedure AddButtons();
procedure DisplayOut(mType: integer; PrintText: string);
implementation

{$R *.dfm}

procedure InitMenu();
begin

  MainPolling.cbReader.Clear;
  DisplayOut(0, 'Program ready');
  MainPolling.cbReader.Enabled := False;
  MainPolling.bInit.Enabled := True;
  MainPolling.bStart.Enabled := False;
  MainPolling.bEnd.Enabled := False;
  MainPolling.bReset.Enabled := False;
  MainPolling.PollTimer.Enabled := False;

end;

procedure AddButtons();
begin

  MainPolling.cbReader.Enabled := True;
  MainPolling.bInit.Enabled := False;
  MainPolling.bStart.Enabled := True;
  MainPolling.bReset.Enabled := True;

end;

procedure DisplayOut(mType: integer; PrintText: string);
begin

  case mType of
    2: begin
       PrintText := '< ' + PrintText;                      // Input data
       end;
    3: begin
       PrintText := '> ' + PrintText;                      // Output data
       end;
  end;
  MainPolling.sbMsg.SimpleText := PrintText;

end;

procedure TMainPolling.bQuitClick(Sender: TObject);
begin

  retCode := SCardReleaseContext(hCard);
  Application.Terminate;

end;

procedure TMainPolling.bInitClick(Sender: TObject);
begin

  // 1. Establish context and obtain hContext handle
  retCode := SCardEstablishContext(SCARD_SCOPE_USER,
                                   nil,
                                   nil,
                                   @hContext);
  if retCode <> SCARD_S_SUCCESS then
    begin
      DisplayOut(1, GetScardErrMsg(retCode));
      Exit;
    end ;

  // 2. List PC/SC card readers installed in the system
  BufferLen := MAX_BUFFER_LEN;
  retCode := SCardListReadersA(hContext,
                               nil,
                               @Buffer,
                               @BufferLen);
  if retCode <> SCARD_S_SUCCESS then
    begin
      DisplayOut(1, GetScardErrMsg(retCode));
      Exit;
    end
  else
    DisplayOut(0, 'Select reader and click on function to continue');

  MainPolling.cbReader.Clear;;
  LoadListToControl(MainPolling.cbReader,@buffer,bufferLen);
  MainPolling.cbReader.ItemIndex := 0;
  AddButtons();

end;

procedure TMainPolling.bResetClick(Sender: TObject);
begin

  PollTimer.Enabled := False;
  retCode := SCardReleaseContext(hCard);
  InitMenu();

end;

procedure TMainPolling.cbReaderChange(Sender: TObject);
begin

  bStart.Enabled := True;
  bEnd.Enabled := False;
  PollTimer.Enabled := False;

end;

procedure TMainPolling.FormActivate(Sender: TObject);
begin

  InitMenu();
  sbMsg.SimplePanel := True;

end;

procedure TMainPolling.bStartClick(Sender: TObject);
begin

  bStart.Enabled := False;
  bEnd.Enabled := True;
  DisplayOut(2, 'Polling started.');
  PollTimer.Enabled := True;

end;

procedure TMainPolling.bEndClick(Sender: TObject);
begin

  bStart.Enabled := True;
  bEnd.Enabled := False;
  PollTimer.Enabled := False;
  DisplayOut(2, 'Polling ended.');

end;

procedure TMainPolling.PollTimerTimer(Sender: TObject);
begin
  RdrState.szReader := PChar(MainPolling.cbReader.Text);
  retCode := SCardGetStatusChangeA(hContext,
                                 0,
                                 @RdrState,
                                 1);
  if retCode <> SCARD_S_SUCCESS then
    begin
      DisplayOut(1, GetScardErrMsg(retCode));
      MainPolling.PollTimer.Enabled := False;
      Exit;
    end ;
  if (RdrState.dwEventStates and SCARD_STATE_PRESENT) <> 0 then
    DisplayOut(3, 'Card is inserted')
  else
    DisplayOut(3, 'Card is removed');
end;

end.
