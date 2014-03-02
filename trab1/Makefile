

exemplo: lex.yy.c
	gcc -o lexico lex.yy.c
	./lexico Teste.txt

lex.yy.c: Lexico.l
	flex Lexico.l

clean:
	rm -f lexico *.o lex.yy.c

test: lexico 
