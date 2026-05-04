unit WinGL;

{
  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation; either version 2
  of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}

interface

{$DEFINE DESIGN} // add some design-time functions

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, DelphiGL;

type
  TCapability=(
   ALPHA_TEST,
   AUTO_NORMAL,
   BLEND,
   COLOR_MATERIAL,
   CULL_FACE,
   DEPTH_TEST,
   DITHER,
   FOG,
   LIGHTING,
   LINE_SMOOTH,
   LINE_STIPPLE,
   LOGIC_OP,
   NORMALIZE,
   POINT_SMOOTH,
   POLYGON_SMOOTH,
   POLYGON_STIPPLE,
   SCISSOR_TEST,
   STENCIL_TEST,
   TEXTURE_1D,
   TEXTURE_2D,
   TEXTURE_GEN_Q,
   TEXTURE_GEN_R,
   TEXTURE_GEN_S,
   TEXTURE_GEN_T
  );

  TCapabilities=set of TCapability;

  TDepthFunc=(
   ALWAYS,
   EQUAL,
   GEQUAL,
   GREATER,
   LEQUAL,
   LESS,
   NEVER,
   NOTEQUAL
  );

  TShadeModel=(
   FLAT,
   SMOOTH
  );

  TBuffer=(
   ACCUM_BUFFER_BIT,
   COLOR_BUFFER_BIT,
   DEPTH_BUFFER_BIT,
   STENCIL_BUFFER_BIT
  );
  TBuffers=set of TBuffer;

  TFloats=class(TPersistent)
  private
   Values:array[0..3] of single;
  public 
   procedure Assign(Source:TPersistent); override;
  end;

  TGLColor=class(TFloats)
  published
   property Red  :single read Values[0] write Values[0];
   property Green:single read Values[1] write Values[1];
   property Blue :single read Values[2] write Values[2];
   property Alpha:single read Values[3] write Values[3];
  end;

  TGLPoint=class(TFloats)
  published
   property x:single read Values[0] write Values[0];
   property y:single read Values[1] write Values[1];
   property z:single read Values[2] write Values[2];
   property w:single read Values[3] write Values[3];
  end;

  TGLMode=(glAutomatic,glManual);

  TWinGL = class(TCustomControl)
  private
   fDC:THandle;
   fGL:THandle;
   fGLFont:boolean;
   fGLMode:TGLMode;
   fColorBits:integer;
   fStencilBits:integer;
   fCapabilities:TCapabilities;
   fClearBuffers:TBuffers;
   fGLBuffers:integer;
   fClearColor:TGLColor;
   fClearDepth:double;
   fDepthFunc:TDepthFunc;
   fShadeModel:TShadeModel;
   fYFieldOfView:double;
   fZNear:double;
   fZFar:double;
   fLights:TList;
   EOnCreateGL:TNotifyEvent;
   EOnDestroyGL:TNotifyEvent;
   EBeforePaint:TNotifyEvent;
   EOnPaint:TNotifyEvent;
   EAfterPaint:TNotifyEvent;
   procedure SetColorBits(Value:integer);
   procedure SetStencilBits(Value:integer);
   procedure SetClearBuffers(Value:TBuffers);
   procedure SetClearColor(Value:TGLColor);
   procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message wm_erasebkgnd;
   procedure CMFontChanged(Var Msg:TMessage); message cm_fontchanged;
   procedure WMDisplayChange(Var Msg:TMessage); message WM_DISPLAYCHANGE; // don't work :((
   procedure WMGetDlgCode(Var Msg:TWMGetDlgCode); message wm_getdlgcode;
  protected
   procedure CreateParams(Var Params:TCreateParams); override;
   procedure CreateWindowHandle(const Params: TCreateParams); override;
   procedure DestroyWindowHandle; override;
   procedure Resize; override;
   procedure CreateGL;
   procedure SetupGL;
   procedure DestroyGL;
   procedure MakeFont;
  public
   Constructor Create(AOwner:TComponent); override;
   Destructor Destroy; override;
   procedure Paint; override;
   procedure TextMode;
   procedure GraphMode;
   procedure TextOut(x,y:integer; s:string);
   function TextExtent(s:string):TSize;
   property DC:THandle read fDC;
  published
   property GLMode:TGLMode read fGLMode write fGLMode;
   property ColorBits:integer read fColorBits write SetColorBits default 32;
   property StencilBits:integer read fStencilBits write SetStencilBits default 0;
   property Capabilities:TCapabilities read fCapabilities write fCapabilities default [DEPTH_TEST,DITHER,TEXTURE_2D];
   property ClearBuffers:TBuffers read fClearBuffers write SetClearBuffers default [COLOR_BUFFER_BIT,DEPTH_BUFFER_BIT];
   property ClearColor:TGLColor read fClearColor write SetClearColor;
   property ClearDepth:double read fClearDepth write fClearDepth;
   property DepthFunc:TDepthFunc read fDepthFunc write fDepthFunc default LESS;
   property ShadeModel:TShadeModel read fShadeModel write fShadeModel default SMOOTH;
   property YFieldOfView:double read fYFieldOfView write fYFieldOfView;
   property ZNear:double read fZNear write fZNear;
   property ZFar:double read fZFar write fZFar;
   property OnCreateGL:TNotifyEvent read EOnCreateGL write EOnCreateGL;
   property OnDestroyGL:TNotifyEvent read EOnDestroyGL write EOnDestroyGL;
   property BeforePaint:TNotifyEvent read EBeforePaint write EBeforePaint;
   property OnPaint:TNotifyEvent read EOnPaint write EOnPaint;
   property AfterPaint:TNotifyEvent read EAfterPaint write EAfterPaint;
   property Align;
   property OnKeyDown;
   property OnKeypress;
   property OnKeyUp;
   property OnMouseDown;
   property OnMouseMove;
   property OnMouseUp;
   property OnResize;
   property Font;
   property TabOrder;
   property TabStop;
   property Visible;
  end;

  TMinFilter=(
   MI_NEAREST,
   MI_LINEAR,
   MI_NEAREST_MIPMAP_NEAREST,
   MI_LINEAR_MIPMAP_NEAREST,
   MI_NEAREST_MIPMAP_LINEAR, // default
   MI_LINEAR_MIPMAP_LINEAR
  );

  TMagFilter=(
   MA_NEAREST,
   MA_LINEAR // default
  );

  TWrap=(
   WP_CLAMP,
   WP_REPEAT
  );

  TPixels =array[word] of integer;
  PPixels =^TPixels;

  TFileMapping=class
  private
   fFile:integer;
   fMap :integer;
   fBase:pointer;
   fSize:Cardinal;
  public
   Constructor Create(AFileName:string);
   Destructor Destroy; override;
   function data(index:Cardinal):pointer;
   property Base:pointer read fBase;
   property Size:Cardinal read fSize;
  end;

  TGLTex=class(TComponent)
  private
   fFileName:string;
   fMapping:TFileMapping;
   fMagFilter:TMagFilter;
   fMinFilter:TMinFilter;
   fWrapS:TWrap;
   fWrapT:TWrap;
   fWidth:integer;
   fHeight:integer;
   fPixels:PPixels;
   fTransparentIndex:integer;
   fTransparentColor:TColor;
   fHandle:integer;
   procedure SetFileName(Value:string);
   procedure SetSize(AWidth,AHeight:integer);
   procedure LoadBMP(p:pchar);
   procedure LoadPCX(p:pchar; size:integer);
   procedure LoadRAW(p:pchar);
  public
   Constructor Create(AOwner:TComponent); override;
   Destructor Destroy; override;
   function GenTexture:integer;
   function GenMipMaps:integer;
   procedure Bind;
   procedure Release;
   procedure SaveToFile(FileName:string);
  published
   property FileName:string read fFileName write SetFileName;
   property MinFilter:TMinFilter read fMinFilter write fMinFilter default MI_LINEAR;
   property MagFilter:TMagFilter read fMagFilter write fMagFilter default MA_LINEAR;
   property WrapS:TWrap read fWrapS write fWrapS default WP_REPEAT;
   property WrapT:TWrap read fWrapT write fWrapT default WP_REPEAT;
   property TransparentIndex:integer read fTransparentIndex write fTransparentIndex default -1;
   property TransparentColor:TColor  read fTransparentColor write fTransparentColor default clOlive;
   property Width:integer read fWidth;
   property Height:integer read fHeight;
  end;

  TGLLight=class(TComponent)
  private
   fWinGL:TWinGL;
   fEnabled:boolean;
   fAmbient:TGLColor;
   fDiffuse:TGLColor;
   fSpecular:TGLColor;
   fPosition:TGLPoint;
   fSpotDirection:TGLPoint;
   fSpotCutOff:single;
   fSpotExponent:single;
   procedure SetWinGL(Value:TWinGL);
   procedure SetEnabled(Value:boolean);
   procedure SetAmbient(Value:TGLColor);
   procedure SetDiffuse(Value:TGLColor);
   procedure SetSpecular(Value:TGLColor);
   procedure SetPosition(Value:TGLPoint);
   procedure SetSpotDirection(Value:TGLPoint);
   procedure SetSpotExponent(Value:single);
  protected
   function Active:boolean;
  public
   Constructor Create(AOwner:TComponent); override;
   Destructor Destroy; override;
   procedure Notification(AComponent: TComponent; Operation: TOperation); override;
   Function Index:integer;
   procedure Setup;
   procedure MoveTo(x,y,z,w:single);
   procedure SpotTo(x,y,z,w:single);
  published
   property WinGL:TWinGL read fWinGL write SetWinGL;
   property Enabled:boolean read fEnabled write SetEnabled;
   property Ambient:TGLColor read fAmbient write SetAmbient;
   property Diffuse:TGLColor read fDiffuse write SetDiffuse;
   property Specular:TGLColor read fSpecular write SetSpecular;
   property Position:TGLPoint read fPosition write SetPosition;
   property SpotDirection:TGLPoint read fSpotDirection write SetSpotDirection;
   property SpotCutOff:single read fSpotCutOff write fSpotCutOff;
   property SpotExponent:single read fSpotExponent write SetSpotExponent;
  end;

