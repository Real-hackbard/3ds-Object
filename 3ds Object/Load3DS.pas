unit Load3DS;
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

Uses
 Classes, SysUtils, GLRender;
//-- 3DS ---------------------------------------------------------------------//
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

 T3DSReader=class(TGLReader)
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
  Group        :integer;
  Vertex0      :integer;
  face0        :integer;
  function LoadChunk(Var Size:integer):word;
  procedure Load(Name:string);
  function LoadWord:word;
  function LoadString:string;
  function LoadByteRGB:integer;
  function LoadFloatRGB:integer;
  procedure LoadMaterial;
  function LoadColor:integer;
  function LoadTransparency:single;
  Procedure LoadObject;
  procedure LoadVertices;
  procedure LoadFaces;
  procedure LoadMaterials;
 public
  Constructor Create(AFileName:string);
  Destructor Destroy; override;
 end;

implementation

Constructor T3DSReader.Create(AFileName:string);
 var
  Size:integer;
 begin
  Stream:=TFileStream.Create(AFileName,fmOpenRead or fmShareDenyNone);
  Groups:=TStringList.Create;
  Size:=Stream.size;
  if LoadChunk(Size)<>$4D4D then raise Exception.Create('Not a 3DS File');
  Load('3DS');
 end;

Destructor T3DSReader.Destroy;
 begin
  Stream.Free;
  Groups.Free;
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
      $A000: Materials[MaterialCount].Name:=LoadString;
       $A010: Materials[MaterialCount].Ambient:=LoadColor;
       $A020: Materials[MaterialCount].Diffuse:=LoadColor;
       $A030: Materials[MaterialCount].Specular:=LoadColor;
       $A050: Materials[MaterialCount].Transparency:=LoadTransparency;
       $A081: Materials[MaterialCount].TwoSide:=True;
     $4000: LoadObject;
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
  if Materials[MaterialCount].Transparency>0 then Transparent:=True;
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

procedure T3DSReader.LoadObject;
 var
  s:string;
 begin
  s:=LoadString;
  group:=Groups.Add(s);
  Load(s);
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
   Faces[FaceCount+i].group:=group;
   Faces[FaceCount+i].material:=-1;
  end;
  Inc(FaceCount,Count);
  Dec(Chunk.Size,Count*SizeOf(T3DSFace)+2);
  Load('Face');
 end;

procedure T3DSReader.LoadMaterials;
 var
  name:string;
  index:integer;
  count:word;
  i:integer;
 begin
  name:=LoadString;
 {$ifdef log}Log(Iter+'Material '+name);{$endif}
  index:=Length(Materials)-1;
  while (index>=0)and(Materials[Index].Name<>Name) do dec(Index);
  count:=LoadWord;
  for i:=0 to count-1 do Faces[Face0+LoadWord].Material:=Index;
 end;

end.
