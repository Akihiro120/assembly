### Append to Front

``` Assembly
1. mov rax, text_len
2. inc rax
3. mov byte [text + rax], 0x0A

```

__Explanation__:
We move text length into the RAX register,
We then increment the length by one 
Next we move the new byte into the new position in the text variable

| Instruction                 | text_len | text                | Memory                                                          |
| --------------------------- | -------- | ------------------- | --------------------------------------------------------------- |
| text                        |          | "Hello World"       | 0x48 0x65 0x6C 0x6C 0x6F 0x20 0x57 0x6F 0x72 0x6C 0x64          |
| mov rax, text_len           | 16 Bytes |                     |                                                                 |
| inc rax                     | 17 Bytes |                     |                                                                 |
| mov byte [text + rax], 0x0A |          | "Hello World", 0x0A | 0x48 0x65 0x6C 0x6C 0x6F 0x20 0x57 0x6F 0x72 0x6C 0x64 ==0x0A== |
### Append to Back

``` Assembly
mov byte [text], 0x0A
mov rax [text]
shl rax, 8
mov [text], rax
mov byte [text], 55
```

__Explanation__:
We store 0x0A into the text value
We store the value of text in the RAX register
We add 8 bits of 0 to the left of the register
We move the RAX into the value of text
We move the byte value character 7 into the text value

| Instruction           | registers / variables | size              | memory                               | value | representation |
| --------------------- | --------------------- | ----------------- | ------------------------------------ | ----- | -------------- |
| text                  | text                  | 32 Bytes Reserved | 0x00 0x00 0x00 0x00                  | 0     |                |
| mov byte [text], 0x0A | text                  | 32 Bytes          | ==0x0A== 0x00 0x00 0x00              | \n    |                |
| mov rax, [text]       | RAX                   | 32 Bytes          | ==0x0A== 0x00 0x00 0x00              | \n    |                |
| shl rax, 8            | RAX                   | 36 Bytes          | ==0x00== __0x0A__ 0x00 0x00 0x00     | \n    |                |
| mov [text], rax       | text                  | 36 Bytes          | __0x00__ __0x0A__ 0x00 0x00 0x00<br> | \n    |                |
| mov byte [text], 55   | text                  | 36 Bytes          | ==0x55== __0x0A 0x00__ 0x00 0x00     | 7 \n  |                |

