unit DelphiGL;

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

Const
 OpenGL='OpenGL32.DLL';
 GLU   ='GLU32.DLL';
 GLUT  ='GLUT32.DLL';

Type
 TGLMode=(
  GL_POINTS,         // Treats each vertex as a single point. Vertex n defines point n. N points are drawn.
  GL_LINES,          // Treats each pair of vertexes as an independent line segment. Vertexes 2n - 1 and 2n define line n. N/2 lines are drawn.
  GL_LINE_LOOP,      // Draws a connected group of line segments from the first vertex to the last, then back to the first. Vertexes n and n+1 define line n. The last line, however, is defined by vertexes N and 1. N lines are drawn.
  GL_LINE_STRIP,     // Draws a connected group of line segments from the first vertex to the last. Vertexes n and n+1 define line n. N - 1 lines are drawn.
  GL_TRIANGLES,      // Treats each triplet of vertexes as an independent triangle. Vertexes 3n - 2, 3n-1, and 3n define triangle n. N/3 triangles are drawn.
  GL_TRIANGLE_STRIP, // Draws a connected group of triangles. One triangle is defined for each vertex presented after the first two vertexes. For odd n, vertexes n, n+1, and n+2 define triangle n.
                     // For even n, vertexes n+1, n, and n+2 define triangle n. N  - 2 triangles are drawn.
  GL_TRIANGLE_FAN,   // Draws a connected group of triangles. One triangle is defined for each vertex presented after the first two vertexes. Vertexes 1, n+1, and n+2 define triangle n. N - 2 triangles are drawn.
  GL_QUADS,          // Treats each group of four vertexes as an independent quadrilateral. Vertexes 4n - 3, 4n - 2, 4n - 1, and 4n define quadrilateral n. N/4 quadrilaterals are drawn.
  GL_QUAD_STRIP,     // Draws a connected group of quadrilaterals. One quadrilateral is defined for each pair of vertexes presented after the first pair. Vertexes 2n - 1, 2n, 2n+2, and 2n+1 define quadrilateral n. N quadrilaterals are drawn. Note that the order in which vertexes are used to construct a quadrilateral from strip data is different from that used with independent data.
  GL_POLYGON         // Draws a single, convex polygon. Vertexes 1 through N define this polygon.
 );
 TGLBorder    =0..1;

