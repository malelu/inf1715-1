

exemplo: lex.yy.c
	gcc -o lexico lex.yy.c

lex.yy.c: Lexico.l
	flex Lexico.l

clean:
	rm -f lexico *.o lex.yy.c

test: lexico
	@echo "Teste sem erros:"
	./lexico < OK.txt
	@echo "Teste com erros:"
	./exemplo < ERRO.txt
