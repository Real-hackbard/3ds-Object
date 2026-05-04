unit GLRender;

interface

uses
  Classes,SysUtils,DelphiGL;

type
  TVector=record
   x,y,z:single;
  end;
  TVertex=TVector;
  TVertices=array of TVertex;

  TColor=record
   r,g,b:single;
  end;
  TColors=array of TColor;

  TFace=record
   a,b,c:integer;
   material:integer;
  end;
  TFaces=array of TFace;

  TMaterial=record
   Ambient :integer;
   Diffuse :integer;
   Specular:integer;
   TwoSide :boolean;
   Transparency:single;
  end;
  TMaterials=array of TMaterial;

  TGLObject = class
  private
   fVertices :TVertices;
   fFaces    :TFaces;
   fPoints   :TVertices;
   fNormals  :array of TVector;
   fGouraud  :array of record r,g,b,a:single end;
   fColors   :TColors;
   fMaterials:TMaterials;
   fRotation :TVector;
   fFaceCount:integer;
   fVertexCount:integer;
  protected
   procedure RotatePoints;
   procedure ComputeNormals;
  public
   procedure Load3DS(FileName:string);
   procedure Normalise;
   procedure Rotate(rx,ry,rz:single);
   procedure Render;
  end;

{$ifdef log}
type
 TLog=procedure(s:string) of object;
var
 Log:TLog;
{$endif}

implementation

//-- Readers -----------------------------------------------------------------//
Type
 T3DSChunk=packed record
  Tag:word;
  Size:integer
 end;

 T3DSColor=packed record
  r,g,b:single;
 end;

 T3DSFace=packed record
  a,b,c,flag:word;
 end;

 T3DSReader=class
 private
 {$ifdef log}
  Iter         :string;
 {$endif}
  Stream       :TStream;
  Chunk        :T3DSChunk;
  VertexCount  :integer;
  FaceCount    :integer;
  MaterialCount:integer;
  ColorCount   :integer;
  Vertex0      :integer;
  face0        :integer;
  MaterialNames:TStringList;
  function LoadChunk(Var Size:integer):word;
  procedure Load(Name:string);
  function LoadWord:word;
  function LoadString:string;
  function LoadByteRGB:integer;
  function LoadFloatRGB:integer;
  procedure LoadMaterial;
  function LoadColor:integer;
  function LoadTransparency:single;
  procedure LoadVertices;
  procedure LoadFaces;
  procedure LoadMaterials;
 public
  Vertices :TVertices;
  Faces    :TFaces;
  Colors   :TColors;
  Materials:TMaterials;
  Constructor Create(AFileName:string);
  Destructor Destroy; override;
 end;

Constructor T3DSReader.Create(AFileName:string);
 var
  Size:integer;
 begin
  Stream:=TFileStream.Create(AFileName,fmOpenRead or fmShareDenyNone);
  VertexCount  :=0;
  FaceCount    :=0;
  ColorCount   :=0;
  MaterialCount:=0;
  MaterialNames:=TStringList.Create;
  Size:=Stream.size;
  if LoadChunk(Size)<>$4D4D then raise Exception.Create('Not a 3DS File');
  Load('3DS');
 end;

Destructor T3DSReader.Destroy;
 begin
  Stream.Free;
  MaterialNames.Free;
 end;

function T3DSReader.LoadChunk(var Size:integer):word;
 begin
  Stream.ReadBuffer(Chunk,SizeOf(Chunk));
  Dec(Size,Chunk.Size);
  Result:=Chunk.Tag;
 end;

procedure T3DSReader.Load(Name:string);
 var
  size:integer;
 begin
 {$ifdef log}
  log(Iter+'Loading '+Name+' {');
  Iter:=Iter+' ';
 {$endif}
  size:=Chunk.Size-sizeof(T3DSChunk);
  While Size>0 do begin
   case LoadChunk(Size) of
    $3D3D: Load('Mesh');
     $AFFF: LoadMaterial;
      $A000: MaterialNames.Add(LoadString);
       $A010: Materials[MaterialCount].Ambient:=LoadColor;
       $A020: Materials[MaterialCount].Diffuse:=LoadColor;
       $A030: Materials[MaterialCount].Specular:=LoadColor;
       $A050: Materials[MaterialCount].Transparency:=LoadTransparency;
       $A081: Materials[MaterialCount].TwoSide:=True;
     $4000: Load(LoadString);
      $4100: Load('Data');
       $4110: LoadVertices;  // vertices
       $4120: LoadFaces;     // faces
       $4130: LoadMaterials; // colors & textures..
    else Stream.Position:=Stream.Position+Chunk.Size-SizeOf(T3DSChunk); // skip chunk
   end;
  end;
 {$ifdef log}
  SetLength(Iter,Length(Iter)-1);
  Log(Iter+'}');
 {$endif}
 end;

