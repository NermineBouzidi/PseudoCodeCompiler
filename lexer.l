%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

digit   [0-9]
alpha   [a-zA-Z]
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

{digit}+          { yylval.ival = atoi(yytext); return NOMBRE; }
{alpha}({alphanum})* { yylval.str = strdup(yytext); return IDENTIFIANT; }

[ \t\r\n]+        { /* ignore whitespace */ }
.                 { printf("Unknown character: %s\n", yytext); }

"//"[^'\n']* { 
    // Recognize the comment and ignore it in pseudo-code 
    fprintf(yyout, "// %s\n", yytext + 2);  // Write it as a C-style comment
}
%%

int yywrap() {
    return 1;
}
