# 3ds-Object

</br>

![Compiler](https://github.com/user-attachments/assets/a916143d-3f1b-4e1f-b1e0-1067ef9e0401) <img src="https://github.com/user-attachments/assets/0902183b-42f4-4760-8f3b-0ce93db60943" />  
![Components](https://github.com/user-attachments/assets/d6a7a7a4-f10e-4df1-9c4f-b4a1a8db7f0e) <img src="https://github.com/user-attachments/assets/d53187cf-ee36-4e0f-a68f-949cd76cace6" /> <img src="https://github.com/user-attachments/assets/6a4d3dda-f898-466d-8240-20c8868a7916" />  <img src="https://github.com/user-attachments/assets/3164edbb-a6d9-43c1-be0d-f735b3ab0d75" />  
![Description](https://github.com/user-attachments/assets/dbf330e0-633c-4b31-a0ef-b1edb9ed5aa7) <img src="https://github.com/user-attachments/assets/81cb1113-9f73-4896-be87-56a4f84a9b33" />  
![Last Update](https://github.com/user-attachments/assets/e1d05f21-2a01-4ecf-94f3-b7bdff4d44dd) <img src="https://github.com/user-attachments/assets/76aa42c2-2c83-4c2b-825f-c23baebf4868" />  
![License](https://github.com/user-attachments/assets/ff71a38b-8813-4a79-8774-09a2f3893b48) ![Freeware](https://github.com/user-attachments/assets/1fea2bbf-b296-4152-badd-e1cdae115c43)  

</br>

# 3ds

3DS is one of the file formats used by the [Autodesk 3ds Max 3D modeling](https://en.wikipedia.org/wiki/Autodesk_3ds_Max), animation and rendering software.

It was the native file format of the old [Autodesk 3D Studio DOS](https://en.wikipedia.org/wiki/Autodesk_3ds_Max#Early_history_and_releases) (releases 1 to 4), which was popular until its successor (3D Studio MAX 1.0) replaced it in April 1996. Having been around since 1990 (when the first version of 3D Studio DOS was launched), it has grown to become a [de facto](https://en.wikipedia.org/wiki/De_facto) industry standard for transferring models between 3D programs, or for storing models for 3D resource catalogs (along with [OBJ](https://en.wikipedia.org/wiki/Wavefront_.obj_file), which is more frequently used as a model archiving file format).

</br>

<img src="https://github.com/user-attachments/assets/aee5a49a-e1ec-47b0-9454-9582f67f1118" />  

</br>
</br>

While the 3DS format aims to provide an import/export format, retaining only essential geometry, texture and lighting data, the related MAX format (now superseded by the PRJ format) also contains extra information specific to Autodesk 3ds Max, to allow a scene to be completely saved/loaded.

### Structure
3ds is a [binary file format](https://en.wikipedia.org/wiki/Binary_file).

The format is based in chunks, where each section of data is embedded in a block that contains a chunk identifier and the length of the data (to provide the location of the next main block), as well as the data itself. This allows parsers to skip chunks they don't recognize, and allows for extensions to the format.

The chunks form a hierarchical structure, similar to an xml [DOM tree](https://en.wikipedia.org/wiki/Document_Object_Model). The first two bytes of the chunk are its ID. From that value the parser can identify the chunk and decide whether it will parse it or skip it. The next four bytes contain a [little-endian](https://en.wikipedia.org/wiki/Endianness) integer that is the length of the chunk, including its data, the length of its sub-blocks and the 6-byte header. The next bytes are the chunk's data, followed by the sub-chunks, in a structure that may extend to several levels deep.

Below is a list of the most common IDs for chunks, represented in a hierarchical fashion depicting their dependencies:

```pascal
0x4D4D // Main Chunk
├─ 0x0002 // M3D Version
├─ 0x3D3D // 3D Editor Chunk
│  ├─ 0x4000 // Object Block
│  │  ├─ 0x4100 // Triangular Mesh
│  │  │  ├─ 0x4110 // Vertices List
│  │  │  ├─ 0x4120 // Faces Description
│  │  │  │  ├─ 0x4130 // Faces Material
│  │  │  │  └─ 0x4150 // Smoothing Group List
│  │  │  ├─ 0x4140 // Mapping Coordinates List
│  │  │  └─ 0x4160 // Local Coordinates System
│  │  ├─ 0x4600 // Light
│  │  │  └─ 0x4610 // Spotlight
│  │  └─ 0x4700 // Camera
│  └─ 0xAFFF // Material Block
│     ├─ 0xA000 // Material Name
│     ├─ 0xA010 // Ambient Color
│     ├─ 0xA020 // Diffuse Color
│     ├─ 0xA030 // Specular Color
│     ├─ 0xA200 // Texture Map 1
│     ├─ 0xA230 // Bump Map
│     └─ 0xA220 // Reflection Map
│        │  /* Sub Chunks For Each Map */
│        ├─ 0xA300 // Mapping Filename
│        └─ 0xA351 // Mapping Parameters
└─ 0xB000 // Keyframer Chunk
   ├─ 0xB002 // Mesh Information Block
   ├─ 0xB007 // Spot Light Information Block
   └─ 0xB008 // Frames (Start and End)
      ├─ 0xB010 // Object Name
      ├─ 0xB013 // Object Pivot Point
      ├─ 0xB020 // Position Track
      ├─ 0xB021 // Rotation Track
      ├─ 0xB022 // Scale Track
      └─ 0xB030 // Hierarchy Position
```

</br>

# obj
OBJ (or .OBJ) is a geometry definition file format first developed by [Wavefront Technologies](https://en.wikipedia.org/wiki/Wavefront_Technologies) for The [Advanced Visualizer](https://en.wikipedia.org/wiki/The_Advanced_Visualizer) animation package. It is an open file format and has been adopted by other [3D computer graphics](https://en.wikipedia.org/wiki/3D_computer_graphics) application vendors.

The OBJ file format is a simple data-format that represents 3D geometry alone – namely, the position of each [vertex](https://en.wikipedia.org/wiki/Vertex_(geometry)), the [UV position](https://en.wikipedia.org/wiki/UV_mapping) of each texture coordinate vertex, [vertex normals](https://en.wikipedia.org/wiki/Vertex_normal), and the faces that make each polygon defined as a list of vertices, and texture vertices. Vertices are stored in a counter-clockwise order by default, making explicit declaration of face normals unnecessary. OBJ coordinates have no units, but OBJ files can contain scale information in a human readable comment line.

### Structure
An OBJ file may contain vertex data, free-form curve/surface attributes, elements, free-form curve/surface body statements, connectivity between free-form surfaces, grouping and display/render attribute information. The most common elements are geometric vertices, texture coordinates, vertex normals and polygonal faces:

</br>

```pascal
# List of geometric vertices, with (x, y, z, [w]) coordinates, w is optional and defaults to 1.0.
v 0.123 0.234 0.345 1.0
v ...
...
# List of texture coordinates, in (u, [v, w]) coordinates, these will vary between 0 and 1. v, w are optional and default to 0.
vt 0.500 1 [0]
vt ...
...
# List of vertex normals in (x,y,z) form; normals might not be unit vectors.
vn 0.707 0.000 0.707
vn ...
...
# Parameter space vertices in (u, [v, w]) form; free form geometry statement (see below)
vp 0.310000 3.210000 2.100000
vp ...
...
# Polygonal face element (see below)
f 1 2 3
f 3/1 4/2 5/3
f 6/4/1 3/5/3 7/6/5
f 7//1 8//2 9//3
f ...
...
# Line element (see below)
l 5 8 1 2 4 9
```

</br>

# md2
The MD2 model file format was introduced by id Software when releasing Quake 2 in November 1997. It's a file format quite simple to use and understand. MD2 models' characteristics are these:

* Model's geometric data (triangles);
* Frame-by-frame animations;
* Structured data for drawing the model using GL_TRIANGLE_FAN and GL_TRIANGLE_STRIP primitives (called “OpenGL commands”).

Model's texture is in a separate file. One MD2 model can have only one texture at the same time.

MD2 model file's extension is “md2”. A MD2 file is a binary file divided in two part: the header dans the data. The header contains all information needed to use and manipulate the data.

Variable types used in this document have those sizes:

* ```char: 1 byte```
* ```short: 2 bytes```
* ```int: 4 bytes```
* ```float: 4 bytes```

They correspond to C type sizes on the x86 architecture. Ensure that type sizes correspond to these ones if you're compiling for another architecture.

Since the MD2 file format is a binary format, you'll have to deal with endianess. MD2 files are stored in little-endian (x86). If you're targetting a big-endian architecture (PowerPC, SPARC, ...), or simply want your program to be portable, you'll have to perform proper conversions for each word or double word read from the file.

### Header:
The header is a structure which comes at the beginning of the file:

</br>

```cpp
/* MD2 header */
struct md2_header_t
{
  int ident;                  /* magic number: "IDP2" */
  int version;                /* version: must be 8 */

  int skinwidth;              /* texture width */
  int skinheight;             /* texture height */

  int framesize;              /* size in bytes of a frame */

  int num_skins;              /* number of skins */
  int num_vertices;           /* number of vertices per frame */
  int num_st;                 /* number of texture coordinates */
  int num_tris;               /* number of triangles */
  int num_glcmds;             /* number of opengl commands */
  int num_frames;             /* number of frames */

  int offset_skins;           /* offset skin data */
  int offset_st;              /* offset texture coordinate data */
  int offset_tris;            /* offset triangle data */
  int offset_frames;          /* offset frame data */
  int offset_glcmds;          /* offset OpenGL command data */
  int offset_end;             /* offset end of file */
};
```

</br>

ident is the magic number of the file. It is used to identify the file type. ident must be equal to 844121161 or to the string “IDP2”. We can obtain this number with the expression (('2'<<24) + ('P'<<16) + ('D'<<8) + 'I').

# Export Frames
The frames can be exported in various formats. Exactly 360 images are generated for a full rotation to ensure uninterrupted animation.

Formats : [BMP](https://en.wikipedia.org/wiki/BMP_file_format), [JPG](https://en.wikipedia.org/wiki/JPEG), [GIF](https://en.wikipedia.org/wiki/GIF)