procedure Register;

implementation

uses Unit4;

procedure Register;
begin
  RegisterComponents('MySoft.GL', [TWinGL,TGLTex,TGLLight]);
end;

procedure TFloats.Assign(Source:TPersistent);
 begin
  if Source is TFloats then Values:=TFloats(Source).Values else inherited;
 end;

Function PowerOf2(Target:integer):integer;
 begin
  Result:=1;
  while Result<Target do Result:=Result shl 1;
 end;

Const
 glcap:array[TCapability] of integer=(
   GL_ALPHA_TEST,
   GL_AUTO_NORMAL,
   GL_BLEND,
   GL_COLOR_MATERIAL,
   GL_CULL_FACE,
   GL_DEPTH_TEST,
   GL_DITHER,
   GL_FOG,
   GL_LIGHTING,
   GL_LINE_SMOOTH,
   GL_LINE_STIPPLE,
   GL_LOGIC_OP,
   GL_NORMALIZE,
   GL_POINT_SMOOTH,
   GL_POLYGON_SMOOTH,
   GL_POLYGON_STIPPLE,
   GL_SCISSOR_TEST,
   GL_STENCIL_TEST,
   GL_TEXTURE_1D,
   GL_TEXTURE_2D,
   GL_TEXTURE_GEN_Q,
   GL_TEXTURE_GEN_R,
   GL_TEXTURE_GEN_S,
   GL_TEXTURE_GEN_T
  );

  DepthFunc2GL:array[TDepthFunc] of integer=(
   GL_ALWAYS,
   GL_EQUAL,
   GL_GEQUAL,
   GL_GREATER,
   GL_LEQUAL,
   GL_LESS,
   GL_NEVER,
   GL_NOTEQUAL
  );

  ShadeModel2GL:array[TShadeModel] of integer=(
   GL_FLAT,
   GL_SMOOTH
  );

  Buffer2GL:array[TBuffer] of integer=(
   GL_ACCUM_BUFFER_BIT,
   GL_COLOR_BUFFER_BIT,
   GL_DEPTH_BUFFER_BIT,
   GL_STENCIL_BUFFER_BIT
  );

  minfilter2gl:array[TMinFilter] of integer=(
   GL_NEAREST,
   GL_LINEAR,
   GL_NEAREST_MIPMAP_NEAREST,
   GL_LINEAR_MIPMAP_NEAREST,
   GL_NEAREST_MIPMAP_LINEAR,
   GL_LINEAR_MIPMAP_LINEAR
  );

  magfilter2gl:array[TMagFilter] of integer=(
   GL_NEAREST,
   GL_LINEAR
  );

