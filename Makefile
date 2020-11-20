all: py

py.tab.c py.tab.h:	py.y
	bison -Wconflicts-sr -t -v -d py.y 

lex.yy.c: py.l py.tab.h
	flex py.l

py: lex.yy.c py.tab.c py.tab.h
	gcc -o py py.tab.c lex.yy.c 

clean:
	rm py py.tab.c lex.yy.c py.tab.h py.output

run:
	./py file.py
