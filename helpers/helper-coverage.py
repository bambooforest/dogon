from lingpy import *

wl = Wordlist('../data/Dogon-227-20-alignments.tsv')

etd = wl.get_etymdict(ref='lexstatid')
for k, v in sorted(etd.items(), key=lambda x: sum([1 for y in x[1] if y != 0]),
    reverse=False):
    concept = wl[[x for x in v if x != 0][0][0], 'concept']
    refs = sum([1 for x in v if x != 0])
    print('{0:30}\t{1}'.format(concept, refs))
