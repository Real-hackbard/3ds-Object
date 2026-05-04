unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinGL, StdCtrls, DelphiGL, GLRender, ExtDlgs, ExtCtrls, Buttons;

type
  TForm2 = class(TForm)
    SavePictureDialog1: TSavePictureDialog;
    Bevel1: TBevel;
    Bevel2: TBevel;
    WinGL1: TWinGL;
    WinGL2: TWinGL;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure WinGL1Paint(Sender: TObject);
    procedure WinGL2Paint(Sender: TObject);
    procedure WinGL2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure WinGL2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Objet:TGLObject;
    rx,ry,rz:single;
    tz:single;
    mx,my:integer;
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
  SetWindowPos(Handle, HWND_TOPMOST, Left,Top, Width,Height,
             SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  //WinGL1.ClearColor.Green := 1;
  Objet:=TGLObject.Create;
  Objet.LoadFromFile(Form1.StatusBar1.Panels[1].Text);
  Objet.Normalise;
  rx:=-90;
  tz:=-1.5;
end;

procedure TForm2.WinGL1Paint(Sender: TObject);
const
  k=2; d=2*k/3;
begin
 glMatrixMode(GL_PROJECTION);
 glLoadIdentity;
 glOrtho(-k,+k, -k,+k, -1,+1);
 glMatrixMode(GL_MODELVIEW);
 glLoadIdentity;

 Objet.Reset;
 Objet.Rotate(rx,ry,rz);
 Objet.Rotate(0,-90,0);
 Objet.Render;
 glTranslatef(d,0,0);
 Objet.Rotate(0,90,0);
 Objet.Rotate(45,0,0);
 Objet.Render;
 glTranslatef(-2*d,0,0);
 Objet.Rotate(0,180,0);
 Objet.Rotate(90,0,0);
 Objet.Render;
 glTranslatef(d,-d,0);
 Objet.Rotate(-45,90,0);
 Objet.Rotate(45,0,0);
 Objet.Render;
 glTranslatef(0,2*d,0);
 Objet.Rotate(-90,180,0);
 Objet.Render;
end;

procedure TForm2.WinGL2Paint(Sender: TObject);
begin
   glTranslatef(0,0,tz);
   Objet.Reset;
   Objet.Rotate(rx,ry,rz);
   Objet.Render;
end;

procedure TForm2.WinGL2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   mx:=x; my:=y;
end;

procedure TForm2.WinGL2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ssLeft in Shift then begin
  rx:=rx+(y-my);
  ry:=ry+(x-mx);
  WinGL2.Invalidate;
  WinGL1.Invalidate;
 end;
 if ssRight in Shift then begin
  rz:=rz+(x-mx);
  tz:=tz+(my-y)/100;
  WinGL2.Invalidate;
  WinGL1.Invalidate;
 end; mx:=x; my:=y;
end;

procedure TForm2.SpeedButton1Click(Sender: TObject);
var
  bmp:TBitmap; cnv:TCanvas; r:TRect;
begin
 if SavePictureDialog1.Execute then begin
  bmp:=TBitmap.Create;
  cnv:=TCanvas.Create;
  cnv.Handle:=WinGL2.DC;
  r:=WinGL2.ClientRect;
  bmp.width :=r.right-r.left;
  bmp.height:=r.bottom-r.left;
  bmp.Canvas.CopyRect(r,cnv,r);
  cnv.free;
  bmp.savetofile(SavePictureDialog1.FileName + '.bmp');
  bmp.free;
 end;
end;

procedure TForm2.SpeedButton2Click(Sender: TObject);
begin
   rx:=-90;
 ry:=0;
 rz:=0;
 tz:=-1.5;
 WinGL1.Invalidate;
 WinGL2.Invalidate;
end;

procedure TForm2.SpeedButton3Click(Sender: TObject);
begin
     Objet:=TGLObject.Create;
  Objet.LoadFromFile(Form1.StatusBar1.Panels[1].Text);
 Objet.Normalise;
 rx:=-90;
 tz:=-1.5;
 WinGL1.Invalidate;
 WinGL2.Invalidate;
end;

procedure TForm2.SpeedButton4Click(Sender: TObject);
var
  bmp:TBitmap; cnv:TCanvas; r:TRect;
begin
 if SavePictureDialog1.Execute then
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
    bmp.savetofile(SavePictureDialog1.FileName + '.bmp');
 finally
    bmp.free;
 end;
 end;
end;
end.