Constructor TWinGL.Create(AOwner:TComponent);
 begin
  inherited;
  fColorBits:=32;
  ClearBuffers:=[COLOR_BUFFER_BIT,DEPTH_BUFFER_BIT];
  fCapabilities:=[DEPTH_TEST,DITHER,TEXTURE_2D];
  fClearDepth:=1.0;
  fClearColor:=TGLColor.Create;
  fClearColor.Red:=0;
  fClearColor.Green:=0;
  fClearColor.Blue:=0;
  fClearColor.Alpha:=0;
  fDepthFunc:=LESS;
  fShadeModel:=SMOOTH;
  fYFieldOfView:=45;
  fZNear:=1;
  fZFar:=100;
  fLights:=TList.Create;
  ParentColor:=False;
  Color:=clBlack;
 end;

Destructor TWinGL.Destroy;
 begin
  fLights.Free;
  fClearColor.Free;
  inherited;
 end;

procedure TWinGL.CreateParams(Var Params:TCreateParams);
 begin
  inherited;
  Params.Style:=Params.Style or WS_CLIPCHILDREN or WS_CLIPSIBLINGS or CS_HREDRAW or CS_VREDRAW or CS_OWNDC;
 end;

procedure TWinGL.CreateWindowHandle(const Params: TCreateParams);
 begin
  inherited;
  fDC:=GetDC(Handle);
  CreateGL;
 end;

