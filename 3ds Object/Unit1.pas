unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, FileCtrl, StdCtrls, WinGL, ExtCtrls, DelphiGL, GLRender,
  ComCtrls, Buttons, XPMan, Menus, Spin, Jpeg, GIFImage, ShellApi;

type
  TForm1 = class(TForm)
    WinGL1: TWinGL;
    FileListBox1: TFileListBox;
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    FilterComboBox1: TFilterComboBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    StatusBar1: TStatusBar;
    Button2: TButton;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Options1: TMenuItem;
    Close1: TMenuItem;
    SaveBitmap1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Open3DS1: TMenuItem;
    N1: TMenuItem;
    Unselect1: TMenuItem;
    ObjectPanel1: TMenuItem;
    FileBroserPanel1: TMenuItem;
    N3: TMenuItem;
    Statusbar2: TMenuItem;
    StayTop1: TMenuItem;
    Timer1: TTimer;
    CheckBox1: TCheckBox;
    Button1: TButton;
    CheckBox2: TCheckBox;
    GroupBox1: TGroupBox;
    Button3: TButton;
    SaveDialog1: TSaveDialog;
    Timer2: TTimer;
    Button4: TButton;
    G1: TMenuItem;
    R1: TMenuItem;
    E1: TMenuItem;
    N2: TMenuItem;
    E2: TMenuItem;
    A1: TMenuItem;
    N4: TMenuItem;
    CheckBox3: TCheckBox;
    Allviews1: TMenuItem;
    N5: TMenuItem;
    V1: TMenuItem;
    H1: TMenuItem;
    C1: TMenuItem;
    procedure WinGL1Paint(Sender: TObject);
    procedure WinGL1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure WinGL1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure WinGL1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure SaveBitmap1Click(Sender: TObject);
    procedure Open3DS1Click(Sender: TObject);
    procedure Unselect1Click(Sender: TObject);
    procedure ObjectPanel1Click(Sender: TObject);
    procedure FileBroserPanel1Click(Sender: TObject);
    procedure Statusbar2Click(Sender: TObject);
    procedure StayTop1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure E2Click(Sender: TObject);
    procedure A1Click(Sender: TObject);
    procedure Allviews1Click(Sender: TObject);
    procedure V1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure H1Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    mm,mx,my:integer;
    rx,ry,rz:single;
    tz:single;
    procedure OnLog(s:string);
  public
    { Public declarations }
    obj:TGLObject;
    count : integer;
    abort : boolean;
  end;

var
  Form1: TForm1;

implementation

uses Unit2, Unit3, Unit4;

{$R *.dfm}

function DeleteFile(const AFile: string): boolean;
var
 sh: SHFileOpStruct;
