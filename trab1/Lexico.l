%{
#define INT	100
#define STRING	200
#define VAR	300
#define OPERAC	400
#define ERROR	999999

int done = 0;
%}

%%                            
\"([^\n"\\]|\\["\\])*\" { return STRING; }

[0-9]+ {return INT;}

[a-zA-Z]+ {return VAR;}

[(|)|>|<|>=|<=|=|<|>|+|-|*|/]	{return OPERAC;}

([ \t\n]*)	{ }

.           { return ERROR; }

%%

yywrap() {
	done = 1;
}

int main() {
	while (!done) {
		printf("%d\n", yylex());
		printf("%s\n", yytext);
	}
	return 0;
}