Const
 GL_FALSE                       = False;
 GL_TRUE                        = True;

 GL_ZERO                        =$0000;
 GL_ONE                         =$0001;

 GL_DEPTH_BUFFER_BIT            =$0100; // Indicates the depth buffer.
 GL_ACCUM_BUFFER_BIT            =$0200; // Indicates the accumulation buffer.
 GL_NEVER                       =$0200; // Never passes.
 GL_LESS                        =$0201; // Passes if the incoming z value is less than the stored z value.
 GL_EQUAL                       =$0202; // Passes if the incoming z value is equal to the stored z value.
 GL_LEQUAL                      =$0203; // Passes if the incoming z value is less than or equal to the stored z value.
 GL_GREATER                     =$0204; // Passes if the incoming z value is greater than the stored z value.
 GL_NOTEQUAL                    =$0205; // Passes if the incoming z value is not equal to the stored z value.
 GL_GEQUAL                      =$0206; // Passes if the incoming z value is greater than or equal to the stored z value.
 GL_ALWAYS                      =$0207; // Always passes.

 GL_SRC_COLOR                   =$0300;
 GL_ONE_MINUS_SRC_COLOR         =$0301;
 GL_SRC_ALPHA                   =$0302;
 GL_ONE_MINUS_SRC_ALPHA         =$0303;
 GL_DST_ALPHA                   =$0304;
 GL_ONE_MINUS_DST_ALPHA         =$0305;
 GL_DST_COLOR                   =$0306;
 GL_ONE_MINUS_DST_COLOR         =$0307;
 GL_SRC_ALPHA_SATURATE          =$0308;

 GL_STENCIL_BUFFER_BIT          =$0400; // Indicates the stencil buffer.
 GL_FRONT                       =$0404;
 GL_BACK                        =$0405;
 GL_FRONT_AND_BACK              =$0408;

 GL_INVALID_ENUM                =$0500; // is generated if cap is not one of the values listed above.
 GL_INVALID_OPERATION           =$0502; // is generated if glEnable is called between a call to glBegin and the corresponding call to glEnd.

 GL_EXP                         =$0800;
 GL_EXP2                        =$0801;

 GL_CW                          =$0900;
 GL_CCW                         =$0901;

 GL_POINT_SMOOTH                =$0B10; // If enabled, draw points with proper filtering. Otherwise, draw aliased points. See glPointSize.
 GL_LINE_SMOOTH                 =$0B20; // If enabled, draw lines with correct filtering. Otherwise, draw aliased lines. See glLineWidth.
 GL_LINE_STIPPLE                =$0B24; // If enabled, use the current line stipple pattern when drawing lines. See glLineStipple.
 GL_POLYGON_SMOOTH              =$0B41; // If enabled, draw polygons with proper filtering. Otherwise, draw aliased polygons. See glPolygonMode.
 GL_POLYGON_STIPPLE             =$0B42; // If enabled, use the current polygon stipple pattern when rendering polygons. See glPolygonStipple.
 GL_CULL_FACE                   =$0B44; // If enabled, cull polygons based on their winding in window coordinates. See glCullFace.
 GL_LIGHTING                    =$0B50; // If enabled, use the current lighting parameters to compute the vertex color or index. Otherwise, simply associate the current color or index with each vertex. See glMaterial, glLightModel, and glLight.
 GL_LIGHT_MODEL_LOCAL_VIEWER    =$0B51;
 GL_LIGHT_MODEL_TWO_SIDE        =$0B52;
 GL_LIGHT_MODEL_AMBIENT         =$0B53;
 GL_COLOR_MATERIAL              =$0B57; // If enabled, have one or more material parameters track the current color. See glColorMaterial.
 GL_FOG                         =$0B60; // If enabled, blend a fog color into the posttexturing color. See glFog.
 GL_FOG_INDEX                   =$0B61;
 GL_FOG_DENSITY                 =$0B62;
 GL_FOG_START                   =$0B63;
 GL_FOG_END                     =$0B64;
 GL_FOG_MODE                    =$0B65;
 GL_FOG_COLOR                   =$0B66;
 GL_DEPTH_TEST                  =$0B71; // If enabled, do depth comparisons and update the depth buffer. See glDepthFunc and glDepthRange.
 GL_STENCIL_TEST                =$0B90; // If enabled, do stencil testing and update the stencil buffer. See glStencilFunc and glStencilOp.
 GL_NORMALIZE                   =$0BA1; // If enabled, normal vectors specified with glNormal are scaled to unit length after transformation. See glNormal.
 GL_ALPHA_TEST                  =$0BC0; // If enabled, do alpha testing. See glAlphaFunc.
 GL_DITHER                      =$0BD0; // If enabled, dither color components or indices before they are written to the color buffer.
 GL_BLEND_DST                   =$0BE0;
 GL_BLEND_SRC                   =$0BE1;
 GL_BLEND                       =$0BE2; // If enabled, blend the incoming RGBA color values with the values in the color buffers. See glBlendFunc.
 GL_LOGIC_OP                    =$0BF1; // If enabled, apply the currently selected logical operation to the incoming and color buffer indices. See glLogicOp.

 GL_SCISSOR_TEST                =$0C11; // If enabled, discard fragments that are outside the scissor rectangle. See glScissor.
 GL_PERSPECTIVE_CORRECTION_HINT =$0C50;
 GL_POINT_SMOOTH_HINT           =$0C51;
 GL_LINE_SMOOTH_HINT            =$0C52;
 GL_POLYGON_SMOOTH_HINT         =$0C53;
 GL_FOG_HINT                    =$0C54;
 GL_TEXTURE_GEN_S               =$0C60; // If enabled, the s texture coordinate is computed using the texture generation function defined with glTexGen. Otherwise, the current s texture coordinate is used.
 GL_TEXTURE_GEN_T               =$0C61; // If enabled, the t texture coordinate is computed using the texture generation function defined with glTexGen. Otherwise, the current t texture coordinate is used.
 GL_TEXTURE_GEN_Q               =$0C63; // If enabled, the q texture coordinate is computed using the texture generation function defined with glTexGen. Otherwise, the current q texture coordinate is used.
 GL_TEXTURE_GEN_R               =$0C62; // If enabled, the r texture coordinate is computed using the texture generation function defined with glTexGen. Otherwise, the current r texture coordinate is used.
 GL_UNPACK_SWAP_BYTES           =$0CF0;
 GL_UNPACK_LSB_FIRST            =$0CF1;
 GL_UNPACK_ROW_LENGTH           =$0CF2;
 GL_UNPACK_SKIP_PIXELS          =$0CF4;
 GL_UNPACK_SKIP_ROWS            =$0CF3;
 GL_UNPACK_ALIGNMENT            =$0CF5;

 GL_PACK_SWAP_BYTES             =$0D00;
 GL_PACK_LSB_FIRST              =$0D01;
 GL_PACK_ROW_LENGTH             =$0D02;
 GL_PACK_SKIP_PIXELS            =$0D04;
 GL_PACK_SKIP_ROWS              =$0D03;
 GL_PACK_ALIGNMENT              =$0D05;
 GL_AUTO_NORMAL                 =$0D80; // If enabled, compute surface normal vectors analytically when either GL_MAP2_VERTEX_3 or GL_MAP2_VERTEX_4 is used to generate vertexes. See glMap2.
