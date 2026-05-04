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

While the 3DS format aims to provide an import/export format, retaining only essential geometry, texture and lighting data, the related MAX format (now superseded by the PRJ format) also contains extra information specific to Autodesk 3ds Max, to allow a scene to be completely saved/loaded.

### Structure
3ds is a [binary file format](https://en.wikipedia.org/wiki/Binary_file).

The format is based in chunks, where each section of data is embedded in a block that contains a chunk identifier and the length of the data (to provide the location of the next main block), as well as the data itself. This allows parsers to skip chunks they don't recognize, and allows for extensions to the format.

The chunks form a hierarchical structure, similar to an xml [DOM tree](https://en.wikipedia.org/wiki/Document_Object_Model). The first two bytes of the chunk are its ID. From that value the parser can identify the chunk and decide whether it will parse it or skip it. The next four bytes contain a [little-endian](https://en.wikipedia.org/wiki/Endianness) integer that is the length of the chunk, including its data, the length of its sub-blocks and the 6-byte header. The next bytes are the chunk's data, followed by the sub-chunks, in a structure that may extend to several levels deep.

Below is a list of the most common IDs for chunks, represented in a hierarchical fashion depicting their dependencies:









