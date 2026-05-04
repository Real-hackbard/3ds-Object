unit LoadMD2;

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

uses
 Classes,SysUtils,GLRender;

Type
 TMD2Reader=class(TGLReader)
 private
  Stream:TStream;
 public
  Constructor Create(AFileName:string);
  Destructor Destroy; override;
 end;

implementation

Type
 TMD2Header=record
  Ident      :integer;
  Version    :integer;

  SkinWidth  :integer;
  SkinHeight :integer;
  FrameSize  :integer;

  SkinCount  :integer;
  VertexCount:integer;
  MapCount   :integer;
  FaceCount  :integer;
  GLCmdCount :integer;
  FrameCount :integer;

  SkinOfs    :integer;
  MapOfs     :integer;
  FaceOfs    :integer;
  FrameOfs   :integer;
  GLCmdOfs   :integer;
  EndOfFile  :integer;
 end;

 TMD2Face=record
  a,b,c:smallint;
  ta,tb,tc:smallint;
 end;
 TMD2Faces=array[0..4095] of TMD2Face;

 TMD2Vertex=record
  x,y,z:byte;
  light:byte;
 end;

 TMD2Frame=record
  Scale:record x,y,z:single end;
  Trans:record x,y,z:single end;
  Name :array[0..15] of char;
 end;
 TMD2FrameVertices=array[0..2047] of TMD2Vertex;

Constructor TMD2Reader.Create(AFileName:string);
 var
  head:TMD2Header;
  frame:TMD2Frame;
  verts:array of TMD2Vertex;
  mface:array of TMD2Face;
  i:integer;
 begin
  Stream:=TFileStream.Create(AFileName,fmOpenRead or fmShareDenyNone);
  Stream.ReadBuffer(head,SizeOf(head));
  SetLength(Vertices,head.VertexCount);
  SetLength(Faces,head.FaceCount);

  SetLength(mface,head.FaceCount);
  Stream.Position:=head.FaceOfs;
  Stream.ReadBuffer(mface[0],head.FaceCount*sizeof(TMD2Face));

  for i:=0 to head.FaceCount-1 do begin
   Faces[i].a:=mface[i].c;
   Faces[i].b:=mface[i].b;
   Faces[i].c:=mface[i].a;
  end;
  mface:=nil;

  Stream.Position:=head.FrameOfs;
  Stream.ReadBuffer(Frame,Sizeof(Frame));
  Setlength(verts,head.VertexCount);
  Stream.ReadBuffer(verts[0],head.VertexCount*SizeOf(TMD2Vertex));

  for i:=0 to head.VertexCount-1 do begin
   Vertices[i].x:=Verts[i].x*Frame.Scale.x+Frame.Trans.x;
   Vertices[i].y:=Verts[i].y*Frame.Scale.y+Frame.Trans.y;
   Vertices[i].z:=Verts[i].z*Frame.Scale.z+Frame.Trans.z;
  end;
  verts:=nil;

  Groups:=TStringList.Create;
  SetLength(Colors,1);
  Colors[0].r:=1;
  Colors[0].g:=1;
  Colors[0].b:=1;
  SetLength(Materials,1);
  Materials[0].Name:=Frame.Name;
  Materials[0].TwoSide:=False;
  Transparent:=false;
 end;

Destructor TMD2Reader.Destroy;
 begin
  Stream.Free;
  Groups.Free;
  inherited;
 end;

end.
