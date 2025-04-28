# Simple Compiler for Pseudo Code to C Translation 



## Description

This project is a simple compiler written in C that reads pseudo code written in a custom language and translates it into equivalent C code.

The compiler takes a pseudo code file as input and generates a C source code file with the appropriate C syntax.


## Features

- **Input**: Pseudo code in a custom language.
- **Output**: C source code that can be compiled and run.


## How to Use

### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/yourproject.git
cd yourproject 
```
### Step 2: Compile the Compiler

```bash
bison -d parser.y   # Generates the parser code (parser.tab.c and parser.tab.h)
flex lexer.l         # Generates the lexical analyzer (lex.yy.c)
gcc -o compiler parser.tab.c lex.yy.c -lfl  # Compile all files together
```
### Step 3: Run the Compiler
```bash
./compiler input.txt
```
## Example

### Input (input.txt):
```bash
début
entier x
x ← 6
afficher x
// this is a comment
fin
```

### Output (outpu.txt):
```bash
#include <stdio.h>

int main() {
    int x;
    x = 6;
    printf("%d\n", x);
    // this is a comment
    return 0;
}

```


