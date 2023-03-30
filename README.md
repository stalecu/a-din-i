# a-din-i
Convertor între scrierea cu î și scrierea cu â

De ce l-am făcut? Pentru că de multe ori trebuie să convertesc între scrierea cu î din i pe care-o folosesc și scrierea cu â din a. Prin urmare, am făcut un mic script care să-mi ușureze munca. Codul e quick and dirty, am pus exact 0 efort în a-l face mai elegant, a se folosi ca atare.

ATENȚIE: acest script modifică direct fișierul!
```
usage: convertor.py [-h] [-a] [-i] fisier

Convertor â <-> î

positional arguments:
  fisier         Fișierul care va fi convertit

options:
  -h, --help     show this help message and exit
  -a, --a-din-i  Convertește din â în î (default: False)
  -i, --i-din-a  Convertește din î în â (default: False)
```