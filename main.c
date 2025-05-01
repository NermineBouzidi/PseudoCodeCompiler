#include <stdio.h>
#include <stdlib.h>

extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("fopen input");
        return 1;
    }

    yyout = fopen("output.c", "w");
    if (!yyout) {
        perror("fopen output");
        fclose(yyin);
        return 1;
    }

    yyparse();

    fclose(yyin);
    fclose(yyout);
    return 0;
}