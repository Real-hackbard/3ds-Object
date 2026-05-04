unit LoadOBJ;

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

{$define lof}
interface

Uses
{$ifdef log}Windows,{$endif}
 Classes,SysUtils,GLRender;

Type
 TOBJReader=class(TGLReader)
 private
  Wavefront  :TextFile;
  LastChar   :char;
  VertexCount:integer;
  FaceCount  :integer;
  MaterialCount:integer;
  function ReadChar:char;
  function ReadInteger:integer;
  procedure PreLoad;
  procedure Load;
 public
  Constructor Create(AFileName:string);
  Destructor Destroy; override;
 end;

implementation

Type
 TPoint=record
  vertex:integer;
  map   :integer;
 end;

Constructor TOBJReader.Create(AFileName:string);
 begin
  Groups:=TStringList.Create;
  with TStringList(Groups) do begin
   Sorted:=True;
   Duplicates:=dupIgnore;
  end;
  SetLength(Colors,1);
  Colors[0].r:=1;
  Colors[0].g:=1;
  Colors[0].b:=1;
  AssignFile(Wavefront,AFileName);
  Reset(Wavefront);
  if ioResult<>0 then raise exception.create('unabled to open file');
  PreLoad;
  Reset(Wavefront);
  Load;
 end;

Destructor TOBJReader.Destroy;
 begin
  CloseFile(Wavefront);
  Groups.Free;
  inherited;
 end;

Function TOBJReader.ReadChar:char;
 begin
  if eof(Wavefront) then result:=#27 else
  if eoln(Wavefront) then result:=#0 else read(Wavefront,Result);
 end;

Function TOBJReader.ReadInteger:integer;
 begin
  Result:=0;
  LastChar:=ReadChar;
  while LastChar in ['0'..'9'] do begin
   Result:=10*Result+ord(LastChar) and 15;
   LastChar:=ReadChar;
  end;
 end;

procedure TOBJReader.PreLoad;
 var
  i:integer;
  s:string;
  c1,c2:char;
 begin
  while not Eof(Wavefront) do begin
   c1:=ReadChar;
   c2:=ReadChar;
   case c1 of
    'v': if (c2=' ') then inc(VertexCount);
    'f': if (c2=' ') then begin
          i:=0;
          repeat
           ReadInteger;
           while LastChar='/' do ReadInteger;
           inc(i);
          until LastChar=#0;
          if i>2 then Inc(FaceCount,1+i-3);
         end;
    'g': if (c2=' ') then begin
          Read(Wavefront,s);
          Groups.add(s);
         end;
    'u': if (c2='s') then begin // usemtl
          Read(Wavefront,s);
          if copy(s,1,5)='emtl ' then inc(MaterialCount);
         end;
   end;
   ReadLn(Wavefront,s);
  end;
  SetLength(Vertices,VertexCount);
  SetLength(Faces,FaceCount);
  SetLength(Materials,MaterialCount);
 end;

Procedure TOBJReader.Load;
 var
  v,g,f,m,i:integer;
  c1,c2:char;
  s:string;
  a,b,c:integer;

 begin
  v:=0;
  g:=0;
  f:=0;
  m:=-1;
  while not Eof(Wavefront) do begin
   c1:=ReadChar;
   c2:=ReadChar;
   case c1 of
    'v': if (c2=' ') then begin
          with Vertices[v] do Read(Wavefront,x,y,z);
          inc(v);
         end;
    'f': if (c2=' ') then begin
          i:=0;
          a:=ReadInteger-1; while LastChar='/' do ReadInteger;
          b:=ReadInteger-1; while LastChar='/' do ReadInteger;
          while LastChar<>#0 do begin
           c:=ReadInteger-1; while LastChar='/' do ReadInteger;
           Faces[f].a:=a;
           Faces[f].b:=b;
           Faces[f].c:=c;
           Faces[f].group:=g;
           Faces[f].material:=m;
           inc(f);
           b:=c;
          end;
         end;
    'g': if (c2=' ') then begin
          Read(Wavefront,s);
          g:=Groups.Add(s);
         end;
    'u': if (c2='s') then begin // usemtl
          Read(Wavefront,s);
          if copy(s,1,5)='emtl ' then begin
           inc(m);
           Materials[m].Name:=copy(s,6,length(s));
           Materials[m].TwoSide:=True;
          end;
         end;
   end;
   ReadLn(Wavefront,s);
  end;
 end;
 
{$ifdef log}
initialization
 AllocConsole;
{$endif}
end.
