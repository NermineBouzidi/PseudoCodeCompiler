%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

digit    [0-9]
alpha    [a-zA-Z]
alphanum [a-zA-Z0-9]

%%

"début"           { return DEBUT; }
"fin"             { return FIN; }
"entier"          { return ENTIER; }
"afficher"        { return AFFICHER; }
"←"               { return ASSIGN; }
"si"              { return SI; }
"sinon"           { return SINON; }
"alors"           { return ALORS; }
"tantque"         { return TANTQUE; }
"faire"           { return FAIRE; }
"pour"            { return POUR; }
"de"              { return DE; }
"à"               { return A; }
"selon"           { return SELON; }
"cas"             { return CAS; }
"default"         { return DEFAUT; }
"break"           { return BREAK; }

"+"               { return PLUS; }
"-"               { return MOINS; }
"*"               { return FOIS; }
"/"               { return DIVISE; }
"=="              { return EGAL; }
"!="              { return DIFF; }
"<"               { return INFERIEUR; }
">"               { return SUPERIEUR; }
"<="              { return INFEGAL; }
">="              { return SUPEGAL; }
"et"              { return ET; }
"ou"              { return OU; }
"non"             { return NON; }
"("               { return PARENGAUCHE; }
")"               { return PARENDROITE; }

\"[^"]*\"         { 
    yylval.str = strdup(yytext + 1);    // Enlever le premier "
    yylval.str[strlen(yylval.str) - 1] = '\0';  // Enlever le dernier "
    return STRING; 
}

{digit}+          { yylval.ival = atoi(yytext); return NOMBRE; }
{alpha}({alphanum})* { yylval.str = strdup(yytext); return IDENTIFIANT; }

[ \t\r\n]+        { /* ignorer les espaces */ }
.                 { printf("Caractère inconnu : %s\n", yytext); }

"//"[^'\n']*      { fprintf(yyout, "// %s\n", yytext + 2); }

%%

int yywrap() {
    return 1;
}