procedure TWinGL.DestroyWindowHandle;
 begin
  DestroyGL;
  ReleaseDC(Handle,fDC); fDC:=0;
  inherited;
 end;

procedure TWinGL.WMGetDlgCode(Var Msg:TWMGetDlgCode);
 begin
  inherited;
  Msg.Result:=Msg.Result or dlgc_WantArrows;
 end;

procedure TWinGL.CreateGL;
 var
  pfd:TPIXELFORMATDESCRIPTOR;
  pixelformat:integer;
  i:integer;
 begin
  if fDC=0 then exit;
  if fGL<>0 then DestroyGL;
  FillChar(pfd,SizeOf(pfd),0);
  pfd.nSize       := sizeof(pfd);
  pfd.nVersion    := 1;
  pfd.dwFlags     := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
  pfd.iLayerType  := PFD_MAIN_PLANE;
  pfd.iPixelType  := PFD_TYPE_RGBA;
  pfd.cColorBits  := fColorBits;
  pfd.iLayerType  :=PFD_MAIN_PLANE;
  pfd.cStencilBits:= fStencilBits;
  pixelformat:=ChoosePixelFormat(fDC, @pfd);
  if PixelFormat=0 then RaiseLastWin32Error;
  if not SetPixelFormat(fDC, pixelformat, @pfd) then RaiseLastWin32Error;
  fGL:=wglCreateContext(fDC);
  wglMakeCurrent(fDC,fGL);
  if fGLMode=glAutomatic then SetupGL;
  if Assigned(EOnCreateGL) then EOnCreateGL(Self);
  for i:=0 to fLights.Count-1 do TGLLight(fLights[i]).Setup;
  Resize;
 end;

procedure TWinGL.DestroyGL;
 begin
  if Assigned(EOnDestroyGL) then EOnDestroyGL(Self);
  wglMakeCurrent(fDC,0);
  wglDeleteContext(fGL); fGL:=0;
  if fGLFont then begin
   glDeleteLists(0,255);
   fGLFont:=False;
  end;
 end;

procedure TWinGL.SetupGL;
 var
  cap:TCapability;
 begin
  if fGL=0 then exit;
  glClearColor(fClearColor.Red,fClearColor.Green,fClearColor.Blue,fClearColor.Alpha);
  glClearDepth(fClearDepth);
  for cap:=Low(TCapability) to High(TCapability) do
   if cap in fCapabilities then glEnable(glcap[cap]) else glDisable(glcap[cap]);
  glDepthFunc(DepthFunc2GL[fDepthFunc]);
  glShadeModel(ShadeModel2GL[fShadeModel]);
 end;

procedure TWinGL.SetColorBits(Value:integer);
 begin
  if fColorBits<>Value then begin
   fColorBits:=Value;
   if HandleAllocated then begin
    DestroyHandle; // need a new handle cause PixelFormat can't be set twice !
    if csDesigning in ComponentState then CreateHandle;
   end;
  end;
 end;

procedure TWinGL.SetStencilBits(Value:integer);
 begin
  if fStencilBits<>Value then begin
   fStencilBits:=Value;
   if HandleAllocated then begin
    DestroyHandle; // need a new handle cause PixelFormat can't be set twice !
    if csDesigning in ComponentState then CreateHandle;
   end;
  end;
 end;

procedure TWinGL.SetClearBuffers(Value:TBuffers);
 var
  b:TBuffer;
 begin
  fClearBuffers:=Value;
  fGLBuffers:=0;
  for b:=low(TBuffer) to high(TBuffer) do begin
   if (b in fClearBuffers) then Inc(fGLBuffers,ord(Buffer2GL[b]));
  end;
 end;

procedure TWinGL.SetClearColor(Value:TGLColor);
 begin
  fClearColor:=Value;
  if fGL<>0 then with fClearColor do glClearColor(Red,Green,Blue,Alpha);
 end;

