unit GLRender;

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
   group:integer;
   material:integer;
  end;
  TFaces=array of TFace;

  TMaterial=record
   Name    :string;
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
   fNormals  :array { FaceCount  } of record x,y,z,mz:single end;
   fGouraud  :array { VertexCount} of record r,g,b,a:single end;
   fZSort    :array { FaceCount  } of integer;
   fColors   :TColors;
   fMaterials:TMaterials;
   fGroups   :TStringList;
   fFaceCount:integer;
   fVertexCount:integer;
   fTransparent:boolean;
   function GetMaterialCount:integer;
   function GetMaterialName(Index:integer):string;
  protected
   procedure ComputeNormals;
   procedure ZSort;
  public
   Constructor Create;
   Destructor Destroy;
   procedure LoadFromFile(FileName:string);
   procedure Normalise;
   procedure Reset;
   procedure Rotate(rx,ry,rz:single);
   procedure Render;
   procedure RenderSelection(Index:integer);
   property Groups:TStringList read fGroups;
   property MaterialCount:integer read GetMaterialCount;
   property MaterialNames[Index:integer]:string read GetMaterialName;
  end;

  TGLReader=class
   Vertices   :TVertices;
   Faces      :TFaces;
   Groups     :TStrings;
   Colors     :TColors;
   Transparent:boolean;
   Materials  :TMaterials;
  end;

{$ifdef log}
type
 TLog=procedure(s:string) of object;
var
 Log:TLog;
{$endif}

implementation

Uses
 Load3DS, // 3D Studio       .3DS
 LoadOBJ, // Poser wavefront .OBJ
 LoadMD2; // Quake 2 Model   .MD2

Constructor TGLObject.Create;
 begin
  fGroups:=TStringList.Create;
 end;

Destructor TGLObject.Destroy;
 begin
  fGroups.Free;
 end;

Procedure TGLObject.LoadFromFile(FileName:string);
 var
  ext:string;
  i:integer;
  Reader:TGLReader;
 begin
  ext:=Uppercase(ExtractFileExt(FileName));
  if ext='.3DS' then Reader:=T3DSReader.Create(FileName) else
  if ext='.OBJ' then Reader:=TOBJReader.Create(FileName) else
  if ext='.MD2' then Reader:=TMD2Reader.Create(FileName) else exit;
  fVertices:=reader.Vertices;
  fFaces:=reader.Faces;
  fColors:=reader.Colors;
  fMaterials:=reader.Materials;
  fGroups.Assign(reader.Groups);
  fVertexCount:=Length(fVertices);
  fFaceCount:=Length(fFaces);
  fTransparent:=reader.Transparent;
  Reader.Free;
  SetLength(fZSort,fFaceCount);
  for i:=0 to fFaceCount-1 do fZSort[i]:=i;
  SetLength(fPoints,fVertexCount);
 end;
//----------------------------------------------------------------------------//
Procedure TGLObject.Normalise;
 var
  xmin,xmax:single;
  ymin,ymax:single;
  zmin,zmax:single;
  i:integer;
  z1,z2:single;
  ox,oy,oz:single;
 begin
  if (fVertexCount=0)or(fFaceCount=0) then exit;
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
  Reset;
 end;

procedure TGLObject.Reset;
 begin
  Move(fVertices[0],fPoints[0],fVertexCount*SizeOf(TVertex));
 end;

Procedure TGLObject.Rotate(rx,ry,rz:single);
 var
  cosx,cosy,cosz,sinx,siny,sinz:single;
  rx1,rx2,rx3:single;
  ry1,ry2,ry3:single;
  rz1,rz2,rz3:single;
  v:TVertex;
  i:integer;
 begin
  rx:=rx*PI/180;
  ry:=ry*PI/180;
  rz:=rz*PI/180;
  cosx:=cos(rx);
  cosy:=cos(ry);
  cosz:=cos(rz);
  sinx:=sin(rx);
  siny:=sin(ry);
  sinz:=sin(rz);
 // rotation matrix
  rx1:= cosy*cosz; rx2:=sinx*siny*cosz-cosx*sinz; rx3:=cosx*siny*cosz+sinx*sinz;
  ry1:= cosy*sinz; ry2:=sinx*siny*sinz+cosx*cosz; ry3:=cosx*siny*sinz-sinx*cosz;
  rz1:=-siny;      rz2:=sinx*cosy;                rz3:=cosx*cosy;
  SetLength(fPoints,fVertexCount);
  for i:=0 to fVertexCount-1 do begin
   v:=fPoints[i];
   with fPoints[i] do begin
    x:=rx1*v.x+rx2*v.y+rx3*v.z;
    y:=ry1*v.x+ry2*v.y+ry3*v.z;
    z:=rz1*v.x+rz2*v.y+rz3*v.z;
   end; 
  end;
 end;

