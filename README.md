A small example of a Pyhton parser written with flex / bison.

Compile using the `Makefile` 

    $ make

Write some Python in file.py and run

    $ make run

or to compile manually on Linux, follow these steps:

    $ bison -d py.y
    $ flex py.l
    $ gcc py.tab.c lex.yy.c -o py -lm
    $ ./py file.py
