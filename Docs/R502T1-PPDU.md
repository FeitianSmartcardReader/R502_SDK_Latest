# R502 CL User Manual - Command Reference

## Document Information

| Item | Details |
|------|---------|
| Product | R502 CL Card Reader |
| Model | R502T1 |
| Version | v1.5 (Sep 26, 2025) |
| Base | FEITIAN Technologies Co., Ltd |


## Conventions

This document is for internal use only. If it needs to be distributed externally, it must be authorized by the document issuer after desensitization.

For parts not explicitly shown in the document, such as sensitive information like secret keys, it may be necessary to communicate with the project leader separately and have them sent in other forms.

The parts marked with "Note" in the document generally require special attention. In most cases, the notes should be taken as the standard. If there is any ambiguity, please communicate with the product manager.

If a specific value is not given for a default value mentioned in the document, it defaults to '00'.

In the document, hexadecimal values are represented by double or single quotes, for example, the CPLC tag is represented as "9F7F", and 0x00 is represented as '00'.

> **Note:** **The commands we defined as PPDUs follow the PC/SC standard, and these commands require a card to be present before sending.**


## Private Command State

After the card reader receives the command with CLA=0xFF and INS=0x9A in the normal working state, it enters the private command state. In this state, it can process private commands normally. 

In addition to the general command set, this card reader also supports CL-related private commands. 

> **Note:** **The commands we defined as PPDUs follow the PC/SC standard, and these commands require a card to be present before sending.**



## Device Configuration Commands

| Function | APDU Template | Parameters |
|----------|---------------|------------|
| Get Vendor Name | FF9A 0101 00 | Returns UTF-16LE string |
| Get Product Name | FF9A 0103 00 | Returns UTF-16LE string |
| Get Serial Number | FF9A 0105 00 | Returns UTF-16LE string |
| Get VID | FF9A 0102 02 | Returns 2-byte VID |
| Get PID | FF9A 0104 02 | Returns 2-byte PID |
| Get Firmware Version | FF9A 0106 02 | Returns major.minor version |
| Get Build Time | FF9A 0108 0A | Returns YY MM DD HH MM SS + SVN |
| Get Random Number | FF9A 0300 10 | Returns 16-byte random number from reader|

```
// Send command to get random number
SEND: FF 9A 03 00 10
RECV: A1 B2 C3 D4 E5 F6 07 08 09 0A 0B 0C 0D 0E 0F 10 90 00
      └─────────────── 16-byte random ──────────────┘ └status┘

// Extract random number for encryption
random = A1B2C3D4E5F607080A0B0C0D0E0F10

// Get vendor name
SEND: FF 9A 01 01 00
RECV: 4D 00 79 00 43 00 6F 00 6D 00 70 00 61 00 6E 00 79 00 90 00
      └──────────────────── "MyCompany" in UTF-16LE ────────────────┘

// Get product name  
SEND: FF 9A 01 03 00
RECV: 52 00 35 00 30 00 32 00 43 00 4C 00 90 00
      └─────────── "R502CL" in UTF-16LE ──────────┘

// Get serial number
SEND: FF 9A 01 05 00
RECV: 31 00 32 00 33 00 34 00 35 00 36 00 37 00 38 00 90 00
      └──────────────── "12345678" in UTF-16LE ─────────────────┘

// Get VID (Vendor ID)
SEND: FF 9A 01 02 02
RECV: 08 5D 90 00  // VID = 0x085D
      └──VID──┘

// Get PID (Product ID)
SEND: FF 9A 01 04 02
RECV: 08 6F 90 00  // PID = 0x086F
      └──PID──┘

// Get firmware version
SEND: FF 9A 01 06 02
RECV: 01 04 90 00  // Version 1.4
      └─┘ └─┘
    major minor

// Get build timestamp
SEND: FF 9A 01 08 0A
RECV: 19 09 1A 0E 1E 2D 00 01 02 03 90 00
      └─ year (25=2025)
         └─ month (09=September)
            └─ day (26)
               └─ hour (14)
                  └─ minute (30)
                     └─ second (45)
                        └──── SVN version ────┘
```


## Reader UID(User ID) Management Commands 
> **Note:** **This is not the card UID; it is the reader UID used to identify a specific reader. The UID is generated from a seed code, intended for customers who want to link their software with a specific or ODM reader.**