(*
 GL_MAP1_COLOR_4                =$0D90; // If enabled, calls to glEvalCoord1, glEvalMesh1, and glEvalPoint1 will generate RGBA values. See glMap1.
 GL_MAP1_INDEX                  =$0D91; // If enabled, calls to glEvalCoord1, glEvalMesh1, and glEvalPoint1 will generate color indices. See glMap1.
 GL_MAP1_NORMAL                 =$0D92; // If enabled, calls to glEvalCoord1, glEvalMesh1, and glEvalPoint1 will generate normals. See glMap1.
 GL_MAP1_TEXTURE_COORD_1        =$0D93; // If enabled, calls to glEvalCoord1, glEvalMesh1, and glEvalPoint1 will generate s texture coordinates. See glMap1.
 GL_MAP1_TEXTURE_COORD_2        =$0D94; // If enabled, calls to glEvalCoord1, glEvalMesh1, and glEvalPoint1 will generate s and t texture coordinates. See glMap1.
 GL_MAP1_TEXTURE_COORD_3        =$0D95; // If enabled, calls to glEvalCoord1, glEvalMesh1, and glEvalPoint1 will generate s, t, and r texture coordinates. See glMap1.
 GL_MAP1_TEXTURE_COORD_4        =$0D96; // If enabled, calls to glEvalCoord1, glEvalMesh1, and glEvalPoint1 will generate s, t, r, and q texture coordinates. glMap1.
 GL_MAP1_VERTEX_3               =$0D97; // If enabled, calls to glEvalCoord1, glEvalMesh1, and glEvalPoint1 will generate x, y, and z vertex coordinates. See glMap1.
 GL_MAP1_VERTEX_4               =$0D98; // If enabled, calls to glEvalCoord1, glEvalMesh1, and glEvalPoint1 will generate homogeneous x, y, z, and w vertex coordinates. See glMap1.
 GL_MAP2_COLOR_4                =$0DB0; // If enabled, calls to glEvalCoord2, glEvalMesh2, and glEvalPoint2 will generate RGBA values. See glMap2.
 GL_MAP2_INDEX                  =$0DB1; // If enabled, calls to glEvalCoord2, glEvalMesh2, and glEvalPoint2 will generate color indices. See glMap2.
 GL_MAP2_NORMAL                 =$0DB2; // If enabled, calls to glEvalCoord2, glEvalMesh2, and glEvalPoint2 will generate normals. See glMap2.
 GL_MAP2_TEXTURE_COORD_1        =$0DB3; // If enabled, calls to glEvalCoord2, glEvalMesh2, and glEvalPoint2 will generate s texture coordinates. See glMap2.
 GL_MAP2_TEXTURE_COORD_2        =$0DB4; // If enabled, calls to glEvalCoord2, glEvalMesh2, and glEvalPoint2 will generate s and t texture coordinates. See glMap2.
 GL_MAP2_TEXTURE_COORD_3        =$0DB5; // If enabled, calls to glEvalCoord2, glEvalMesh2, and glEvalPoint2 will generate s, t, and r texture coordinates. See glMap2.
 GL_MAP2_TEXTURE_COORD_4        =$0DB6; // If enabled, calls to glEvalCoord2, glEvalMesh2, and glEvalPoint2 will generate s, t, r, and q texture coordinates. See glMap2.
 GL_MAP2_VERTEX_3               =$0DB7; // If enabled, calls to glEvalCoord2, glEvalMesh2, and glEvalPoint2 will generate x, y, and z vertex coordinates. See glMap2.
 GL_MAP2_VERTEX_4               =$0DB8; // If enabled, calls to glEvalCoord2, glEvalMesh2, and glEvalPoint2 will generate homogeneous x, y, z, and w vertex coordinates. See glMap2.
*)
 GL_TEXTURE_1D                  =$0DE0; // If enabled, one-dimensional texturing is performed (unless two-dimensional texturing is also enabled). See glTexImage1D.
 GL_TEXTURE_2D                  =$0DE1; // If enabled, two-dimensional texturing is performed. See glTexImage2D.

 GL_DONT_CARE                   =$1100; // The client doesn't have a preference.
 GL_FASTEST                     =$1101; // The most efficient option should be chosen.
 GL_NICEST                      =$1102; // The most correct, or highest quality, option should be chosen.

 GL_AMBIENT                     =$1200;
 GL_DIFFUSE                     =$1201;
 GL_SPECULAR                    =$1202;
 GL_POSITION                    =$1203;
 GL_SPOT_DIRECTION              =$1204;
 GL_SPOT_EXPONENT               =$1205;
 GL_SPOT_CUTOFF                 =$1206;
 GL_CONSTANT_ATTENUATION        =$1207;
 GL_LINEAR_ATTENUATION          =$1208;
 GL_QUADRATIC_ATTENUATION       =$1209;

 GL_COMPILE                     =$1300;
 GL_COMPILE_AND_EXECUTE         =$1301;

 GL_BYTE                        =$1400;
 GL_UNSIGNED_BYTE               =$1401;
 GL_SHORT                       =$1402;
 GL_UNSIGNED_SHORT              =$1403;
 GL_INT                         =$1404;
 GL_UNSIGNED_INT                =$1405;
 GL_FLOAT                       =$1406;
 GL_2_BYTES                     =$1407;
 GL_3_BYTES                     =$1408;
 GL_4_BYTES                     =$1409;
 GL_DOUBLE                      =$140A;
 GL_DOUBLE_EXT                  =$140A;

 GL_INVERT                      =$150A;

 GL_SHININESS                   =$1601;
 GL_AMBIENT_AND_DIFFUSE         =$1602;

 GL_MODELVIEW                   =$1700; // Applies subsequent matrix operations to the modelview matrix stack.
 GL_PROJECTION                  =$1701; // Applies subsequent matrix operations to the projection matrix stack.
 GL_TEXTURE                     =$1702; // Applies subsequent matrix operations to the texture matrix stack.

 GL_COLOR_INDEX                 =$1900;
 GL_RED                         =$1903;
 GL_GREEN                       =$1904;
 GL_BLUE                        =$1905;
 GL_ALPHA                       =$1906;
 GL_RGB                         =$1907;
 GL_RGBA                        =$1908;
 GL_LUMINANCE                   =$1909;
 GL_LUMINANCE_ALPHA             =$190A;

 GL_POINT                       =$1B00;
 GL_LINE                        =$1B01;
 GL_FILL                        =$1B02;

 GL_FLAT                        =$1D00;
 GL_SMOOTH                      =$1D01;

 GL_KEEP                        =$1E00;
 GL_REPLACE                     =$1E01;
 GL_INCR                        =$1E02;
 GL_DECR                        =$1E03;

 GL_VENDOR                      =$1F00; // Returns the company responsible for this GL implementation. This name does not change from release to release.
 GL_RENDERER                    =$1F01; // Returns the name of the renderer. This name is typically specific to a particular configuration of a hardware platform. It does not change from release to release.
 GL_VERSION                     =$1F02; // Returns a version or release number.
 GL_EXTENSIONS                  =$1F03; // Returns a space-separated list of supported extensions to GL. );

 GL_NEAREST                     =$2600;
 GL_LINEAR                      =$2601;

 GL_NEAREST_MIPMAP_NEAREST      =$2700;
 GL_LINEAR_MIPMAP_NEAREST       =$2701;
 GL_NEAREST_MIPMAP_LINEAR       =$2702;
 GL_LINEAR_MIPMAP_LINEAR        =$2703;

 GL_TEXTURE_MAG_FILTER          =$2800;
 GL_TEXTURE_MIN_FILTER          =$2801;
 GL_TEXTURE_WRAP_S              =$2802;
 GL_TEXTURE_WRAP_T              =$2803;

 GL_CLAMP                       =$2900;
 GL_REPEAT                      =$2901;