procedure TWinGL.WMEraseBkgnd(Var Msg: TWMEraseBkgnd);
 begin
  if Assigned(EOnPaint) then Msg.Result:=1 else inherited;
 end;

procedure TWinGL.MakeFont;
 begin
  if (fDC<>0)and(fGLFont=False) then begin
   SelectObject(fDC,Font.Handle);
   wglUseFontBitmaps(fDC,0,255,0);
   fGLFont:=True;
  end;
 end;

procedure TWinGL.CMFontChanged(Var Msg:TMessage);
 begin
  inherited;
  glDeleteLists(0,255);
  fGLFont:=False;
 end;

procedure TWinGL.WMDisplayChange(Var Msg:TMessage);
 begin
  RecreateWnd;
  inherited;
 end;

procedure TWinGL.Resize;
 begin
  inherited;
  if (fGL=0)or(ClientHeight=0)or(fGLMode=glManual) then exit;
  glViewport(0, 0, ClientWidth, ClientHeight);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  gluPerspective(fYFieldOfView,ClientWidth/ClientHeight,fZNear,fZFar);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
 end;

procedure TWinGL.Paint;
 begin
 {$IFDEF DESIGN}
 { // ComponentState text
  if (csDesigning in ComponentState) then begin
   with Canvas do begin
    Brush.Color:=clBlack;
    FrameRect(ClientRect);
    Brush.Style:=bsClear;
    Font.Style:=[fsBold];
    Font.Color:=clLime;
    TextOut(2, 2,'TWinGL Example');
    Font.Style:=[];
    Font.Color:=clBlue;
    TextOut(6,16,glGetString(GL_VENDOR));
    TextOut(6,28,glGetString(GL_RENDERER));
    TextOut(6,40,glGetString(GL_VERSION));
   end;
  end;
  }
 {$ENDIF}

  wglMakeCurrent(fDC,fGL);
  if Assigned(EBeforePaint) then EBeforePaint(Self);
  if Assigned(EOnPaint) then begin
   if fGLMode=glAutomatic then begin
    glClear(fGLBuffers);    // Clear The Screen And The Depth Buffer
    glLoadIdentity;
   end;

   EOnPaint(Self);
   //glFlush;
   SwapBuffers(fDC);
  end;

  // show text on WinGL
  if Form4.CheckBox6.Checked = true then
  begin
    with Canvas do
    begin
      Brush.Color:=clBlack;
      FrameRect(ClientRect);
      Brush.Style:=bsClear;
      Font.Style:=[];
      Font.Color:=clLime;
      TextOut(2, 2, Form4.Edit1.Text);
      Font.Style:=[];
      if Form4.CheckBox7.Checked = true then
      begin
        Font.Color:=clAqua;
        TextOut(6,18,glGetString(GL_VENDOR));
        TextOut(6,30,glGetString(GL_RENDERER));
        TextOut(6,42,glGetString(GL_VERSION));
      end;
     end;
   end;

  if Assigned(EAfterPaint) then EAfterPaint(Self);
end;

procedure Disable(GLCap:integer; var CapSet; Cap:integer);
 begin
 // is it enabled ?
  if glIsEnabled(GLCap) then begin
  // disable it
   glDisable(GLCap);
  // make sure the Capabilitie is Set
   integer(CapSet):=integer(CapSet) or (1 shl integer(cap));
  end;
 end;

procedure Enable(GLCap:integer; var CapSet; Cap:integer);
 begin
  if (Integer(CapSet) and (1 shl integer(Cap)))>0 then glEnable(GLCap);
 end;

procedure TWinGL.TextMode;
 begin
  Disable(GL_DEPTH_TEST,fCapabilities,ord(DEPTH_TEST));
  Disable(GL_STENCIL_TEST,fCapabilities,ord(STENCIL_TEST));
  Disable(GL_LIGHTING,fCapabilities,ord(LIGHTING));
  Disable(GL_TEXTURE_2D,fCapabilities,ord(TEXTURE_2D));
  glMatrixMode(GL_PROJECTION); // projection change
   glPushMatrix; // save the current projection
   glLoadIdentity; // reset
   glOrtho(0,Width, 0,Height, -1, 1); // orthogonal projection
  glMatrixMode(GL_MODELVIEW); // fashion drawing
   glPushMatrix; // save information
   glLoadIdentity; // reset
 end;

