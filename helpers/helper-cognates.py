from lingpy import *

try:
    lex = LexStat('../bins/Dogon-227-20.tsv')
except:
    lex = LexStat('../data/Dogon-227-20.tsv')
    lex.get_scorer(runs=10000)
    lex.output('tsv', filename='../bins/Dogon-227-20')

lex.cluster(method='lexstat', threshold=0.6, cluster_method='infomap')