Procedure TGLObject.ComputeNormals;
 type
  TColorInfo=record
   count:integer;
   ccount:integer;
   x,y,z:single;
   r,g,b:single;
   trans:single;
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
      r:=r+nz;
      g:=g+nz;
      b:=b+nz;
     end else begin
      trans:=trans+nz*fMaterials[Material].Transparency;
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
     end;
    end;
   end;

 begin
 // faces normals
  SetLength(fNormals,fFaceCount);
  SetLength(ColorInfo,fVertexCount);
  for n:=0 to fFaceCount-1 do with fFaces[n] do begin
   fNormals[n].mz:=fPoints[a].z+fPoints[b].z+fPoints[c].z;
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
   if (Material<0)or(fMaterials[Material].TwoSide) then begin
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
    ga:=trans/count;
   end;
   vl:=sqrt(nx*nx+ny*ny+nz*nz);
   if vl<>0 then begin
    nx:=nx/vl;
    ny:=ny/vl;
    nz:=nz/vl;
    gr:=gr/vl;
    gg:=gg/vl;
    gb:=gb/vl;
    ga:=ga/vl;
   end;
   fGouraud[n].r:=gr;
   fGouraud[n].g:=gg;
   fGouraud[n].b:=gb;
   fGouraud[n].a:=ga;
  end;
 end;

procedure TGLObject.ZSort;

 procedure QuickSort(il,ir:integer);
  var
   l,m,r,t:integer;
   z:single;
  begin
   l:=il;
   r:=ir;
   m:=(l+r) div 2;
   z:=fNormals[fZSort[m]].mz;
   repeat
    while fNormals[fZSort[l]].mz<z do inc(l);
    while fNormals[fZSort[r]].mz>z do dec(r);
    if l<=r then begin
     t:=fZSort[l];
     fZSort[l]:=fZSort[r];
     fZSort[r]:=t;
     inc(l);
     dec(r);
    end;
   until l>r;
   if r>il then QuickSort(il,r);
   if l<ir then Quicksort(l,ir);
  end;

 var
  i:integer;
 begin
  SetLength(fZSort,fFaceCount);
  for i:=0 to fFaceCount-1 do fZSort[i]:=i;
  QuickSort(0,fFaceCount-1);
 end;

Procedure TGLObject.Render;
 var
  i,s,m:integer;
 begin
  if fFaceCount=0 then exit;
  //RotatePoints;
  ComputeNormals;
  if fTransparent then ZSort;
  glEnable(GL_BLEND);
  glBlendFunc(GL_ONE_MINUS_SRC_ALPHA,GL_SRC_ALPHA);
  glBegin(GL_TRIANGLES);
  for i:=0 to fFaceCount-1 do begin
   s:=fZSort[i];
   if fNormals[s].z>=0 then
    with fFaces[s] do begin
     with fGouraud[a] do glColor4f (r,g,b,a);
     with fPoints [a] do glVertex3f(x,y,z);
     with fGouraud[b] do glColor4f (r,g,b,a);
     with fPoints [b] do glVertex3f(x,y,z);
     with fGouraud[c] do glColor4f (r,g,b,a);
     with fPoints [c] do glVertex3f(x,y,z);
    end;
  end;
  glEnd;
 end;

Procedure TGLObject.RenderSelection(Index:integer);
 var
  i,m:integer;
 begin
  if Index<0 then exit;
  glDisable(GL_DEPTH_TEST);
  glColor4f(0.8,0,0,0.75);
  glBegin(GL_TRIANGLES);
  for i:=0 to fFaceCount-1 do with fFaces[i] do begin
   if Group=Index then begin
    with fPoints [a] do glVertex3f(x,y,z);
    with fPoints [b] do glVertex3f(x,y,z);
    with fPoints [c] do glVertex3f(x,y,z);
   end;
  end;
  glEnd;
  glEnable(GL_DEPTH_TEST);
 end;

function TGLObject.GetMaterialCount:integer;
 begin
  Result:=Length(fMaterials);
 end;

function TGLObject.GetMaterialName(Index:integer):string;
 begin
  Result:=fMaterials[Index].Name;
 end;

end.