procedure TWinGL.GraphMode;
 begin
  glMatrixMode(GL_PROJECTION); // modify projection
  glPopMatrix; // restore the old
  glMatrixMode(GL_MODELVIEW); // model
  glPopMatrix; // restore the old
  glColor4f(1,1,1,1);
  Enable(GL_DEPTH_TEST,fCapabilities,ord(DEPTH_TEST));
  Enable(GL_STENCIL_TEST,fCapabilities,ord(STENCIL_TEST));
  Enable(GL_LIGHTING,fCapabilities,ord(LIGHTING));
  Enable(GL_TEXTURE_2D,fCapabilities,ord(TEXTURE_2D));
 end;

procedure TWinGL.TextOut(x,y:integer; s:string);
 var
  cl:integer;
 begin
  if not fGLFont then MakeFont;
  cl:=Font.Color;
  glColor4f((cl and 255)/255,((cl shr 8)and 255)/255,((cl shr 16) and 255)/255,1);
  glRasterPos2f(x,y);
  glCallLists(Length(s),GL_UNSIGNED_BYTE,pchar(s));
 end;

function TWinGL.TextExtent(s:string):TSize;
 begin
  Windows.GetTextExtentPoint32(fDC, PChar(s), Length(s), Result);
 end;

Type
 TBMP256=packed record
  bfType:array[1..2] of char;
  bfSize:LongInt;
  bfReserved:LongInt;
  bfOffBits:LongInt;
 //---
  biSize:LongInt;
  biWidth:LongInt;
  biHeight:LongInt;
  biPlanes:word;
  biBitCount:word;
  biCompression:longint;
  biSizeImage:longint;
  biXPelsPerMeter:longint;
  biYPelsPerMeter:longint;
  biClrUsed:Longint;
  biClrImportant:longint;
 end;

 TPCX256=packed record
  manufacturer:byte;
  version     :byte;
  encoding    :byte; // 1
  BitsPerPixel:byte; // 8
  xmin,ymin,xmax,ymax:word; // ClientRect
//  hres,vres:word;
//  palette:array[0..47] of byte;
//  reserved:byte;
//  planes:byte;
//  BytesPerLine:word;
//  PaletteType:word;
//  dummy:array[0..57] of byte;
 end;

Constructor TGLTex.Create(AOwner:TComponent);
 begin
  inherited;
  fMinFilter:=MI_LINEAR;
  fMagFilter:=MA_LINEAR;
  fWrapS:=WP_REPEAT;
  fWrapT:=WP_REPEAT;
  fTransparentIndex:=-1;
 end;

Destructor TGLTex.Destroy;
 begin
  Release;
  if fMapping=nil then FreeMem(fPixels) else fMapping.Free;
  inherited;
 end;

Procedure TGLTex.SetSize(AWidth,AHeight:integer);
 begin
  FreeMem(fPixels);
  if (AWidth=0)or(AHeight=0) then begin
   fWidth :=0;
   fHeight:=0;
   fPixels:=nil;
  end else begin
   fWidth :=PowerOf2(AWidth);
   fHeight:=PowerOf2(AHeight);
   GetMem(fPixels,fWidth*fHeight*4);
  end;
 end;

procedure TGLTex.SetFileName(Value:string);
 var
  tag:word;
 begin
  fFileName:=Value;
  if fFileName='' then begin
   SetSize(0,0);
  end else begin
   fMapping:=TFileMapping.Create(fFileName);
   tag:=word(fMapping.fBase^);
   try
    case tag of
     $4D42 : LoadBMP(fMapping.Base);
     $050A : LoadPCX(fMapping.Base,fMapping.Size);
     $ADB1 : LoadRAW(fMapping.Base);
    end;
   finally
    if tag<>$ADB1 then begin
     fMapping.Free;
     fMapping:=nil;
    end;
   end;
  end;
 end;

function TGLTex.GenTexture:integer;
 begin
  glGenTextures(1,@Result);
  glBindTexture(GL_TEXTURE_2D, Result);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magfilter2gl[fMagFilter]);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minfilter2gl[fMinFilter]);
  glTexImage2D(GL_TEXTURE_2D, 0, 4, fWidth,fHeight,0, GL_RGBA, GL_UNSIGNED_BYTE, fPixels);
  fHandle:=Result;
 end;

function TGLTex.GenMipMaps:integer;
 begin
  glGenTextures(1,@Result);
  glBindTexture(GL_TEXTURE_2D, Result);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magfilter2gl[fMagFilter]);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minfilter2gl[fMinFilter]);
  gluBuild2DMipmaps(GL_TEXTURE_2D, 4, fWidth,fHeight, GL_RGBA, GL_UNSIGNED_BYTE, fPixels);
  fHandle:=Result;
 end;

