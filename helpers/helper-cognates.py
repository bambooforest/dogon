from lingpy import *

try:
    lex = LexStat('../bins/Dogon-227-20.tsv')
except:
    lex = LexStat('../data/Dogon-227-20.tsv')
    lex.get_scorer(runs=10000)
    lex.output('tsv', filename='../bins/Dogon-227-20')

lex.cluster(method='lexstat', threshold=0.55, cluster_method='infomap')
lex.output('tsv', filename='../data/Dogon-227-20-cognates', ignore='all',
        prettify=False)

# plot a nj tree
from lingpy.convert.plot import plot_tree
lex.calculate('tree', ref='lexstatid', tree_calc='neighbor')
plot_tree(lex.tree, fileformat='pdf', filename='../plots/dogon-tree', degree=355)

alm = Alignments(lex, ref='lexstatid')
alm.align(scoredict=lex.cscorer, method='library')
alm.output('tsv', filename='../data/Dogon-227-20-alignments', ignore='all',
        prettify=False, subset=True, cols=[c for c in sorted(alm.header,
            key=lambda x: alm.header[x]) if c != 'concept_list'])


