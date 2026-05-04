object Form2: TForm2
  Left = 536
  Top = 163
  BorderStyle = bsDialog
  Caption = 'Export Bitmap'
  ClientHeight = 358
  ClientWidth = 679
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
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 377
    Height = 345
    Shape = bsFrame
  end
  object Bevel2: TBevel
    Left = 392
    Top = 8
    Width = 281
    Height = 345
    Shape = bsFrame
  end
  object SpeedButton1: TSpeedButton
    Left = 400
    Top = 324
    Width = 50
    Height = 22
    Caption = 'Save'
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 472
    Top = 324
    Width = 97
    Height = 22
    Caption = 'Reset'
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 568
    Top = 324
    Width = 97
    Height = 22
    Caption = 'Reload'
    OnClick = SpeedButton3Click
  end
  object SpeedButton4: TSpeedButton
    Left = 16
    Top = 324
    Width = 50
    Height = 22
    Caption = 'Save'
    OnClick = SpeedButton4Click
  end
  object WinGL1: TWinGL
    Left = 16
    Top = 16
    Width = 361
    Height = 305
    GLMode = glAutomatic
    ClearColor.Red = 1.000000000000000000
    ClearColor.Blue = 1.000000000000000000
    ClearColor.Alpha = 1.000000000000000000
    ClearDepth = 1.000000000000000000
    YFieldOfView = 30.000000000000000000
    ZNear = 1.000000000000000000
    ZFar = 100.000000000000000000
    OnPaint = WinGL1Paint
    TabOrder = 0
  end
  object WinGL2: TWinGL
    Left = 400
    Top = 16
    Width = 265
    Height = 305
    GLMode = glAutomatic
    ClearDepth = 1.000000000000000000
    YFieldOfView = 45.000000000000000000
    ZNear = 0.100000000000000000
    ZFar = 100.000000000000000000
    OnPaint = WinGL2Paint
    OnMouseDown = WinGL2MouseDown
    OnMouseMove = WinGL2MouseMove
    TabOrder = 1
  end
  object SavePictureDialog1: TSavePictureDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Left = 40
    Top = 88
  end
end
