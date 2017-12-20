object MainReadWrite: TMainReadWrite
  Left = 655
  Top = 120
  Width = 455
  Height = 775
  Caption = 'FTsafe Simple PCSC'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 14
  object GroupBox2: TGroupBox
    Left = 8
    Top = 0
    Width = 433
    Height = 713
    TabOrder = 7
    object Label1: TLabel
      Left = 24
      Top = 24
      Width = 259
      Height = 19
      Caption = 'This is a simple PCSC application.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 24
      Top = 56
      Width = 384
      Height = 14
      Caption = 
        '----------------------------------------------------------------' +
        '--------------------------------'
    end
    object bConnect: TButton
      Left = 24
      Top = 178
      Width = 169
      Height = 33
      Caption = 'SCardConnect'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = bConnectClick
    end
    object bBeginTran: TButton
      Left = 232
      Top = 178
      Width = 169
      Height = 34
      Caption = 'SCardBeginTransaction'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = bBeginTranClick
    end
    object bStatus: TButton
      Left = 24
      Top = 580
      Width = 169
      Height = 33
      Caption = 'SCardStatus'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = bStatusClick
    end
    object bTransmit: TButton
      Left = 240
      Top = 580
      Width = 169
      Height = 33
      Caption = 'SCardTransmit'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = bTransmitClick
    end
    object bEnd: TButton
      Left = 24
      Top = 628
      Width = 169
      Height = 33
      Caption = 'SCardEndTransaction'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = bEndClick
    end
    object bDisconnect: TButton
      Left = 240
      Top = 628
      Width = 169
      Height = 33
      Caption = 'SCardDisconnect'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      OnClick = bDisconnectClick
    end
    object bRelease: TButton
      Left = 24
      Top = 673
      Width = 169
      Height = 33
      Caption = 'SCardReleaseContext'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      OnClick = bReleaseClick
    end
    object gbData: TGroupBox
      Left = 24
      Top = 496
      Width = 385
      Height = 73
      Caption = 'APDU Input'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      object Label7: TLabel
        Left = 8
        Top = 56
        Width = 131
        Height = 14
        Caption = '(Use HEX values only)'
      end
      object tDataIn: TEdit
        Left = 8
        Top = 24
        Width = 369
        Height = 25
        AutoSize = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnKeyPress = tDataInKeyPress
      end
    end
    object bResetall: TButton
      Left = 240
      Top = 448
      Width = 169
      Height = 33
      Caption = 'Clear All'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = bResetallClick
    end
    object gbOutData: TGroupBox
      Left = 24
      Top = 216
      Width = 385
      Height = 217
      Caption = 'Data Output'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 9
    end
  end
  object GroupBox1: TGroupBox
    Left = 32
    Top = 120
    Width = 385
    Height = 49
    Caption = 'Port'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
  end
  object cbReader: TComboBox
    Left = 40
    Top = 136
    Width = 369
    Height = 22
    ItemHeight = 14
    TabOrder = 0
    OnChange = cbReaderChange
  end
  object mMsg: TRichEdit
    Left = 40
    Top = 240
    Width = 369
    Height = 177
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object bInit: TButton
    Left = 32
    Top = 80
    Width = 169
    Height = 33
    Caption = 'SCardEstablishContext'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = bInitClick
  end
  object bReader: TButton
    Left = 240
    Top = 80
    Width = 169
    Height = 33
    Caption = 'SCardListReaders'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = bReaderClick
  end
  object bReset: TButton
    Left = 32
    Top = 448
    Width = 169
    Height = 33
    Caption = 'Clear Output Window'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = bResetClick
  end
  object bQuit: TButton
    Left = 248
    Top = 673
    Width = 169
    Height = 33
    Caption = '&Quit'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = bQuitClick
  end
  object btStatus: TStatusBar
    Left = 0
    Top = 714
    Width = 447
    Height = 27
    Panels = <>
  end
end