procedure TGLTex.Bind;
 begin
  if fHandle=0 then GenTexture else glBindTexture(GL_TEXTURE_2D,fHandle);
 end;

procedure TGLTex.Release;
 begin
  if fHandle<>0 then begin
   glDeleteTextures(1,fHandle);
   fHandle:=0;
  end;
 end;

procedure TGLTex.LoadBMP(p:pchar);
 type
  TPalette=packed array[#0..#255] of record r,g,b,a:byte end;
 var
  bmp:^TBMP256;
  pal:^TPalette;
  pix:pchar;
  x,y:integer;
  i,j:integer;
  k  :char;
  cl :integer;
 begin
  bmp:=@p[0];
  SetSize(bmp.biWidth,bmp.biHeight);
  case bmp.biBitCount of
   8 : begin
    pal:=@p[14+bmp.biSize];
    pix:=@p[bmp.bfOffBits];
    i:=0;
    j:=fWidth*bmp.biHeight;
    for y:=0 to bmp.biHeight-1 do begin
     dec(j,fWidth);
     for x:=0 to bmp.biWidth-1 do begin
      k:=pix[i+x];
      with pal[k] do cl:=r shl 16+g shl 8+b;
      if ord(k)<>fTransparentIndex then inc(cl,$FF000000);
      fPixels[j+x]:=cl;
     end;
     inc(i,bmp.biWidth);
    end;
   end;
   24 : begin
    pix:=@p[bmp.bfOffBits];
    i:=0;
    j:=fWidth*bmp.biHeight;
    for y:=0 to bmp.biHeight-1 do begin
     dec(j,fWidth);
     for x:=0 to bmp.biWidth-1 do begin
      cl:=ord(pix[i+3*x]) shl 16+ord(pix[i+3*x+1]) shl 8+ord(pix[i+3*x+2]);
      if cl<>fTransparentColor then inc(cl,$FF000000);
      fPixels[j+x]:=cl;
     end;
     inc(i,3*bmp.biWidth);
    end;
   end;
   else halt;
  end;
 end;

procedure TGLTex.LoadPCX(p:pchar;size:integer);
 type
  TPalette=packed array[0..255] of record b,g,r:byte end;
 var
  pcx:^TPCX256;
  pal:^TPalette;
  pix:pchar;
  x,y:integer;
  i,j:integer;
  k,l:integer;
  cl:integer;
 begin
  pcx:=@p[0];
  SetSize(pcx.xmax-pcx.xmin+1,pcx.ymax-pcx.ymin+1);
  pix:=@p[128];
  pal:=@p[size-sizeof(TPalette)];
  i:=0; // pixel index
  j:=0; // source index
  l:=0; // repeat count
  cl:=0; // to avoid a compilater warning...
  for y:=pcx.ymin to pcx.ymax do begin
   for x:=pcx.xmin to pcx.xmax do begin
    if l=0 then begin // need a new pixel
     k:=ord(pix[j]); inc(j);
     if (k and $C0)=$C0 then begin // repeat code
      l:=k and $3F; // repeat count
      k:=ord(pix[j]); inc(j); // get pixel
     end else begin
      l:=1; // only once
     end;
     with pal[k] do cl:=r shl 16+g shl 8+b;
     if k<>fTransparentIndex then inc(cl,$FF000000);
    end;
    fPixels[i+x]:=cl;
    dec(l);
   end;
   inc(i,fWidth);
  end;
 end;

procedure TGLTex.LoadRAW(p:pchar);
 begin
  fWidth :=integer((@p[4])^);
  fHeight:=integer((@p[8])^);
  fPixels:=@p[12];
 end;

procedure TGLTex.SaveToFile(FileName:string);
 const
  adkt:array[0..3] of char='ADKT';
 var
  f:file;
  sign:integer;
 begin
  AssignFile(f,FileName);
  Rewrite(f,1);
  sign:=integer(adkt);
  BlockWrite(f,sign,Sizeof(Sign));
  BlockWrite(f,fWidth,SizeOf(fWidth));
  BlockWrite(f,fHeight,SizeOf(fHeight));
  BlockWrite(f,fPixels^,fWidth*fHeight*4);
  CloseFile(f);
 end;

Constructor TFileMapping.Create(AFileName:string);
 begin
  fFile:=CreateFile(PChar(AFileName),GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  if fFile=0 then raise Exception.Create('Unable to open '+AFileName);
  fSize:=GetFileSize(fFile,nil);
  if fSize=0 then raise Exception.Create('Empty file '+AFileName);
  fMap :=CreateFileMapping(fFile,nil,PAGE_READONLY,0,0,nil);
  if fMap=0 then raise Exception.Create('Can''t map file '+AFileName);
  fBase:=MapViewOfFile(fMap,FILE_MAP_READ,0,0,0);
  if fBase=nil then raise Exception.Create('Can''t view file '+AFileName);
 end;

Destructor TFileMapping.Destroy;
 begin
  UnMapViewOfFile(fBase);
  CloseHandle(fMap);
  CloseHandle(fFile);
  inherited Destroy;
 end;

function TFileMapping.Data(index:Cardinal):pointer;
 begin
  if (index>fSize) then raise Exception.Create('Out of bounds pointer !');
  result:=pointer(Cardinal(fBase)+index);
 end;

Constructor TGLLight.Create(AOwner:TComponent);
 begin
  inherited;
  fAmbient:=TGLColor.Create;
  fDiffuse:=TGLColor.Create;
  fSpecular:=TGLColor.Create;
  fPosition:=TGLPoint.Create;
  fSpotDirection:=TGLPoint.Create;
 end;

Destructor TGLLight.Destroy;
 begin
  WinGL:=nil;
  fAmbient.Free;
  fDiffuse.Free;
  fSpecular.Free;
  fPosition.Free;
  fSpotDirection.Free;
  inherited;
 end;

Procedure TGLLight.Notification(AComponent: TComponent; Operation: TOperation);
 begin
  inherited;
  if (AComponent=fWinGL)and(Operation=opRemove) then fWinGL:=nil;
 end;

Procedure TGLLight.SetWinGL(Value:TWinGL);
 begin
  if fWinGL<>nil then fWinGL.fLights.Remove(Self);
  fWinGL:=Value;
  if fWinGL<>nil then begin
   fWinGL.fLights.Add(Self);
   Setup;
  end;
 end;

Function TGLLight.Active:boolean;
 begin
  Result:=(fWinGL<>nil)and(fWinGL.fGL<>0);
 end;

Procedure TGLLight.SetEnabled(Value:boolean);
 begin
  fEnabled:=Value;
  if Active then begin
   if fEnabled then glEnable(Index) else glDisable(Index);
  end;
 end;

Function TGLlight.Index:integer;
 begin
  if fWinGL=nil then
   Result:=0
  else
   Result:=GL_LIGHT0+fWinGL.fLights.IndexOf(Self);
 end;

Procedure TGLLight.Setup;
 var
  i:integer;
 begin
  if Active then begin
   i:=Index;
   if fEnabled then begin
    glEnable (i);
    glLightfv(i,GL_AMBIENT ,fAmbient.Values);
    glLightfv(i,GL_DIFFUSE ,fDiffuse.Values);
    glLightfv(i,GL_SPECULAR,fSpecular.Values);
    glLightfv(i,GL_SPOT_DIRECTION,fSpotDirection.Values);
    glLightfv(i,GL_POSITION, fPosition.Values);
    glLightf (i,GL_SPOT_CUTOFF,fSpotCutOff);
    glLightf (i,GL_SPOT_EXPONENT,fSpotExponent);
   end else begin
    glDisable(i);
   end;
  end;
 end;

procedure TGLLight.MoveTo(x,y,z,w:single);
 begin
  fPosition.x:=x;
  fPosition.y:=y;
  fPosition.z:=z;
  fPosition.w:=w;
  if Active then glLightfv(index,GL_POSITION, fPosition.Values);
 end;

procedure TGLLight.SpotTo(x,y,z,w:single);
 begin
  fSpotDirection.x:=x;
  fSpotDirection.y:=y;
  fSpotDirection.z:=z;
  fSpotDirection.w:=w;
  if Active then glLightfv(index,GL_SPOT_DIRECTION,fSpotDirection.Values);
 end;

procedure TGLLight.SetAmbient(Value:TGLColor);
 begin
  fAmbient.Assign(Value);
 end;

procedure TGLLight.SetDiffuse(Value:TGLColor);
 begin
  fDiffuse.Assign(Value);
 end;

procedure TGLLight.SetSpecular(Value:TGLColor);
 begin
  fSpecular.Assign(Value);
 end;

procedure TGLLight.SetPosition(Value:TGLPoint);
 begin
  fPosition.Assign(Value);
 end;

procedure TGLLight.SetSpotDirection(Value:TGLPoint);
 begin
  fSpotDirection.Assign(Value);
 end;

procedure TGLLight.SetSpotExponent(Value:single);
 begin
  fSpotExponent:=value;
  if Active then glLightf(Index,GL_SPOT_EXPONENT,fSpotExponent);
 end;

end.