(*
 GL_CLIP_PLANE0                 =$3000; // If enabled, clip geometry against user-defined clipping plane i. See glClipPlane.
 GL_CLIP_PLANE1                 =$3001;
 GL_CLIP_PLANE2                 =$3002;
 GL_CLIP_PLANE3                 =$3003;
 GL_CLIP_PLANE4                 =$3004;
 GL_CLIP_PLANE5                 =$3005;
*)
 GL_COLOR_BUFFER_BIT            =$4000; // Indicates the buffers currently enabled for color writing.
 GL_LIGHT0                      =$4000; // If enabled, include light i in the evaluation of the lighting equation. See glLightModel and glLight.
 GL_LIGHT1                      =$4001;
 GL_LIGHT2                      =$4002;
 GL_LIGHT3                      =$4003;
 GL_LIGHT4                      =$4004;
 GL_LIGHT5                      =$4005;
 GL_LIGHT6                      =$4006;
 GL_LIGHT7                      =$4007;

 GL_POLYGON_OFFSET_EXT          =$8037;
 GL_POLYGON_OFFSET_FILL         =$8037;

  GL_VERTEX_ARRAY               =$8074;
  GL_NORMAL_ARRAY               =$8075;
  GL_COLOR_ARRAY                =$8076;
  GL_INDEX_ARRAY                =$8077;
  GL_TEXTURE_COORD_ARRAY        =$8078;
  GL_EDGE_FLAG_ARRAY            =$8079;
  GL_VERTEX_ARRAY_SIZE          =$807A;
  GL_VERTEX_ARRAY_TYPE          =$807B;
  GL_VERTEX_ARRAY_STRIDE        =$807C;
  GL_NORMAL_ARRAY_TYPE          =$807E;
  GL_NORMAL_ARRAY_STRIDE        =$807F;
  GL_COLOR_ARRAY_SIZE           =$8081;
  GL_COLOR_ARRAY_TYPE           =$8082;
  GL_COLOR_ARRAY_STRIDE         =$8083;
  GL_INDEX_ARRAY_TYPE           =$8085;
  GL_INDEX_ARRAY_STRIDE         =$8086;
  GL_TEXTURE_COORD_ARRAY_SIZE   =$8088;
  GL_TEXTURE_COORD_ARRAY_TYPE   =$8089;
  GL_TEXTURE_COORD_ARRAY_STRIDE =$808A;
  GL_EDGE_FLAG_ARRAY_STRIDE     =$808C;

