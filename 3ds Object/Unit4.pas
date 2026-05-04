unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, GifImage, IniFiles;

type
  TForm4 = class(TForm)
    RadioGroup1: TRadioGroup;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    GroupBox1: TGroupBox;
    SpinEdit1: TSpinEdit;
    CheckBox4: TCheckBox;
    Label1: TLabel;
    Button1: TButton;
    GroupBox2: TGroupBox;
    ComboBox1: TComboBox;
    CheckBox5: TCheckBox;
    GroupBox3: TGroupBox;
    ComboBox2: TComboBox;
    GroupBox4: TGroupBox;
    Edit1: TEdit;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
    FColorKey: TCOLOR;
  public
    { Public declarations }
    procedure WriteOptions;
    procedure ReadOptions;
  end;

var
  Form4: TForm4;
  TIF : TIniFile;

const
  LWA_COLORKEY = 1;
  LWA_ALPHA     = 2;
  WS_EX_LAYERED = $80000;

implementation

uses Unit1;

{$R *.dfm}
procedure TForm4.WriteOptions;    // ################### Options Write
var
  OPT :string;
begin
   OPT := 'Options';

   if not DirectoryExists(ExtractFilePath(Application.ExeName) + 'Options\')
   then ForceDirectories(ExtractFilePath(Application.ExeName) + 'Options\');

   TIF := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Options\Options.ini');
   with TIF do
   begin
    WriteInteger(OPT,'Pixel',RadioGroup1.ItemIndex);
    WriteBool(OPT,'ScaleOn',CheckBox4.Checked);
    WriteInteger(OPT,'Size',SpinEdit1.Value);
    WriteInteger(OPT,'Format',ComboBox1.ItemIndex);
    WriteInteger(OPT,'Direction',ComboBox2.ItemIndex);
    WriteBool(OPT,'Transparent',CheckBox1.Checked);
    WriteBool(OPT,'Grayscale',CheckBox2.Checked);
    WriteBool(OPT,'Negativ',CheckBox3.Checked);
    WriteBool(OPT,'PressJPG',CheckBox5.Checked);
    WriteBool(OPT,'ShowText',CheckBox6.Checked);
    WriteBool(OPT,'GraphicCard',CheckBox7.Checked);
    WriteString(OPT,'Text',Edit1.Text);

   //WriteBool(OPT,'SaveOptions',CheckBox1.Checked);
   //WriteInteger(OPT,'Compress',Combobox1.ItemIndex);
   //WriteInteger(OPT,'Overlay',RadioGroup1.ItemIndex);
   Free;
   end;
end;

procedure TForm4.ReadOptions;    // ################### Options Read
var
  OPT:string;
begin
  OPT := 'Options';
  if FileExists(ExtractFilePath(Application.ExeName) + 'Options\Options.ini') then
  begin
  TIF:=TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Options\Options.ini');
  with TIF do
  begin
    RadioGroup1.ItemIndex:=ReadInteger(OPT,'Pixel',RadioGroup1.ItemIndex);
    CheckBox4.Checked:=ReadBool(OPT,'ScaleOn',CheckBox4.Checked);
    SpinEdit1.Value:=ReadInteger(OPT,'Size',SpinEdit1.Value);
    ComboBox1.ItemIndex:=ReadInteger(OPT,'Format',ComboBox1.ItemIndex);
    ComboBox2.ItemIndex:=ReadInteger(OPT,'Direction',ComboBox2.ItemIndex);
    CheckBox1.Checked:=ReadBool(OPT,'Transparent',CheckBox1.Checked);
    CheckBox2.Checked:=ReadBool(OPT,'Grayscale',CheckBox2.Checked);
    CheckBox3.Checked:=ReadBool(OPT,'Negativ',CheckBox3.Checked);
    CheckBox5.Checked:=ReadBool(OPT,'CompressJPG',CheckBox5.Checked);
    CheckBox6.Checked:=ReadBool(OPT,'ShowText',CheckBox6.Checked);
    CheckBox7.Checked:=ReadBool(OPT,'GraphicCard',CheckBox7.Checked);
    Edit1.Text:=ReadString(OPT,'Text',Edit1.Text);

  //CheckBox1.Checked:=ReadBool(OPT,'SaveOptions',CheckBox1.Checked);
  //Combobox1.ItemIndex:=ReadInteger(OPT,'Compress',combobox1.ItemIndex);
  //RadioGroup1.ItemIndex:=ReadInteger(OPT,'Overlay',RadioGroup1.ItemIndex);
  Free;
  end;
  end;
end;

function MakeWindowTransparent(Wnd: HWND; nAlpha: Integer = 10): Boolean;
type
  TSetLayeredWindowAttributes = function(hwnd: HWND; crKey: COLORREF; bAlpha: Byte;
    dwFlags: Longint): Longint;
  stdcall;
var
  hUser32: HMODULE;
  SetLayeredWindowAttributes: TSetLayeredWindowAttributes;
begin
  Result := False;
  hUser32 := GetModuleHandle('USER32.DLL');
  if hUser32 <> 0 then
  begin @SetLayeredWindowAttributes := GetProcAddress(hUser32, 'SetLayeredWindowAttributes');
    if @SetLayeredWindowAttributes <> nil then
    begin
      SetWindowLong(Wnd, GWL_EXSTYLE, GetWindowLong(Wnd, GWL_EXSTYLE) or WS_EX_LAYERED);
      SetLayeredWindowAttributes(Wnd, 0, Trunc((255 / 100) * (100 - nAlpha)), LWA_ALPHA);
      Result := True;
    end;
  end;
end;

function SetLayeredWindowAttributes(
  Wnd: hwnd;
  crKey: ColorRef;
  Alpha: Byte;
  dwFlags: DWORD): Boolean;
  stdcall; external 'user32.dll';

procedure TForm4.FormCreate(Sender: TObject);
begin
  ReadOptions;
  SetWindowPos(Handle, HWND_TOPMOST, Left,Top, Width,Height,
             SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);

  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle,
            GWL_EXSTYLE) or WS_EX_LAYERED);
  SetLayeredWindowAttributes(Handle, ColorToRGB(FColorKey),
            220, LWA_ALPHA);
