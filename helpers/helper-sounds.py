from lingpy import *
from collections import defaultdict

wl = Wordlist('../data/Dogon-227-20.tsv')
errors = defaultdict(int)
for k in wl:

    for s, t in zip(tokens2class(wl[k, 'tokens'], 'dolgo'), wl[k, 'tokens']):
        if s == '0':
            errors[t] += 1

for error, number in sorted(errors.items(), key=lambda x: x[1]):
    print(error, '\t', number)