procedure glBegin(mode:TGLMode); stdcall external OpenGL;
procedure glBindTexture(Target,Texture:integer); stdcall external OpenGL;
procedure glBlendFunc(sfactor,dfactor:integer); stdcall external OpenGL;
procedure glCallList(list:integer); stdcall external OpenGL;
procedure glCallLists(Count,DataType:integer; data:pointer); stdcall external OpenGL;
procedure glClear(buffers:integer); stdcall external OpenGL;
procedure glClearColor(red,green,blue,alpha:single); stdcall external OpenGL;
procedure glClearDepth(depth:double); stdcall external OpenGL;
procedure glColor3f(r,g,b:single); stdcall external OpenGL;
procedure glColor3i(r,g,b:integer); stdcall external OpenGL;
procedure glColor4f(r,g,b,a:single); stdcall external OpenGL;
procedure glColor4fv(var rgba); stdcall external OpenGL;
procedure glColorMask(r,g,b,a:boolean); stdcall external OpenGL;
procedure glColorMaterial(face,mode:integer); stdcall external OpenGL;
procedure glCullFace(mode:integer); stdcall external OpenGL;
procedure glDeleteLists(list,count:integer); stdcall external OpenGL;
procedure glDeleteTextures(count:integer;var Textures:integer); stdcall external OpenGL;
procedure glDisable(cap:integer); stdcall external OpenGL;
procedure glDisableClientState(state:integer); stdcall external OpenGL;
procedure glDepthFunc(func:integer); stdcall external OpenGL;
procedure glDrawElements(mode:TGLMode; count, format:integer; var Elements); stdcall external OpenGL;
procedure glEnable(cap:integer); stdcall external OpenGL;
procedure glEnableClientState(state:integer); stdcall external OpenGL;
procedure glEnd; stdcall external OpenGL;
procedure glEndList; stdcall external OpenGL;
procedure glFinish; stdcall external OpenGL;
procedure glFlush; stdcall external OpenGL;
procedure glFogf(name:integer;param:single); stdcall external OpenGL;
procedure glFogfv(name:integer;var param:single); stdcall external OpenGL;
procedure glFogi(name,param:integer); stdcall external OpenGL;
procedure glFrontFace(mode:integer); stdcall external OpenGL;
procedure glFrustum(left,right,bottom,top,znear,zfar:double); stdcall external OpenGL;
function  glGenLists(Count:integer):integer; stdcall external OpenGL;
procedure glGenTextures(count:integer; Handles:pointer); stdcall external OpenGL;
function  glGetString(Name:integer):PChar; stdcall external OpenGL;
procedure glHint(target,mode:integer); stdcall external OpenGL;
function  glIsEnabled(cap:integer):boolean; stdcall external OpenGL;
procedure glLightModeli(name:integer; param:single); stdcall external OpenGL;
procedure glLightModelfv(name:integer; var param); stdcall external OpenGL;
procedure glLightf(Light,Name:integer; Param:single); stdcall external OpenGL;
procedure glLightfv(Light,Name:integer; var Param); stdcall external OpenGL;
procedure glLineWidth(width:single); stdcall external OpenGL;
procedure glListBase(base:integer); stdcall external OpenGL;
procedure glLoadIdentity; stdcall external OpenGL;
procedure glMaterialf(face,name:integer; param:single ); stdcall external OpenGL;
procedure glMaterialfv(face,name:integer; var params); stdcall external OpenGL;
procedure glMatrixMode(Mode:integer); stdcall external OpenGL;
procedure glMultMatrixf(var Matrix:single); stdcall external OpenGL;
procedure glNewList(list,mode:integer); stdcall external OpenGL;
procedure glNormal3f(nx,ny,nz:single); stdcall external OpenGL;
procedure glNormalPointer(format,skip:integer;var vertexPointer); stdcall external OpenGL;
procedure glOrtho(Left,Right,Bottom,Top,zNear,zFar:double); stdcall external OpenGL;
procedure glPixelStorei(name,param:integer); stdcall external OpenGL;
procedure glPointSize(size:single); stdcall external OpenGL;
procedure glPolygonMode(face,mode:integer); stdcall external OpenGL;
procedure glPopMatrix; stdcall external OpenGL;
procedure glPushMatrix; stdcall external OpenGL;
procedure glRasterPos2f(x,y:single); stdcall external OpenGL;
procedure glRasterPos3f(x,y,z:single); stdcall external OpenGL;
procedure glRotated(angle,x,y,z:double); stdcall external OpenGL;
procedure glRotatef(angle,x,y,z:single); stdcall external OpenGL;
procedure glScalef(x,y,z:single); stdcall external OpenGL;
procedure glShadeModel(mode:integer); stdcall external OpenGL;
procedure glStencilFunc(func,ref,mask:integer); stdcall external OpenGL;
procedure glStencilOp(fail,zfail,zpass:integer); stdcall external OpenGL;
procedure glTexCoord2f(s,t:single); stdcall external OpenGL;
procedure glTexCoord2i(s,t:integer); stdcall external OpenGL;
procedure glTexCoord3f(s,t,r:single); stdcall external OpenGL;
procedure glTexCoord3i(s,t,r:integer); stdcall external OpenGL;
procedure glTexCoordPointer(components,format,start:integer;var TexCoorPointer); stdcall external OpenGL;
procedure glTexImage2D(Target,detail:integer; components,width,height:integer; border:TGLBorder; format,DataType:integer; pixels:pointer); stdcall external OpenGL;
procedure glTexParameteri(Target,Name:integer; Value:integer); stdcall external OpenGL;
procedure glTranslated(x,y,z:double); stdcall external OpenGL;
procedure glTranslatef(x,y,z:single); stdcall external OpenGL;
procedure glVertex2fv(xy:pointer); stdcall external OpenGL;
procedure glVertex2f(x,y:single); stdcall external OpenGL;
procedure glVertex2i(x,y:integer); stdcall external OpenGL;
procedure glVertex3d(x,y,z:double); stdcall external OpenGL;
procedure glVertex3f(x,y,z:single); stdcall external OpenGL;
procedure glVertex3fv(xyz:pointer); stdcall external OpenGL;
procedure glVertex3i(x,y,z:integer); stdcall external OpenGL;
procedure glVertexPointer(components,format,skip:integer;var vertexPointer); stdcall external OpenGL;
procedure glViewport(x,y,width,height:integer); stdcall external OpenGL;

