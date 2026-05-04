object Form4: TForm4
  Left = 759
  Top = 135
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Export Options'
  ClientHeight = 270
  ClientWidth = 442
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RadioGroup1: TRadioGroup
    Left = 16
    Top = 24
    Width = 65
    Height = 81
    Caption = ' Pixel Bit '
    ItemIndex = 2
    Items.Strings = (
      '8'
      '24'
      '32')
    TabOrder = 0
    OnClick = RadioGroup1Click
  end
  object CheckBox1: TCheckBox
    Left = 24
    Top = 120
    Width = 76
    Height = 17
    Caption = 'Transparent'
    TabOrder = 1
    OnClick = CheckBox1Click
  end
  object CheckBox2: TCheckBox
    Left = 24
    Top = 144
    Width = 67
    Height = 17
    Caption = 'Grayscale'
    TabOrder = 2
    OnClick = CheckBox2Click
  end
  object CheckBox3: TCheckBox
    Left = 24
    Top = 168
    Width = 57
    Height = 17
    Caption = 'Negativ'
    TabOrder = 3
    OnClick = CheckBox3Click
  end
  object GroupBox1: TGroupBox
    Left = 88
    Top = 24
    Width = 113
    Height = 81
    Caption = ' Scale Bitmap '
    TabOrder = 4
    object Label1: TLabel
      Left = 16
      Top = 52
      Width = 28
      Height = 13
      Caption = 'Pixel :'
      Enabled = False
    end
    object SpinEdit1: TSpinEdit
      Left = 48
      Top = 48
      Width = 57
      Height = 22
      Enabled = False
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 512
      OnChange = SpinEdit1Change
    end
    object CheckBox4: TCheckBox
      Left = 8
      Top = 24
      Width = 57
      Height = 17
      Caption = 'Activate'
      TabOrder = 1
      OnClick = CheckBox4Click
    end
  end
  object Button1: TButton
    Left = 344
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 5
    OnClick = Button1Click
  end
  object GroupBox2: TGroupBox
    Left = 208
    Top = 24
    Width = 105
    Height = 81
    Caption = ' File Format '
    TabOrder = 6
    object ComboBox1: TComboBox
      Left = 8
      Top = 48
      Width = 89
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = 'Bitmap'
      OnChange = ComboBox1Change
      Items.Strings = (
        'Bitmap'
        'Jpg/Jpeg'
        'GIF')
    end
  end
  object CheckBox5: TCheckBox
    Left = 24
    Top = 192
    Width = 85
    Height = 17
    Caption = 'Compress Jpg'
    Enabled = False
    TabOrder = 7
    OnClick = CheckBox5Click
  end
  object GroupBox3: TGroupBox
    Left = 320
    Top = 24
    Width = 105
    Height = 81
    Caption = ' Direction '
    TabOrder = 8
    object ComboBox2: TComboBox
      Left = 8
      Top = 48
      Width = 89
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = 'Vertical'
      OnChange = ComboBox2Change
      Items.Strings = (
        'Vertical'
        'Horizontal'
        'Both')
    end
  end
  object GroupBox4: TGroupBox
    Left = 208
    Top = 112
    Width = 217
    Height = 105
    Caption = 'Show Text :'
    TabOrder = 9
    object Edit1: TEdit
      Left = 16
      Top = 64
      Width = 185
      Height = 21
      Enabled = False
      TabOrder = 0
      Text = 'Coded for - github.com'
      OnChange = Edit1Change
    end
    object CheckBox6: TCheckBox
      Left = 16
      Top = 32
      Width = 60
      Height = 17
      Caption = 'Activate'
      TabOrder = 1
      OnClick = CheckBox6Click
    end
    object CheckBox7: TCheckBox
      Left = 112
      Top = 32
      Width = 84
      Height = 17
      Caption = 'Graphic Card'
      TabOrder = 2
      OnClick = CheckBox7Click
    end
  end
  object Button2: TButton
    Left = 256
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 10
    TabStop = False
    OnClick = Button2Click
  end
end