function T3DSReader.LoadWord:word;
 begin
  Stream.ReadBuffer(Result,sizeof(Result));
 end;

function T3DSReader.LoadString:string;
 var
  i:integer;
 begin
  SetLength(result,255);
  i:=0;
  repeat
   inc(i);
   Stream.ReadBuffer(Result[i],1);
  until Result[i]=#0;
  SetLength(Result,i-1);
  Dec(Chunk.Size,i);
 end;

function T3DSReader.LoadByteRGB:integer;
 var
  rgb:packed record r,g,b:byte end;
  color:TColor;
  i:integer;
 begin
 {$ifdef log}Log(Iter+'Color (3 bytes)');{$endif}
  Stream.ReadBuffer(rgb,sizeof(rgb));
  color.r:=rgb.r/256;
  color.g:=rgb.g/256;
  color.b:=rgb.b/256;
  for i:=0 to ColorCount-1 do with Colors[i] do begin
   if (r=color.r)and(g=color.g)and(b=color.b) then begin
    result:=i;
    exit;
   end;
  end;
  SetLength(Colors,ColorCount+1);
  Colors[ColorCount]:=Color;
  result:=ColorCount;
  inc(ColorCount);
 end;

function T3DSReader.LoadFloatRGB:integer;
 var
  color:TColor;
  i:integer;
 begin
 {$ifdef log}Log(Iter+'Color (3 floats)');{$endif}
  Stream.ReadBuffer(Color,sizeof(T3DSColor));
  for i:=0 to ColorCount-1 do with Colors[i] do begin
   if (r=color.r)and(g=color.g)and(b=color.b) then begin
    result:=i;
    exit;
   end;
  end;
  SetLength(Colors,ColorCount+1);
  Colors[ColorCount]:=Color;
  result:=ColorCount;
  inc(ColorCount);
 end;

procedure T3DSReader.LoadMaterial;
 begin
 {$ifdef log}Log(Iter+'Material');{$endif}
  SetLength(Materials,MaterialCount+1);
  Load('Material');
  Inc(MaterialCount);
 end;

function T3DSReader.LoadColor:integer;
 var
  size:integer;
 begin
 {$ifdef log}Log(Iter+'Color');{$endif}
  Result:=0;
  Size:=Chunk.Size-SizeOf(T3DSChunk);
  while Size>0 do begin
   case LoadChunk(Size) of
    $0010 : Result:=LoadFloatRGB;
    $0011 : Result:=LoadByteRGB;
    else Stream.Position:=Stream.Position+Chunk.Size-SizeOf(T3DSChunk); // skip chunk
   end;
  end;
 end;

function T3DSReader.LoadTransparency:single;
 var
  size:integer;
 begin
 {$ifdef log}Log(Iter+'Transparency');{$endif}
  Result:=0;
  Size:=Chunk.Size-SizeOf(T3DSChunk);
  while Size>0 do begin
   case LoadChunk(Size) of
    $0030 : Result:=LoadWord/100;
    else Stream.Position:=Stream.Position+Chunk.Size-SizeOf(T3DSChunk); // skip chunk
   end;
  end;
 {$ifdef log}Log(Iter+'Transparency='+FloatToStr(Result));{$endif}
 end;

procedure T3DSReader.LoadVertices;
 var
  count:word;
 begin
 {$ifdef log}Log(Iter+'Vertices');{$endif}
  vertex0:=VertexCount; // for LoadFaces
  count:=LoadWord;
  SetLength(Vertices,VertexCount+count);
  Stream.ReadBuffer(Vertices[VertexCount],count*sizeof(TVertex));
  Inc(VertexCount,Count);
 end;