Type
 TGLUTess=integer;
Type
 TGLUTessCallBack=integer;
Const
 GLU_TESS_BEGIN          = 100100;
 GLU_TESS_VERTEX         = 100101;
 GLU_TESS_END            = 100102;
 GLU_TESS_ERROR          = 100103;
 GLU_TESS_EDGE_FLAG      = 100104;
 GLU_TESS_COMBINE        = 100105;
 GLU_TESS_BEGIN_DATA     = 100106;
 GLU_TESS_VERTEX_DATA    = 100107;
 GLU_TESS_END_DATA       = 100108;
 GLU_TESS_ERROR_DATA     = 100109;
 GLU_TESS_EDGE_FLAG_DATA = 100110;
 GLU_TESS_COMBINE_DATA   = 100111;

Type
 TGLVertex=record x,y,z:double end;

procedure gluBuild2DMipmaps(target:integer; components,width,height:integer; format,DataType:integer; pixels:pointer); stdcall external GLU;
procedure gluCylinder(qobj:integer; baseRadius,topRadius,height:double; slices,stacks:integer); stdcall external GLU;
procedure gluDeleteQuadric(state:integer); stdcall external GLU;
procedure gluDeleteTess(Tess:TGLUTess); stdcall external GLU;
procedure gluDisk(qobj:integer; innerRadius,outerRadius:double; slices,loops:integer); stdcall external GLU;
function  gluErrorString(error:integer):PChar; stdcall external GLU;
procedure gluLookAt(eyex,eyey,eyez,centerx,centery,centerz,upx,upy,upz:double); stdcall external GLU;
function  gluNewQuadric:integer; stdcall external GLU;
function  gluNewTess:TGLUTess; stdcall external GLU;
procedure gluSphere(qobj:integer; radius:double; slices,stacks:integer); stdcall external GLU;
procedure gluTessBeginContour(Tess:TGLUTess); stdcall external GLU;
procedure gluTessBeginPolygon(Tess:TGLUTess; data:pointer); stdcall external GLU;
procedure gluTessCallback(Tess:TGLUTess; which:TGLUTessCallBack; fn:pointer); stdcall external GLU;
procedure gluTessEndContour(Tess:TGLUTess); stdcall external GLU;
procedure gluTessEndPolygon(Tess:TGLUTess); stdcall external GLU;
procedure gluTessVertex(Tess:TGLUTess;const Vertex:TGLVertex; data:pointer); stdcall external GLU;

