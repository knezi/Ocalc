#!/bin/env python3
import sys
if len(sys.argv)==1:
    print('Specify the name of the file')

else:
    name=sys.argv[1]

    line=0
    l=input()
    while(l):
        try:
            if l[0]=='+':
                line+=10
            elif l[0]=='-':
                line-=10
            else:
                line=int(l)
            with open(name,'r') as r:
                for x in range(line-2):
                    r.readline()
                print(r.readline(), end='')
                print(r.readline(), end='')
                print(r.readline(), end='')
        except:
            pass
        l=input()
