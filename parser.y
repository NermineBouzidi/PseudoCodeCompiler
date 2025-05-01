%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyout;
void yyerror(const char *s);
int yylex(void);

static char* combine(const char* op, char* left, char* right);
static char* unary(const char* op, char* expr);
static char* numberToString(int num);
%}

%union {
    int ival;
    char* str;
}

%token DEBUT FIN ENTIER AFFICHER ASSIGN
%token SI SINON ALORS TANTQUE FAIRE POUR DE A SELON CAS DEFAUT BREAK
%token PLUS MOINS FOIS DIVISE
%token EGAL DIFF INFERIEUR SUPERIEUR INFEGAL SUPEGAL
%token ET OU NON
%token PARENGAUCHE PARENDROITE
%token <ival> NOMBRE
%token <str> IDENTIFIANT STRING

%left OU
%left ET
%left EGAL DIFF
%left INFERIEUR SUPERIEUR INFEGAL SUPEGAL
%left PLUS MOINS
%left FOIS DIVISE
%right NON
%right UMOINS

%type <str> expression

%%

programme:
    DEBUT { fprintf(yyout, "#include <stdio.h>\n\nint main() {\n"); }
    instructions
    FIN { fprintf(yyout, "return 0;\n}\n"); }
;

instructions:
    /* empty */
    | instructions instruction
;

instruction:
    ENTIER IDENTIFIANT {
        fprintf(yyout, "int %s;\n", $2);
        free($2);
    }
    | IDENTIFIANT ASSIGN expression {
        fprintf(yyout, "%s = %s;\n", $1, $3);
        free($1);
        free($3);
    }
    | AFFICHER STRING {
        fprintf(yyout, "printf(\"%s\\n\");\n", $2);  // Chaîne directe
        free($2);
    }
    | AFFICHER expression {
        fprintf(yyout, "printf(\"%%d\\n\", (int)(%s));\n", $2);  // Expression numérique
        free($2);
    }
    | SI expression ALORS { fprintf(yyout, "if (%s) {\n", $2); free($2); } 
      instructions 
      option_sinon 
      FIN { fprintf(yyout, "}\n"); }
    | TANTQUE expression FAIRE { fprintf(yyout, "while (%s) {\n", $2); free($2); } 
      instructions 
      FIN { fprintf(yyout, "}\n"); }
    | POUR IDENTIFIANT DE NOMBRE A NOMBRE FAIRE {
        fprintf(yyout, "for (int %s = %d; %s <= %d; %s++) {\n", $2, $4, $2, $6, $2);
        free($2);
      }
      instructions 
      FIN { fprintf(yyout, "}\n"); }
;

option_sinon:
    /* empty */
    | SINON { fprintf(yyout, "} else {\n"); } instructions
;

expression:
    expression OU expression { $$ = combine("||", $1, $3); }
    | expression ET expression { $$ = combine("&&", $1, $3); }
    | expression EGAL expression { $$ = combine("==", $1, $3); }
    | expression DIFF expression { $$ = combine("!=", $1, $3); }
    | expression INFERIEUR expression { $$ = combine("<", $1, $3); }
    | expression SUPERIEUR expression { $$ = combine(">", $1, $3); }
    | expression INFEGAL expression { $$ = combine("<=", $1, $3); }
    | expression SUPEGAL expression { $$ = combine(">=", $1, $3); }
    | expression PLUS expression { $$ = combine("+", $1, $3); }
    | expression MOINS expression { $$ = combine("-", $1, $3); }
    | expression FOIS expression { $$ = combine("*", $1, $3); }
    | expression DIVISE expression { $$ = combine("/", $1, $3); }
    | NON expression { $$ = unary("!", $2); }
    | MOINS expression %prec UMOINS { $$ = unary("-", $2); }
    | PARENGAUCHE expression PARENDROITE { $$ = $2; }
    | IDENTIFIANT { $$ = strdup($1); free($1); }
    | NOMBRE { $$ = numberToString($1); }
;

%%

char* combine(const char* op, char* left, char* right) {
    char* result = malloc(strlen(left) + strlen(right) + strlen(op) + 4);
    sprintf(result, "(%s %s %s)", left, op, right);
    free(left);
    free(right);
    return result;
}

char* unary(const char* op, char* expr) {
    char* result = malloc(strlen(op) + strlen(expr) + 3);
    sprintf(result, "(%s%s)", op, expr);
    free(expr);
    return result;
}

char* numberToString(int num) {
    char* buffer = malloc(32);
    sprintf(buffer, "%d", num);
    return buffer;
}

void yyerror(const char *s) {
    fprintf(stderr, "Erreur: %s\n", s);
}