procedure gluPerspective(fovy, aspect, zNear, zFar: double);

const
  GLUT_WINDOW_X                 = 100;
  GLUT_WINDOW_Y                 = 101;
  GLUT_WINDOW_WIDTH             = 102;
  GLUT_WINDOW_HEIGHT            = 103;
  GLUT_WINDOW_BUFFER_SIZE       = 104;
  GLUT_WINDOW_STENCIL_SIZE      = 105;
  GLUT_WINDOW_DEPTH_SIZE        = 106;
  GLUT_WINDOW_RED_SIZE          = 107;
  GLUT_WINDOW_GREEN_SIZE        = 108;
  GLUT_WINDOW_BLUE_SIZE         = 109;
  GLUT_WINDOW_ALPHA_SIZE        = 110;
  GLUT_WINDOW_ACCUM_RED_SIZE    = 111;
  GLUT_WINDOW_ACCUM_GREEN_SIZE  = 112;
  GLUT_WINDOW_ACCUM_BLUE_SIZE   = 113;
  GLUT_WINDOW_ACCUM_ALPHA_SIZE  = 114;
  GLUT_WINDOW_DOUBLEBUFFER      = 115;
  GLUT_WINDOW_RGBA              = 116;
  GLUT_WINDOW_PARENT            = 117;
  GLUT_WINDOW_NUM_CHILDREN      = 118;
  GLUT_WINDOW_COLORMAP_SIZE     = 119;
  GLUT_WINDOW_NUM_SAMPLES       = 120;
  GLUT_WINDOW_STEREO            = 121;
  GLUT_WINDOW_CURSOR            = 122;
  GLUT_SCREEN_WIDTH             = 200;
  GLUT_SCREEN_HEIGHT            = 201;
  GLUT_SCREEN_WIDTH_MM          = 202;
  GLUT_SCREEN_HEIGHT_MM         = 203;
  GLUT_MENU_NUM_ITEMS           = 300;
  GLUT_DISPLAY_MODE_POSSIBLE    = 400;
  GLUT_INIT_WINDOW_X            = 500;
  GLUT_INIT_WINDOW_Y            = 501;
  GLUT_INIT_WINDOW_WIDTH        = 502;
  GLUT_INIT_WINDOW_HEIGHT       = 503;
  GLUT_INIT_DISPLAY_MODE        = 504;
  GLUT_ELAPSED_TIME             = 700;

  GLUT_LEFT_BUTTON    = 0;
  GLUT_MIDDLE_BUTTON  = 1;
  GLUT_RIGHT_BUTTON   = 2;
  GLUT_DOWN = 0;
  GLUT_UP   = 1;

  GLUT_NOT_VISIBLE  = 0;
  GLUT_VISIBLE      = 1;