end;

procedure TForm4.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked = true then
  Begin
    Label1.Enabled := true;
    SpinEdit1.Enabled := true;
  end else begin
    Label1.Enabled := false;
    SpinEdit1.Enabled := false;
  end;
  Button2.Enabled := true;
end;

procedure TForm4.Button1Click(Sender: TObject);
begin
  Close();
end;

procedure TForm4.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex = 1 then
  begin
    CheckBox5.Enabled := true;
  end else begin
    CheckBox5.Enabled := false;
  end;

  case ComboBox1.ItemIndex of
  0 : begin
        RadioGroup1.Enabled := true;
        CheckBox5.Enabled := false;
      end;

  1 : begin
        RadioGroup1.Enabled := true;
        CheckBox5.Enabled := true;
      end;

  2 : begin
        RadioGroup1.Enabled := false;
        CheckBox5.Enabled := false;
      end;
  end;
  Button2.Enabled := true;
end;

procedure TForm4.CheckBox6Click(Sender: TObject);
begin
  Edit1.Enabled := CheckBox6.Checked;
  Form1.WinGL1.Invalidate;
  Button2.Enabled := true;
end;

procedure TForm4.CheckBox7Click(Sender: TObject);
begin
  Form1.WinGL1.Invalidate;
  Button2.Enabled := true;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  WriteOptions;
  Button2.Enabled := false;
end;

procedure TForm4.FormShow(Sender: TObject);
begin
  ComboBox1.OnChange(sender);
end;

procedure TForm4.RadioGroup1Click(Sender: TObject);
begin
  Button2.Enabled := true;
end;

procedure TForm4.SpinEdit1Change(Sender: TObject);
begin
  Button2.Enabled := true;
end;

procedure TForm4.ComboBox2Change(Sender: TObject);
begin
  Button2.Enabled := true;
end;

procedure TForm4.CheckBox1Click(Sender: TObject);
begin
  Button2.Enabled := true;
end;

procedure TForm4.CheckBox2Click(Sender: TObject);
begin
  Button2.Enabled := true;
end;

procedure TForm4.CheckBox3Click(Sender: TObject);
begin
  Button2.Enabled := true;
end;

procedure TForm4.CheckBox5Click(Sender: TObject);
begin
  Button2.Enabled := true;
end;

procedure TForm4.Edit1Change(Sender: TObject);
begin
  Button2.Enabled := true;
end;

end.