| Function | APDU Template | Parameters |
|----------|---------------|------------|
| Generate UID | FF9A 02FF {len} {seed} | seed: generation seed, len: [0,48] |
| Get UID | FF9A 01FF 08 | Returns 8-byte UID |
| Erase UID | FF9A 02FE {len} {seed} | seed: original seed or default seed |

```
// Generate UID with seed
seed = "MyDevice123"
SEND: FF 9A 02 FF 0B 4D 79 44 65 76 69 63 65 31 32 33
RECV: 90 00  // UID generated successfully

// Get UID UID
SEND: FF 9A 01 FF 08
RECV: 12 34 56 78 9A BC DE F0 90 00
      └──────── 8-byte UID ────────┘
      
// Erase with original seed
SEND: FF 9A 02 FE 0B 4D 79 44 65 76 69 63 65 31 32 33
RECV: 90 00  // UID erased (now FFFFFFFFFFFFFFFF)

```

## LED and Buzzer Control Commands

| Function | APDU Template | Parameters |
|----------|---------------|------------|
| LED Control | FF70 096E 03 61{id}{mode} | id: 01=Red, 04=Blue; mode: 00=Off, 01=On |
| Buzzer Config | FF70 096E 02 60{mode} | mode: 00=Silent, 01=Beep on card |
| Buzzer Test | FF70 096E 04 6002{interval} | interval: Duration (ms), hex format |
```
// Turn on red LED
SEND: FF 70 09 6E 03 61 01 01
RECV: 90 00  // Red LED on

// Turn off red LED
SEND: FF 70 09 6E 03 61 01 00
RECV: 90 00  // Red LED off

// Turn on blue LED
SEND: FF 70 09 6E 03 61 04 01
RECV: 90 00  // Blue LED on

// Enable beep on card detection
SEND: FF 70 09 6E 02 60 01
RECV: 90 00  // Buzzer enabled

// Continuous beep for 500ms (0x01F4)
SEND: FF 70 09 6E 04 60 02 01 F4
RECV: 90 00  // Buzzer sounds for 500ms

```
## Contactless Card Polling

| Function | APDU Template | Parameters |
|----------|---------------|------------|
| Get Poll Config | FFCA 1000 00 | Returns 8-bit config |
| Set Poll Config | FFCA 1000 01 {config} | Bit0=TypeA, Bit1=TypeB, Bit3=ISO15693, Bit4=VAS |

```
// Get current polling config
SEND: FF CA 10 00 00
RECV: 0B 90 00  // TypeA + TypeB + ISO15693 enabled
      └─ Bit0=TypeA, Bit1=TypeB, Bit3=ISO15693

// Set polling config - Enable TypeA + TypeB + ISO15693
SEND: FF CA 10 00 01 0B
RECV: 90 00  // Config set: Bit0=1, Bit1=1, Bit3=1

// Enable only TypeA cards
SEND: FF CA 10 00 01 01
RECV: 90 00  // Only TypeA polling enabled

// Enable TypeA + VAS (Apple Value Added Services)
SEND: FF CA 10 00 01 11
RECV: 90 00  // TypeA + VAS enabled (Bit0=1, Bit4=1)

// Enable all supported types
SEND: FF CA 10 00 01 1B
RECV: 90 00  // All types enabled (TypeA + TypeB + ISO15693 + VAS)
```

## Mifare Commands

| Function | APDU Template | Parameters |
|----------|---------------|------------|
| Load Key | FF82 00{idx} 06 {key} | idx: 00/01, key: 6-byte key |
| Authenticate | FF86 0000 05 01{blk_h}{blk_l}{keytype}00 | keytype: 60=KeyA, 61=KeyB |
| Read Block | FFB0 {blk_h}{blk_l} 10 | Returns 16-byte block data |
| Write Block | FFD6 {blk_h}{blk_l} 10 {data} | data: 16-byte block data |
| Increment | FFD4 00{blk} 04 {value} | value: 4-byte little-endian |
| Decrement | FFD8 00{blk} 04 {value} | value: 4-byte little-endian |

```
// Load key into slot 0
key = FF FF FF FF FF FF  // Default key
SEND: FF 82 00 00 06 FF FF FF FF FF FF
RECV: 90 00  // Key loaded

// Authenticate block 4 with KeyA
SEND: FF 86 00 00 05 01 00 04 60 00
RECV: 90 00  // Authentication successful

// Read block 4
SEND: FF B0 00 04 10
RECV: 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F 10 90 00
      └──────────────── 16-byte block data ────────────────┘
      
// Write data to block 5
data = 11 22 33 44 55 66 77 88 99 AA BB CC DD EE FF 00
SEND: FF D6 00 05 10 11 22 33 44 55 66 77 88 99 AA BB CC DD EE FF 00
RECV: 90 00  // Write successful

// Increment value block by 100 (0x64)
SEND: FF D4 00 06 04 64 00 00 00
RECV: 90 00  // Increment successful

// Decrement value block by 50 (0x32)
SEND: FF D8 00 06 04 32 00 00 00
RECV: 90 00  // Decrement successful

```