procedure T3DSReader.LoadFaces;
 var
  count:word;
  items:array of T3DSFace;
  i:integer;
 begin
 {$ifdef log}Log(Iter+'Faces');{$endif}
  face0:=FaceCount;
  count:=LoadWord;
  SetLength(items,count);
  Stream.ReadBuffer(items[0],count*Sizeof(T3DSFace));
  SetLength(Faces,FaceCount+count);
  for i:=0 to count-1 do begin
   Faces[FaceCount+i].a:=vertex0+items[i].a;
   Faces[FaceCount+i].b:=vertex0+items[i].b;
   Faces[FaceCount+i].c:=vertex0+items[i].c;
   Faces[FaceCount+i].material:=-1;
  end;
  Inc(FaceCount,Count);
  Dec(Chunk.Size,Count*SizeOf(T3DSFace)+2);
  Load('Face');
 end;

procedure T3DSReader.LoadMaterials;
 var
  index:integer;
  count:word;
  i:integer;
 begin
 {$ifdef log}Log(Iter+'Materials');{$endif}
  index:=MaterialNames.IndexOf(LoadString);
  count:=LoadWord;
  for i:=0 to count-1 do Faces[Face0+LoadWord].Material:=Index;
 end;

//-- 3DS ---------------------------------------------------------------------//
Procedure TGLObject.Load3DS(FileName:string);
 var
  Reader:T3DSReader;
 begin
  Reader:=T3DSReader.Create(FileName);
  fVertices:=reader.Vertices;
  fFaces:=reader.Faces;
  fColors:=reader.Colors;
  fMaterials:=reader.Materials;
  fVertexCount:=Length(fVertices);
  fFaceCount:=Length(fFaces);
  Reader.Free;
 end;

Procedure TGLObject.Normalise;
 var
  xmin,xmax:single;
  ymin,ymax:single;
  zmin,zmax:single;
  i:integer;
  z1,z2:single;
  ox,oy,oz:single;
 begin
  xmin:=fVertices[0].x; xmax:=xmin;
  ymin:=fVertices[0].y; ymax:=ymin;
  zmin:=fVertices[0].z; zmax:=zmin;
  for i:=1 to fVertexCount-1 do with fVertices[i] do begin
   if x<xmin then xmin:=x else if x>xmax then xmax:=x;
   if y<ymin then ymin:=y else if y>ymax then ymax:=y;
   if z<zmin then zmin:=z else if z>zmax then zmax:=z;
  end;
  z1:=xmax-xmin;
  z2:=ymax-ymin; if z2>z1 then z1:=z2;
  z2:=zmax-zmin; if z2>z1 then z1:=z2;
  ox:=xmin+(xmax-xmin)/2;
  oy:=ymin+(ymax-ymin)/2;
  oz:=zmin+(zmax-zmin)/2;
  for i:=0 to fVertexCount-1 do with fVertices[i] do begin
   x:=(x-ox)/z1;
   y:=(y-oy)/z1;
   z:=(z-oz)/z1;
  end;
 end;

Procedure TGLObject.Rotate(rx,ry,rz:single);
 begin
  fRotation.x:=rx*PI/180;
  fRotation.y:=ry*PI/180;
  fRotation.z:=rz*PI/180;
 end;

Procedure TGLObject.RotatePoints;
 var
  cosx,cosy,cosz,sinx,siny,sinz:single;
  rx1,rx2,rx3:single;
  ry1,ry2,ry3:single;
  rz1,rz2,rz3:single;
  v:integer;
 begin
  cosx:=-cos(fRotation.x);
  cosy:=+cos(fRotation.y);
  cosz:=+cos(fRotation.z);
  sinx:=-sin(fRotation.x);
  siny:=+sin(fRotation.y);
  sinz:=+sin(fRotation.z);
 // rotation matrix
  rx1:= cosy*cosz; rx2:=sinx*siny*cosz-cosx*sinz; rx3:=cosx*siny*cosz+sinx*sinz;
  ry1:= cosy*sinz; ry2:=sinx*siny*sinz+cosx*cosz; ry3:=cosx*siny*sinz-sinx*cosz;
  rz1:=-siny;      rz2:=sinx*cosy;                rz3:=cosx*cosy;
  SetLength(fPoints,fVertexCount);
  for v:=0 to fVertexCount-1 do with fPoints[v] do begin
   x:=rx1*fVertices[v].x+rx2*fVertices[v].y+rx3*fVertices[v].z;
   y:=ry1*fVertices[v].x+ry2*fVertices[v].y+ry3*fVertices[v].z;
   z:=rz1*fVertices[v].x+rz2*fVertices[v].y+rz3*fVertices[v].z;
  end;
 end;