const
  GLUT_RGB          = 0;
  GLUT_RGBA         = GLUT_RGB;
  GLUT_INDEX        = 1;
  GLUT_SINGLE       = 0;
  GLUT_DOUBLE       = 2;
  GLUT_ACCUM        = 4;
  GLUT_ALPHA        = 8;
  GLUT_DEPTH        = 16;
  GLUT_STENCIL      = 32;
  GLUT_MULTISAMPLE  = 128;
  GLUT_STEREO       = 256;
  GLUT_LUMINANCE    = 512;

 const // glutSetCursor()
// Basic arrows.
  GLUT_CURSOR_RIGHT_ARROW         = 0;
  GLUT_CURSOR_LEFT_ARROW          = 1;
// Symbolic cursor shapes.
  GLUT_CURSOR_INFO                = 2;
  GLUT_CURSOR_DESTROY             = 3;
  GLUT_CURSOR_HELP                = 4;
  GLUT_CURSOR_CYCLE               = 5;
  GLUT_CURSOR_SPRAY               = 6;
  GLUT_CURSOR_WAIT                = 7;
  GLUT_CURSOR_TEXT                = 8;
  GLUT_CURSOR_CROSSHAIR           = 9;
// Directional cursors.
  GLUT_CURSOR_UP_DOWN             = 10;
  GLUT_CURSOR_LEFT_RIGHT          = 11;
// Sizing cursors.
  GLUT_CURSOR_TOP_SIDE            = 12;
  GLUT_CURSOR_BOTTOM_SIDE         = 13;
  GLUT_CURSOR_LEFT_SIDE           = 14;
  GLUT_CURSOR_RIGHT_SIDE          = 15;
  GLUT_CURSOR_TOP_LEFT_CORNER     = 16;
  GLUT_CURSOR_TOP_RIGHT_CORNER    = 17;
  GLUT_CURSOR_BOTTOM_RIGHT_CORNER = 18;
  GLUT_CURSOR_BOTTOM_LEFT_CORNER  = 19;
// Inherit from parent window.
  GLUT_CURSOR_INHERIT             = 100;
// Blank cursor.
  GLUT_CURSOR_NONE                = 101;
// Fullscreen crosshair (if available).
  GLUT_CURSOR_FULL_CROSSHAIR      = 102;

procedure  glutAddMenuEntry(Caption:pchar; tag:integer); stdcall external GLUT;
procedure glutAttachMenu(mode:integer); stdcall external GLUT;
procedure  glutCreateMenu(func:pointer); stdcall external GLUT;
procedure glutCreateWindow(title:pchar); stdcall external GLUT;
procedure glutDisplayFunc(func:pointer); stdcall external GLUT;
procedure glutFullScreen; stdcall external GLUT;
function glutGet(atype:integer):integer; stdcall external GLUT;
procedure glutIdleFunc(func:pointer); stdcall external GLUT;
procedure glutInit(var argc:integer;var argv:pchar); stdcall external GLUT;
procedure glutInitDisplayMode(mode:integer); stdcall external GLUT;
procedure glutInitDisplayString(caption:pchar); stdcall external GLUT;
procedure glutInitWindowSize(width,height:integer); stdcall external GLUT;
procedure glutKeyboardFunc(func:pointer); stdcall external GLUT;
procedure glutMainLoop; stdcall external GLUT;
procedure glutMotionFunc(func:pointer); stdcall external GLUT;
procedure glutMouseFunc(func:pointer); stdcall external GLUT;
procedure glutPassiveMotionFunc(func:pointer); stdcall external GLUT;
procedure glutPostRedisplay; stdcall external GLUT;
procedure glutReshapeFunc(func:pointer); stdcall external GLUT;
procedure glutSetCursor(cursor:integer); stdcall external GLUT;
procedure glutSolidSphere(radius:double; slices, stacks:integer); stdcall external GLUT;
procedure glutSpecialFunc(func:pointer); stdcall external GLUT;
procedure glutSwapBuffers; stdcall external GLUT;
procedure glutVisibilityFunc(func:pointer); stdcall external GLUT;

implementation

Uses
 Math;

procedure gluPerspective(fovy, aspect, zNear, zFar: double);
 var
  xmin,xmax,ymin,ymax:double;
 begin
  ymax:=zNear*tan(fovy*PI/360);
  ymin:=-ymax;
  xmin:=ymin*aspect;
  xmax:=ymax*aspect;
  glFrustum(xmin,xmax,ymin,ymax,zNear,zFar);
 end;

initialization
 Set8087CW($133F);
end.
