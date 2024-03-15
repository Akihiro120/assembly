
#### Reserving Bytes
``` Assembly
section .bss 100
	number resb 100
	number_pos resb 8
```

| instruction       | type | memory     | value |
| ----------------- | ---- | ---------- | ----- |
| number resb 100   | BYTE | 0x00 * 100 | NULL  |
| number_pos resb 8 | BYTE | 0x00 * 8   | NULL  |
We reserve ==100 Bytes== into __number__, and we reserve ==8 Bytes== in __number_pos__
The instruction __resb__ reserves a specific number of bytes into memory


