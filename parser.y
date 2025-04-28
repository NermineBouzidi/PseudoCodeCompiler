%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyout;
void yyerror(const char *s);
int yylex(void);
%}

%union {
    int ival;
    char* str;
}

%token DEBUT FIN ENTIER AFFICHER ASSIGN
%token SI SINON ALORS TANTQUE FAIRE POUR DE A SELON CAS DEFAUT BREAK
%token <ival> NOMBRE
%token <str> IDENTIFIANT

%%

programme:
    DEBUT { fprintf(yyout, "#include <stdio.h>\n\nint main() {\n"); }
    instructions
    FIN { fprintf(yyout, "return 0;\n}\n"); }
;

instructions:
    /* empty */
    |
    instructions instruction
;

instruction:
    ENTIER IDENTIFIANT {
        fprintf(yyout, "int %s;\n", $2);
    }
    |
    IDENTIFIANT ASSIGN NOMBRE {
        fprintf(yyout, "%s = %d;\n", $1, $3);
    }
    |
    AFFICHER IDENTIFIANT {
        fprintf(yyout, "printf(\"%%d\\n\", %s);\n", $2);
    }
    |
    SI condition ALORS instructions option_sinon FIN {
        fprintf(yyout, "}\n");
    }
    |
    TANTQUE condition FAIRE instructions FIN {
        fprintf(yyout, "}\n");
    }
    |
    POUR IDENTIFIANT DE NOMBRE A NOMBRE FAIRE instructions FIN {
        fprintf(yyout, "for (int %s = %d; %s <= %d; %s++) {\n", $2, $4, $2, $6, $2);
        fprintf(yyout, "}\n");
    }
    |
    SELON IDENTIFIANT instructions FIN {
        // Very basic switch template
        fprintf(yyout, "switch(%s) {\n", $2);
        fprintf(yyout, "}\n");
    }
;

condition:
    IDENTIFIANT {
        fprintf(yyout, "if (%s) {\n", $1);
    }
;

option_sinon:
    /* empty */
    |
    SINON instructions {
        fprintf(yyout, "} else {\n");
    }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erreur: %s\n", s);
}
