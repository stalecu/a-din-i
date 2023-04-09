# a-din-i
Convertor între scrierea cu î și scrierea cu â

De ce l-am făcut? Pentru că de multe ori trebuie să convertesc între scrierea cu î din i pe care-o folosesc și scrierea cu â din a. Prin urmare, am făcut un mic script care să-mi ușureze munca.

Dependințe:
- Perl, evident (minim 5.10, nu ne mai aflăm în 2005)
- List::Util
- Encode

Toate acestea se pot instala folosind `cpan`. Verifică procedura pentru sistemul tău de operare (mai ales la Strawberry Perl pe Windows, pe restul este Perl standard dat de la mama natură).

Se poate fie rula ca:
```
$ perl a-din-i.pl --in foo.txt --out bar.txt -i/-a
```
fie:
```
$ chmod u+x a-din-i.pl
$ ./a-din-i.pl --in foo.txt --out bar.txt -i/-a
```
(pe sisteme UNIX, nu știu cum e situația pe Windows, dar îmi imaginez că prima variantă este cross-platform).

```
Usage: a-din-i.pl --in FILE --out FILE -a/-i
```
unde `-a` sau `--i-din-a` reprezintă conversia de la â la î, iar `-i` sau `--i-din-i` reversul.