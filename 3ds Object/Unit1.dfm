object Form1: TForm1
  Left = 308
  Top = 184
  Width = 919
  Height = 667
  Caption = '3DS Object'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 903
    Height = 589
    Align = alClient
    TabOrder = 0
    object WinGL1: TWinGL
      Left = 314
      Top = 1
      Width = 444
      Height = 587
      GLMode = glAutomatic
      ClearColor.Alpha = 1.000000000000000000
      ClearDepth = 1.000000000000000000
      YFieldOfView = 45.000000000000000000
      ZNear = 1.000000000000000000
      ZFar = 100.000000000000000000
      OnPaint = WinGL1Paint
      Align = alClient
      OnMouseDown = WinGL1MouseDown
      OnMouseMove = WinGL1MouseMove
      OnMouseUp = WinGL1MouseUp
      TabOrder = 0
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 313
      Height = 587
      Align = alLeft
      TabOrder = 1
      DesignSize = (
        313
        587)
      object FileListBox1: TFileListBox
        Left = 160
        Top = 24
        Width = 145
        Height = 551
        TabStop = False
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        Mask = '*.3DS;*.OBJ;*.MD2'
        TabOrder = 0
        OnClick = FileListBox1Click
      end
      object FilterComboBox1: TFilterComboBox
        Left = 160
        Top = 0
        Width = 145
        Height = 21
        FileList = FileListBox1
        Filter = 
          '3D Files|*.3DS;*.OBJ;*.MD2|3D Studio (*.3DS)|*.3DS|Poser Wavefro' +
          'nt (*.OBJ)|*.OBJ|Quake 2 Model (*.MD2)|*.MD2|All files (*.*)|*.*'
        TabOrder = 1
        TabStop = False
      end
      object DriveComboBox1: TDriveComboBox
        Left = 8
        Top = 0
        Width = 145
        Height = 19
        DirList = DirectoryListBox1
        TabOrder = 2
        TabStop = False
      end
      object DirectoryListBox1: TDirectoryListBox
        Left = 8
        Top = 24
        Width = 145
        Height = 551
        TabStop = False
        Anchors = [akLeft, akTop, akBottom]
        FileList = FileListBox1
        ItemHeight = 16
        TabOrder = 3
      end
    end
    object Panel3: TPanel
      Left = 758
      Top = 1
      Width = 144
      Height = 587
      Align = alRight
      TabOrder = 2
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 56
        Height = 13
        Caption = 'Object Part:'
      end
      object ListBox1: TListBox
        Left = 8
        Top = 24
        Width = 121
        Height = 153
        TabStop = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Small Fonts'
        Font.Style = []
        ItemHeight = 11
        ParentFont = False
        TabOrder = 0
        OnClick = ListBox1Click
      end
      object ListBox2: TListBox
        Left = 8
        Top = 208
        Width = 121
        Height = 129
        TabStop = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Small Fonts'
        Font.Style = []
        ItemHeight = 11
        ParentFont = False
        TabOrder = 1
      end
      object Button2: TButton
        Left = 48
        Top = 416
        Width = 75
        Height = 25
        Caption = 'All Views'
        TabOrder = 2
        TabStop = False
        OnClick = Button2Click
      end
      object BitBtn2: TBitBtn
        Left = 8
        Top = 180
        Width = 121
        Height = 25
        Caption = 'Unselect'
        TabOrder = 3
        TabStop = False
        OnClick = BitBtn2Click
      end
      object CheckBox1: TCheckBox
        Left = 16
        Top = 352
        Width = 57
        Height = 17
        Caption = 'Animate'
        TabOrder = 4
        OnClick = CheckBox1Click
      end
      object Button1: TButton
        Left = 48
        Top = 448
        Width = 75
        Height = 25
        Caption = 'Reset'
        TabOrder = 5
        OnClick = Button1Click
      end
      object CheckBox2: TCheckBox
        Left = 32
        Top = 368
        Width = 57
        Height = 17
        Caption = 'Vertical'
        TabOrder = 6
        OnClick = CheckBox2Click
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 488
        Width = 129
        Height = 89
        Caption = ' Export Frames '
        TabOrder = 7
        object Button3: TButton
          Left = 40
          Top = 56
          Width = 75
          Height = 25
          Caption = 'Frames'
          TabOrder = 0
          OnClick = Button3Click
        end
        object Button4: TButton
          Left = 40
          Top = 24
          Width = 75
          Height = 25
          Caption = 'Options'
          TabOrder = 1
          OnClick = Button4Click
        end
      end
      object CheckBox3: TCheckBox
        Left = 32
        Top = 384
        Width = 97
        Height = 17
        Caption = 'Horizontal'
        Checked = True
        State = cbChecked
        TabOrder = 8
        OnClick = CheckBox3Click
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 589
    Width = 903
    Height = 19
    Panels = <
      item
        Text = 'File:'
        Width = 30
      end
      item
        Width = 450
      end
      item
        Text = 'Obj Parts:'
        Width = 55
      end
      item
        Width = 50
      end>
  end
  object MainMenu1: TMainMenu
    Left = 328
    Top = 128
    object File1: TMenuItem
      Caption = 'File'
      object Open3DS1: TMenuItem
        Caption = 'Open...'
        OnClick = Open3DS1Click
      end
      object SaveBitmap1: TMenuItem
        Caption = 'Save Bitmap...'
        OnClick = SaveBitmap1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object E1: TMenuItem
        Caption = 'Export Options'
        OnClick = E1Click
      end
      object E2: TMenuItem
        Caption = 'Export Frames'
        OnClick = E2Click
      end
      object C1: TMenuItem
        AutoCheck = True
        Caption = 'Clear Frames Folder by end'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
    end
    object G1: TMenuItem
      Caption = 'Graphic'
      object A1: TMenuItem
        AutoCheck = True
        Caption = 'Animate'
        OnClick = A1Click
      end
      object V1: TMenuItem
        AutoCheck = True
        Caption = 'Vertical'
        OnClick = V1Click
      end
      object H1: TMenuItem
        AutoCheck = True
        Caption = 'Horizontal'
        Checked = True
        OnClick = H1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Unselect1: TMenuItem
        Caption = 'Unselect Parts'
        OnClick = Unselect1Click
      end
      object R1: TMenuItem
        Caption = 'Reset'
        OnClick = R1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Allviews1: TMenuItem
        Caption = 'All Views'
        OnClick = Allviews1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object ObjectPanel1: TMenuItem
        Caption = 'View Object'
        Checked = True
        OnClick = ObjectPanel1Click
      end
      object FileBroserPanel1: TMenuItem
        Caption = 'View  File Broser'
        Checked = True
        OnClick = FileBroserPanel1Click
      end
      object Statusbar2: TMenuItem
        Caption = 'View Statusbar'
        Checked = True
        OnClick = Statusbar2Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object StayTop1: TMenuItem
        Caption = 'Stay Top'
        OnClick = StayTop1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = '3DS (*.3DS)|*.3ds;'
    Left = 360
    Top = 128
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 30
    OnTimer = Timer1Timer
    Left = 392
    Top = 128
  end
  object SaveDialog1: TSaveDialog
    Left = 424
    Top = 128
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer2Timer
    Left = 392
    Top = 160
  end
end