## Topaz Commands

| Function | APDU Template | Parameters |
|----------|---------------|------------|
| Read Block | FFB0 00{blk} 08 | Returns 8-byte block data |
| Write Block | FFD6 00{blk} 08 {data} | data: 8-byte block data |

```
// Read block 0 (8 bytes)
SEND: FF B0 00 00 08
RECV: 01 02 03 04 05 06 07 08 90 00
      └──────── 8-byte block data ────────┘

// Read block 5
SEND: FF B0 00 05 08
RECV: AA BB CC DD EE FF 00 11 90 00
      └──────── 8-byte block data ────────┘

// Write block 1
SEND: FF D6 00 01 08 11 22 33 44 55 66 77 88
RECV: 90 00  // Write successful

// Write block 10 with new data
SEND: FF D6 00 0A 08 A1 B2 C3 D4 E5 F6 07 08
RECV: 90 00  // Write successful
```

## ISO15693 Commands

| Function | APDU Template | Parameters |
|----------|---------------|------------|
| Read Block | FFB0 {p1}{blk} 00 | p1: 00=data only, 80=with security |
| Write Block | FFD6 00{blk} {len} {data} | Variable block size |

```
// Read block 0 with security info
SEND: FF B0 80 00 00
RECV: 01 02 03 04 01 90 00  // 4-byte data + 1-byte security
      └─── data ──┘ └sec┘

// Write block 1
SEND: FF D6 00 01 04 AA BB CC DD
RECV: 90 00  // Write successful
```

## DESFire Commands

| Function | APDU Template | Parameters |
|----------|---------------|------------|
| Direct Mode | FFDE 0000 {len} {cmd} | cmd: Native DESFire command |

```
// Get version info
SEND: FF DE 00 00 01 60
RECV: AF 04 01 01 00 02 18 05 90 00  // Version response
      └─ status
         └──────── version data ────────┘

// Select application
SEND: FF DE 00 00 04 5A 12 34 56
RECV: 00 90 00  // Application selected
      └─ status (00 = success)
```

## Card Information Commands

| Function | APDU Template | Parameters |
|----------|---------------|------------|
| Get Card UID/CSN | FFCA {p1}00 00 | p1: 00=UID, 01=Historical, 11=ATS |
| Get ATS | FFCA 1100 00 | ISO14443-4 TypeA ATS |
| Get SAK | FFCA 0200 01 | Select Acknowledge |
| Get ATQA | FFCA 0300 02 | Answer to Request TypeA |

```
// Get card UID
SEND: FF CA 00 00 00
RECV: 04 A1 B2 C3 90 00  // 4-byte TypeA UID
      └─ length
         └──── UID ────┘

// Get ATS (for ISO14443-4 cards)
SEND: FF CA 11 00 00
RECV: 05 78 80 02 06 90 00  // ATS data
      └─ ATS length
         └──── ATS ─────┘

// Get SAK (Select Acknowledge)
SEND: FF CA 02 00 01
RECV: 08 90 00  // SAK = 0x08 (Mifare Classic 1K)
      └─ SAK value

// Get ATQA (Answer to Request TypeA)
SEND: FF CA 03 00 02
RECV: 00 04 90 00  // ATQA = 0x0004
      └─ATQA─┘
```

## Common Status Codes

| SW1SW2 | Meaning |
|--------|---------|
| 9000 | Success |
| 6300 | Command not supported |
| 6400 | Card no response |
| 6700 | Wrong length |
| 6900 | Command not allowed |
| 6A00 | Wrong parameters |
| 6B00 | Wrong P1/P2 |
| 6C00 | Wrong Le |
| 6D00 | Wrong CLA/INS |
| 6E00 | Class not supported |

## Notes

- All commands require authentication except GET commands and card operations
- Hexadecimal values use single quotes (e.g., 'FF')
- Multi-byte values are big-endian unless specified
- Reader UID operations require proper seed matching
- Peripheral changes take effect immediately
- USB descriptor changes require device reconnection
