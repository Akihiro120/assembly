#### Triangle Star Pyramid
> ![Triangle Pyramid](../images/triangleStars.png)
#
#### Steps for Complilation
>__Linux/Unix__

``` Bash
nasm -f elf64 main.asm
gcc -o main main.o -no-pie
./main
```
or
``` Bash
make
./main
```
