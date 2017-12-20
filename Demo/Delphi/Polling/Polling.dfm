object MainPolling: TMainPolling
  Left = 602
  Top = 233
  Width = 306
  Height = 299
  Caption = 'Card Detection Polling'
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
  object Label1: TLabel
    Left = 16
    Top = 64
    Width = 91
    Height = 16
    Caption = 'Select Reader'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object tip: TLabel
    Left = 24
    Top = 16
    Width = 143
    Height = 14
    Caption = 'This is a polling sample.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object slit: TLabel
    Left = 24
    Top = 40
    Width = 256
    Height = 14
    Caption = '----------------------------------------------------------------'
  end
  object cbReader: TComboBox
    Left = 120
    Top = 64
    Width = 169
    Height = 22
    ItemHeight = 14
    TabOrder = 0
    OnChange = cbReaderChange
  end
  object bInit: TButton
    Left = 16
    Top = 104
    Width = 107
    Height = 25
    Caption = '&Initialize'
    TabOrder = 1
    OnClick = bInitClick
  end
  object bStart: TButton
    Left = 16
    Top = 160
    Width = 105
    Height = 25
    Caption = 'Start'
    TabOrder = 2
    OnClick = bStartClick
  end
  object bEnd: TButton
    Left = 168
    Top = 160
    Width = 105
    Height = 25
    Caption = '&End '
    TabOrder = 3
    OnClick = bEndClick
  end
  object bReset: TButton
    Left = 168
    Top = 104
    Width = 105
    Height = 25
    Caption = '&Reset'
    TabOrder = 4
    OnClick = bResetClick
  end
  object bQuit: TButton
    Left = 96
    Top = 208
    Width = 105
    Height = 25
    Caption = '&Quit'
    TabOrder = 5
    OnClick = bQuitClick
  end
  object sbMsg: TStatusBar
    Left = 0
    Top = 241
    Width = 298
    Height = 24
    Panels = <>
  end
  object PollTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = PollTimerTimer
    Left = 16
    Top = 200
  end
end
