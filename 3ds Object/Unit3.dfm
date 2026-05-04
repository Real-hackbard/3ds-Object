object Form3: TForm3
  Left = 834
  Top = 140
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Export Frames'
  ClientHeight = 155
  ClientWidth = 399
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 24
    Width = 36
    Height = 11
    Caption = 'Frames :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 24
    Top = 40
    Width = 43
    Height = 11
    Caption = 'Progress :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 72
    Top = 24
    Width = 28
    Height = 11
    Caption = 'picture'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 72
    Top = 40
    Width = 30
    Height = 11
    Caption = 'Bitmap'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 16
    Top = 64
    Width = 369
    Height = 50
  end
  object ProgressBar1: TProgressBar
    Left = 24
    Top = 80
    Width = 353
    Height = 17
    Max = 360
    TabOrder = 0
  end
  object Button1: TButton
    Left = 304
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Abort'
    TabOrder = 1
    OnClick = Button1Click
  end
end
