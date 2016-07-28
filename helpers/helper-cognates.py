from lingpy import *

try:
    lex = LexStat('../bins/Dogon-227-20.tsv')
except:
    lex = LexStat('../data/Dogon-227-20.tsv')
    lex.get_scorer(runs=5000, restricted_chars='_')
    lex.output('tsv', filename='../bins/Dogon-227-20')

lex.cluster(method='lexstat', threshold=0.5, cluster_method='infomap',
        restricted_chars='_')
lex.output('tsv', filename='../data/Dogon-227-20-cognates', ignore='all',
        prettify=False)

alm = Alignments(lex, ref='lexstatid')
alm.align(scoredict=lex.cscorer, method='library', restricted_chars='_')
alm.output('tsv', filename='../data/Dogon-227-20-alignments', ignore='all',
        prettify=False, subset=True, cols=[c for c in sorted(alm.header,
            key=lambda x: alm.header[x]) if c != 'concept_list'])