Procedure TGLObject.ComputeNormals;
 type
  TColorInfo=record
   count:integer;
   ccount:integer;
   x,y,z:single;
   r,g,b,a:single;
  end;
 var
  n:integer;
  x1,y1,z1,x2,y2,z2,vl,nx,ny,nz:single;
  ColorInfo:array of Tcolorinfo;
  gr,gg,gb,ga:single;

  procedure SetColorInfo(index,Material:integer);
   var
    i:integer;
   begin
    with ColorInfo[Index] do begin
     inc(count);
     x:=x+nx;
     y:=y+ny;
     z:=z+nz;
     if (Material<0) then begin
      inc(ccount);
      r:=r+nx;
      g:=g+ny;
      b:=b+nz;
     end else begin
      i:=fMaterials[Material].Diffuse;
      if i>=0 then begin
       inc(ccount);
       r:=r+nz*fColors[i].r;
       g:=g+nz*fColors[i].g;
       b:=b+nz*fColors[i].b;
       exit;
      end;
      i:=fMaterials[Material].Ambient;
      if i>=0 then begin
       inc(ccount);
       r:=r+nx*fColors[i].r;
       g:=g+nx*fColors[i].g;
       b:=b+nx*fColors[i].b;
       exit;
      end;
      i:=fMaterials[Material].Specular;
      if i>=0 then begin
       inc(ccount);
       r:=r+ny*fColors[i].r;
       g:=g+ny*fColors[i].g;
       b:=b+ny*fColors[i].b;
       exit;
      end;
      a:=a+fMaterials[Material].Transparency;
     end;
    end;
   end;

 begin
 // faces normals
  SetLength(fNormals,fFaceCount);
  SetLength(ColorInfo,fVertexCount);
  for n:=0 to fFaceCount-1 do with fFaces[n] do begin
   x1:=fPoints[b].x-fPoints[a].x;
   y1:=fPoints[b].y-fPoints[a].y;
   z1:=fPoints[b].z-fPoints[a].z;
   x2:=fPoints[c].x-fPoints[a].x;
   y2:=fPoints[c].y-fPoints[a].y;
   z2:=fPoints[c].z-fPoints[a].z;
   nx:=y1*z2-y2*z1;
   ny:=z1*x2-z2*x1;
   nz:=x1*y2-x2*y1;
   vl:=sqrt(nx*nx+ny*ny+nz*nz);
   if vl<>0 then begin
    nx:=nx/vl;
    ny:=ny/vl;
    nz:=nz/vl;
   end;
   if (Material>=0)and(fMaterials[Material].TwoSide) then begin
    nx:=abs(nx);
    ny:=abs(ny);
    nz:=abs(nz);
   end;
   fNormals[n].x:=nx;
   fNormals[n].y:=ny;
   fNormals[n].z:=nz;
   SetColorInfo(a,Material);
   SetColorInfo(b,Material);
   SetColorInfo(c,Material);
  end;
 // vertices colors
  SetLength(fGouraud,fVertexCount);
  for n:=0 to fVertexCount-1 do begin
   with ColorInfo[n] do begin
    nx:=x/count;
    ny:=y/count;
    nz:=z/count;
    gr:=r/ccount;
    gg:=g/ccount;
    gb:=b/ccount;
    ga:=a/count;
   end;
   vl:=sqrt(nx*nx+ny*ny+nz*nz);
   if vl<>0 then begin
    nx:=nx/vl;
    ny:=ny/vl;
    nz:=nz/vl;
   end;
//   vl:=sqrt(gr*gr+gg*gg+gb*gb);
   if vl<>0 then begin
    gr:=gr/vl;
    gg:=gg/vl;
    gb:=gb/vl;
    ga:=ga/vl;
   end;
   fGouraud[n].r:=gr;//nz;
   fGouraud[n].g:=gg;//nz;
   fGouraud[n].b:=gb;//nz;
   fGouraud[n].a:=ga;
  end;
 end;

Procedure TGLObject.Render;
 var
  i,m:integer;
 begin
  RotatePoints;
  ComputeNormals;
  glBegin(GL_TRIANGLES);
  for i:=0 to fFaceCount-1 do with fFaces[i] do begin
   with fGouraud[a] do glColor4f (r,g,b,a);
   with fPoints [a] do glVertex3f(x,y,z);
   with fGouraud[b] do glColor4f (r,g,b,a);
   with fPoints [b] do glVertex3f(x,y,z);
   with fGouraud[c] do glColor4f (r,g,b,a);
   with fPoints [c] do glVertex3f(x,y,z);
  end;
  glEnd;
 end;

end.