begin
 ZeroMemory(@sh, sizeof(sh));
 with sh do
   begin
   Wnd := Application.Handle;
   wFunc := fo_Delete;
   pFrom := PChar(AFile +#0);
   fFlags := fof_Silent or fof_NoConfirmation;
   end;
 result := SHFileOperation(sh) = 0;
end;

procedure StretchGraphic(const src, dest: TGraphic;
  DestWidth, DestHeight: integer; Smooth: Boolean = true);
var
  temp, aCopy: TBitmap;
  faktor: double;
begin
  Assert(Assigned(src) and Assigned(dest));
  if (src.Width = 0) or (src.Height = 0) then
    raise Exception.CreateFmt('Invalid source dimensions: %d x %d',[src.Width, src.Height]);
  if src.Width > DestWidth then
    begin
      faktor := DestWidth / src.Width;
      if (src.Height * faktor) > DestHeight then
        faktor := DestHeight / src.Height;
    end
  else
    begin
      faktor := DestHeight / src.Height;
      if (src.Width * faktor) > DestWidth then
        faktor := DestWidth / src.Width;
    end;
  try
    aCopy := TBitmap.Create;
    try
      aCopy.PixelFormat := pf24Bit;
      aCopy.Assign(src);
      temp := TBitmap.Create;
      try
        temp.Width := round(src.Width * faktor);
        temp.Height := round(src.Height * faktor);
        if Smooth then
          SetStretchBltMode(temp.Canvas.Handle, HALFTONE);
        StretchBlt(temp.Canvas.Handle, 0, 0, temp.Width, temp.Height,
          aCopy.Canvas.Handle, 0, 0, aCopy.Width, aCopy.Height, SRCCOPY);
        dest.Assign(temp);
      finally
        temp.Free;
      end;
    finally
      aCopy.Free;
    end;
  except
    on E: Exception do
      MessageBox(0, PChar(E.Message), nil, MB_OK or MB_ICONERROR);
  end;
end;

function InvertRGB(MyBitmap: TBitmap): TBitmap;
var
  x, y: Integer;
  ByteArray: PByteArray;
begin
  MyBitmap.PixelFormat := pf24Bit;
  for y := 0 to MyBitmap.Height - 1 do
  begin
    ByteArray := MyBitmap.ScanLine[y];
    for x := 0 to MyBitmap.Width * 3 - 1 do
    begin
      ByteArray[x] := 255 - ByteArray[x];
    end;
  end;
  Result := MyBitmap;
end;

procedure ImageGrayScale(var AnImage: TImage);
var
  JPGImage: TJPEGImage;
  BMPImage: TBitmap;
  MemStream: TMemoryStream;
begin
  BMPImage := TBitmap.Create;
  try
    BMPImage.Width  := AnImage.Picture.Bitmap.Width;
    BMPImage.Height := AnImage.Picture.Bitmap.Height;

    JPGImage := TJPEGImage.Create;
    try
      JPGImage.Assign(AnImage.Picture.Bitmap);
      JPGImage.CompressionQuality := 100;
      JPGImage.Compress;
      JPGImage.Grayscale := True;

      BMPImage.Canvas.Draw(0, 0, JPGImage);

      MemStream := TMemoryStream.Create;
      try
        BMPImage.SaveToStream(MemStream);
        //you need to reset the position of the MemoryStream to 0
        MemStream.Position := 0;

        AnImage.Picture.Bitmap.LoadFromStream(MemStream);
        AnImage.Refresh;
      finally
        MemStream.Free;
      end;
    finally
      JPGImage.Free;
    end;
  finally
    BMPImage.Free;
  end;
end;

procedure TForm1.WinGL1Paint(Sender: TObject);
begin
  obj.Reset;
  obj.Rotate(rx,ry,rz);
  glTranslatef(0,0,tz);
  obj.Render;
  obj.RenderSelection(ListBox1.ItemIndex);
end;

procedure TForm1.WinGL1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mm:=ord(Button)+1;
  mx:=x;
  my:=y;
end;

procedure TForm1.WinGL1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if CheckBox1.Checked = true then Timer1.Enabled := true;
  mm:=0;
end;

procedure TForm1.WinGL1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 case mm of
  0: exit;
  1: begin
    Timer1.Enabled := false;
   rx:=rx+(y-my);
   ry:=ry+(x-mx);
   WinGL1.Invalidate;
  end;
  2: begin
   tz:=tz+(my-y)/100;
   WinGL1.Invalidate;
  end;
 end;
 mx:=x;
 my:=y;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  obj:=TGLObject.Create;
  {$ifdef log}
  Log:=OnLog;
  {$endif}
  DirectoryListBox1.Directory := ExtractFilePath(Application.ExeName) + 'Modells\';

  count := 0;
  abort := false;

  {$ifdef log}
   Memo1.Lines.BeginUpdate;
   Memo1.Lines.Clear;
 {$endif}

  obj.LoadFromFile(ExtractFilePath(Application.ExeName) +
                      'Modells\Transformer.3DS');
  ListBox1.Items.Assign(obj.Groups);
  listBox2.Items.Clear;
  for i:=0 to obj.MaterialCount-1 do
   ListBox2.Items.Add(obj.MaterialNames[i]);

 {$ifdef log}
  Memo1.Lines.EndUpdate;
 {$endif}

 StatusBar1.Panels[1].Text := ExtractFilePath(Application.ExeName) +
                                'Modells\Transformer.3DS';

 
 obj.Normalise;
 rx:=-90;
 ry:=0;
 rz:=0;
 tz:=-2;
end;

procedure TForm1.OnLog(s:string);
 begin
  //memo1.lines.Add(s);
 end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
 WinGL1.Invalidate;
 StatusBar1.Panels[3].Text := ListBox1.Items.Text;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  try
    form2 := TForm2.Create(self);
    form2.Show;
  finally
  end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  ListBox1.ItemIndex:=-1;
  WinGL1.Invalidate;
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
  Close();
end;

procedure TForm1.SaveBitmap1Click(Sender: TObject);
var
  bmp:TBitmap; cnv:TCanvas; r:TRect;
begin
 if SaveDialog1.Execute then
 begin
 try
    bmp:=TBitmap.Create;
    cnv:=TCanvas.Create;
    cnv.Handle:=WinGL1.DC;
    r:=WinGL1.ClientRect;
    bmp.width :=r.right-r.left;
    bmp.height:=r.bottom-r.left;
    bmp.Canvas.CopyRect(r,cnv,r);
    cnv.free;
    bmp.savetofile(SaveDialog1.FileName + '.bmp');
 finally
    bmp.free;
 end;
 end;
end;

procedure TForm1.Open3DS1Click(Sender: TObject);
var
  i:integer;
begin
  if OpenDialog1.Execute then begin
 {$ifdef log}
 Memo1.Lines.BeginUpdate;
 Memo1.Lines.Clear;
 {$endif}
 obj.LoadFromFile(OpenDialog1.FileName);
 ListBox1.Items.Assign(obj.Groups);
 listBox2.Items.Clear;
 for i:=0 to obj.MaterialCount-1 do ListBox2.Items.Add(obj.MaterialNames[i]);
 {$ifdef log}
 Memo1.Lines.EndUpdate;
 {$endif}
 obj.Normalise;
 rx:=0;
 ry:=0;
 rz:=0;
 tz:=-2;
 WinGL1.Invalidate;
 StatusBar1.Panels[1].Text := OpenDialog1.FileName; end;
end;
procedure TForm1.Unselect1Click(Sender: TObject);
begin
   BitBtn2.Click;
end;

procedure TForm1.ObjectPanel1Click(Sender: TObject);
begin
   if ObjectPanel1.Checked = true then
   begin
     ObjectPanel1.Checked := false;
     Panel3.Visible := false;
   end else begin
     ObjectPanel1.Checked := true;
     Panel3.Visible := true;
   end;
end;

procedure TForm1.FileBroserPanel1Click(Sender: TObject);
begin
  if FileBroserPanel1.Checked = true then
  begin
    FileBroserPanel1.Checked := false;
    Panel2.Visible := false;
  end else begin
    FileBroserPanel1.Checked := true;
    Panel2.Visible := true;
  end;
end;

procedure TForm1.Statusbar2Click(Sender: TObject);
begin
  if Statusbar2.Checked = true then begin Statusbar2.Checked := false;
  Statusbar1.Visible := false; end else begin Statusbar2.Checked := true;
  Statusbar1.Visible := true; end;
end;

procedure TForm1.StayTop1Click(Sender: TObject);
begin
    if StayTop1.Checked = false then
    begin
      StayTop1.Checked := true;
      SetWindowPos(Handle, HWND_TOPMOST, Left,Top, Width,Height,
      SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
    end else begin
      StayTop1.Checked := false;
      SetWindowPos(Handle, HWND_NOTOPMOST, Left,Top, Width,Height,
      SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
    end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  x, y : integer;
begin
  if CheckBox2.Checked = true then
  begin
    rx:=rx+(1);
  end;
  if CheckBox3.Checked = true then
  begin
    ry:=ry+(1);
  end;
  WinGL1.Invalidate;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked = true then
  begin
    Timer1.Enabled := true;
    A1.Checked := true;
  end else begin
    Timer1.Enabled := false;
    A1.Checked := false;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  rx:= -90;
  ry:= 0;
  WinGL1.Invalidate;
end;

procedure TForm1.FileListBox1Click(Sender: TObject);
var
  i:integer;
begin
 {$ifdef log}
   Memo1.Lines.BeginUpdate;
   Memo1.Lines.Clear;
 {$endif}

 obj.LoadFromFile(FileListBox1.FileName);
 ListBox1.Items.Assign(obj.Groups);
 listBox2.Items.Clear;
 for i:=0 to obj.MaterialCount-1 do
  ListBox2.Items.Add(obj.MaterialNames[i]);

 {$ifdef log}
  Memo1.Lines.EndUpdate;
 {$endif}

 obj.Normalise;
 rx:=-90;
 ry:=0;
 rz:=0;
 tz:=-2;

 //WinGL1.Font.Name := 'Verdana';
 //WinGL1.Font.Color := clLime;
 //WinGL1.TextOut(100,100, 'Hallo');

 WinGL1.Invalidate;
 StatusBar1.Panels[1].Text := FileListBox1.FileName;
end;


procedure TForm1.Timer2Timer(Sender: TObject);
var
  bmp, Neg : TBitmap;
  cnv: TCanvas;
  r: TRect;
  Image : TImage;
  Jpg: TJPEGImage;
  gif: TGIFImage;
begin
  // rotation of the GL graphic
  case Form4.ComboBox2.ItemIndex of
  0 : ry:=ry+(1);
  1 : rx:=rx+(1);
  2 : begin
        rx:=rx+(1);
        ry:=ry+(1);
      end;
  end;


  WinGL1.Invalidate;

  try
    // abort the export progress
    if abort = true then
    begin
      Timer2.Enabled := false;
    end;

    bmp:= TBitmap.Create;
    cnv:= TCanvas.Create;

    // Capture the GL graphic
    cnv.Handle:= WinGL1.DC;
    r:= WinGL1.ClientRect;

    // Adjust the image size
    bmp.width := r.right-r.left;
    bmp.height:= r.bottom-r.left;

    // Copy the GL graphic as a canvas.
    bmp.Canvas.CopyRect(r,cnv,r);

    // calculate grayscale
    if Form4.CheckBox2.Checked = true then
    begin
      try
        Image := TImage.Create(self);
        Image.Picture.Bitmap.Assign(bmp);
        ImageGrayScale(Image);
        bmp.Assign(Image.Picture.Bitmap);
      finally
        Image.Free
      end;
    end;

    // scale bitmap export
    if Form4.CheckBox4.Checked = true then
    Begin
      StretchGraphic(bmp, bmp,
      Form4.SpinEdit1.Value, Form4.SpinEdit1.Value,  true);
    end;

    // bitmap pixel bits
    case Form4.RadioGroup1.ItemIndex of
    0 : bmp.PixelFormat := pf8bit;
    1 : bmp.PixelFormat := pf24bit;
    2 : bmp.PixelFormat := pf32bit;
    end;

    // set bitmap transparent
    if Form4.CheckBox1.Checked = true then
    begin
      bmp.TransparentColor := clBlack;
      bmp.Transparent := true;
    end;

    // create negativ bitmaps
    if Form4.CheckBox3.Checked = true then
    begin
      InvertRGB(bmp);
    end;

    // frame counts max=(360) for one revolution
    count := count + 1;

    // export frames in different formats
    case Form4.ComboBox1.ItemIndex of
    0 : bmp.savetofile(ExtractFilePath(Application.ExeName) + 'Frames\' +
                                          IntToStr(count) + '.bmp');
    1 : begin
          Jpg := TJPEGImage.Create;
          try
            Jpg.Assign(Bmp);
            if Form4.CheckBox1.Checked = true then
            begin
              Jpg.Transparent := true;
            end;

            if Form4.CheckBox5.Checked = true then
            begin
              Jpg.CompressionQuality := 100;
              Jpg.Compress;
            end;

            Jpg.SaveToFile(ExtractFilePath(Application.ExeName) + 'Frames\' +
                                          IntToStr(count) + '.jpg');
          finally
            Jpg.Free;
          end;
        end;
    2 : begin
         gif := TGifImage.Create;
          try
            gif.Assign(bmp);
            if Form4.CheckBox1.Checked = true then
            begin
              gif.Transparent := true;
            end;
            gif.SaveToFile(ExtractFilePath(Application.ExeName) + 'Frames\' +
                                          IntToStr(count) + '.gif');
          finally
            gif.Free;
          end;

        end;
    end;


  finally

    if Form4.ComboBox1.ItemIndex = 0 then
    begin
      Form3.Label3.Caption := IntToStr(count) + '.bmp';
      Form3.Label4.Caption := 'Create Bitmap Frames';
    end;

    if Form4.ComboBox1.ItemIndex = 1 then
    begin
      Form3.Label3.Caption := IntToStr(count) + '.jpg';
      Form3.Label4.Caption := 'Create Joint Photographic Experts Group Frames';
    end;

    if Form4.ComboBox1.ItemIndex = 2 then
    begin
      Form3.Label3.Caption := IntToStr(count) + '.gif';
      Form3.Label4.Caption := 'Create Graphics Interchange Format Frames';
    end;




    Form3.ProgressBar1.Position := count;

    bmp.free;
    cnv.free;
    if count = 360 then
    begin
      Form3.Close;
      count := 0;
      Timer2.Enabled := false;
      Beep;
    end;
 end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  count := 0;
  abort := false;
  rx:= -90;
  ry:= 0;
  WinGL1.Invalidate;
  Form3.Show;
  Timer2.Enabled := true;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Form4.Show;
end;

procedure TForm1.R1Click(Sender: TObject);
begin
  Button1.OnClick(self);
end;

procedure TForm1.E1Click(Sender: TObject);
begin
  Button4.OnClick(self);
end;

procedure TForm1.E2Click(Sender: TObject);
begin
  Button3.OnClick(self);
end;

procedure TForm1.A1Click(Sender: TObject);
begin
  Timer1.Enabled := A1.Checked;
  CheckBox1.Checked := not CheckBox1.Checked;
end;

procedure TForm1.Allviews1Click(Sender: TObject);
begin
  Button2.OnClick(self);
end;

procedure TForm1.V1Click(Sender: TObject);
begin
  CheckBox2.Checked := not CheckBox2.Checked;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.Checked = true then
  begin
    V1.Checked := true;
  end else begin
    V1.Checked := false;
  end;
end;

procedure TForm1.H1Click(Sender: TObject);
begin
  CheckBox3.Checked := not CheckBox3.Checked;
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  if CheckBox3.Checked = true then
  begin
    H1.Checked := true;
  end else begin
    H1.Checked := false;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if C1.Checked = true then
    DeleteFile(ExtractFilePath(Application.ExeName) + 'Frames\*.*');
end;

end.
