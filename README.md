# Open Miku Parser

Implementation of parsers in GDScript of MMD file types.

The knowledges used in this project were extracted from severals sources:

* [PMX/VMD Scripting Tools - Github](https://github.com/Nuthouse01/PMX-VMD-Scripting-Tools)
* [JIS X 0208 (1990) to Unicode 漢字コード表 - 
日本語文字コード](http://charset.7jp.net/jis0208.html)
* [ VMD file format - MikuMikuDance Wiki](https://mikumikudance.fandom.com/wiki/VMD_file_format)

## VMD file format specification

Vocaloid Motion Data (VMD) file format specification

### Header

| Size                  | Type      | Description                                                                                                           |
---                     | ---       | ---
| 30 bytes              | string    | Header signature. It's "Vocaloid Motion Data file" on old MMD or "Vocaloid Motion Data 0002" in the newer versions    |
| 10 bytes / 20 bytes   | string    | Associated model name. It has 10 bytes if the header signature is from old MMD and 20 bytes if it's the new           |

### Bone Keyframes

| Size      | Type      | Description               |
---         | ---       | ---
| 4 bytes   | uint32    | Number of bone keyframes  |

By using the previously identified number of bone keyframes, a loop starts by reading the next section:

| Size      | Type      | Description                                                       |
---         | ---       | ---
| 15 bytes  | string    | Bone name                                                         |
| 4 bytes   | uint32    | Frame index                                                       |
| 4 bytes   | float     | x-coordinate position                                             |
| 4 bytes   | float     | y-coordinate position                                             |
| 4 bytes   | float     | z-coordinate position                                             |
| 4 bytes   | float     | x-coordinate quaternion rotation                                  |
| 4 bytes   | float     | y-coordinate quaternion rotation                                  |
| 4 bytes   | float     | z-coordinate quaternion rotation                                  |
| 4 bytes   | float     | w-coordinate quaternion rotation                                  |
| 1 byte    | int8      | x-coordinate of the point a of the x-axis interpolation curve     |
| 1 byte    | int8      | x-coordinate of the point a of the y-axis interpolation curve     |
| 1 byte    | int8      | phys1, used to check if physics is enabled or disabled            |
| 1 byte    | int8      | phys2, used to check if physics is enabled or disabled            |
| 1 byte    | int8      | y-coordinate of the point a of the x-axis interpolation curve     |
| 1 byte    | int8      | y-coordinate of the point a of the y-axis interpolation curve     |
| 1 byte    | int8      | y-coordinate of the point a of the z-axis interpolation curve     |
| 1 byte    | int8      | y-coordinate of the point a of the rotation interpolation curve   |
| 1 byte    | int8      | x-coordinate of the point b of the x-axis interpolation curve     |
| 1 byte    | int8      | x-coordinate of the point b of the y-axis interpolation curve     |
| 1 byte    | int8      | x-coordinate of the point b of the z-axis interpolation curve     |
| 1 byte    | int8      | x-coordinate of the point b of the rotation interpolation curve   |
| 1 byte    | int8      | y-coordinate of the point b of the x-axis interpolation curve     |
| 1 byte    | int8      | y-coordinate of the point b of the y-axis interpolation curve     |
| 1 byte    | int8      | y-coordinate of the point b of the z-axis interpolation curve     |
| 1 byte    | int8      | y-coordinate of the point b of the rotation interpolation curve   |
| 1 byte    |           | apparently a padding byte. *                                      |
| 1 byte    | int8      | x-coordinate of the point a of the z-axis interpolation curve     |
| 1 byte    | int8      | x-coordinate of the point a of the rotation interpolation curve   |
| 46 bytes  |           | apparently shifted copies of the previous bytes.*                 |

\* serves no purpose.

### Facial/Morph Keyframes

| Size      | Type      | Description                       |
---         | ---       | ---
| 4 bytes   | uint32    | Number of facial/morph keyframes  |

By using the previously identified number of facial/morph keyframes, a loop starts by reading the next section:

| Size      | Type      | Description                       |
---         | ---       | ---
| 15 bytes  | string    | name of the facial/morph          |
| 4 bytes   | uint32    | Frame index                       |
| 4 bytes   | float     | Value/Weight                      |

### Camera Keyframes

| Size      | Type      | Description                   |
---         | ---       | ---
| 4 bytes   | uint32    | Number of camera keyframes    |

By using the previously identified number of camera keyframes, a loop starts by reading the next section:

| Size      | Type      | Description                       |
---         | ---       | ---
| 4 bytes   | uint32    | Frame index                       |
| 4 bytes   | float     | Distance from target to camera    |
| 4 bytes   | float     | x-coordinate of target position   |
| 4 bytes   | float     | y-coordinate of target position   |
| 4 bytes   | float     | z-coordinate of target position   |
| 4 bytes   | float     | x-coordinate rotation in radians  |
| 4 bytes   | float     | y-coordinate rotation in radians  |
| 4 bytes   | float     | z-coordinate rotation in radians  |
| 1 byte    | int8      | x_ax                              |
| 1 byte    | int8      | x_bx                              |
| 1 byte    | int8      | x_ay                              |
| 1 byte    | int8      | x_by                              |
| 1 byte    | int8      | y_ax                              |
| 1 byte    | int8      | y_bx                              |
| 1 byte    | int8      | y_ay                              |
| 1 byte    | int8      | y_by                              |
| 1 byte    | int8      | z_ax                              |
| 1 byte    | int8      | z_bx                              |
| 1 byte    | int8      | z_ay                              |
| 1 byte    | int8      | z_by                              |
| 1 byte    | int8      | r_ax                              |
| 1 byte    | int8      | r_bx                              |
| 1 byte    | int8      | r_ay                              |
| 1 byte    | int8      | r_by                              |
| 1 byte    | int8      | dist_ax                           |
| 1 byte    | int8      | dist_bx                           |
| 1 byte    | int8      | dist_ay                           |
| 1 byte    | int8      | dist_by                           |
| 1 byte    | int8      | ang_ax                            |
| 1 byte    | int8      | ang_bx                            |
| 1 byte    | int8      | ang_ay                            |
| 1 byte    | int8      | ang_by                            |
| 4 bytes   | uint32    | Camera FOV angle                  |
| 1 byte    | bool      | ang_by                            |

### Light Keyframes

| Size      | Type      | Description               |
---         | ---       | ---
| 4 bytes   | uint32    | Number of light keyframes |

By using the previously identified number of light keyframes, a loop starts by reading the next section:

| Size      | Type      | Description                                                   |
---         | ---       | ---
| 4 bytes   | uint32    | Frame index                                                   |
| 4 bytes   | float     | red value, stored as a float [0.0-1.0) to represent 0-255     |
| 4 bytes   | float     | green value, stored as a float [0.0-1.0) to represent 0-255   |
| 4 bytes   | float     | blue value, stored as a float [0.0-1.0) to represent 0-255    |
| 4 bytes   | float     | x-position                                                    |
| 4 bytes   | float     | y-position                                                    |
| 4 bytes   | float     | z-position                                                    |

### Shadow Keyframes

| Size      | Type      | Description                   |
---         | ---       | ---
| 4 bytes   | uint32    | Number of shadow keyframes    |

By using the previously identified number of shadow keyframes, a loop starts by reading the next section:

| Size      | Type      | Description                                                                               |
---         | ---       | ---
| 4 bytes   | uint32    | Frame index                                                                               |
| 1 byte    | uint8     | Mode (0=off, 1=mode1, 2=mode2)                                                            |
| 4 bytes   | float     | Shadow range value, stored as 0.0 to 0.1 and also range-inverted: [0,9999] -> [0.1, 0.0]  |

### Inverse Kinematic/Disp Keyframes

| Size      | Type      | Description                                   |
---         | ---       | ---
| 4 bytes   | uint32    | Number of inverse kinematic/disp keyframes    |

By using the previously identified number of inverse kinematic/disp keyframes, a loop starts by reading the next section:

| Size      | Type      | Description                       |
---         | ---       | ---
| 4 bytes   | uint32    | Frame index                       |
| 1 byte    | boolean   | display (on=1 / off=0)            |
| 4 bytes   | uint32    | Number of inverse kinematic bones |

By using the previously identified number of inverse kinematic bones, a loop starts by reading the next section:

| Size      | Type      | Description                       |
---         | ---       | ---
| 20 bytes  | string    | Bone name                         |
| 1 byte    | boolean   | Inverse Kinematics (on=1 / off=0) |
