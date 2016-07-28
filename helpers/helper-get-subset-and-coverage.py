from lingpy import *
from pylexibank.util import with_temp_dir
from pyconcepticon.api import Concepticon

concepticon = dict([(x['ID'], x) for x in Concepticon().conceptsets()])

concepts = csv2list('../concepticon/dogon-300.tsv', strip_lines=False)
active_concepts = []
inactive = []
for line in concepts[1:]:
    if line[1] and line[2]:
        if line[2] in concepticon:
            active_concepts += [line[1]]
    else:
        inactive += [line[1]]


with with_temp_dir() as tmpdir:
    wl = Wordlist('../data/final-wordlist-new-tone.tsv')
    wl.output('tsv', filename=tmpdir.joinpath('ds').as_posix(), subset=True, rows=dict(
        concept = 'in '+str(active_concepts)))
    
    wl2 = Wordlist(tmpdir.joinpath('ds.tsv').as_posix())
    ignore = []
    print('coverage of all data in dataset')
    for a, b in wl2.coverage().items():
        cov = b / wl2.height
        if cov < 0.8:
            ignore += [a]
        print(a, '\t', b, '\t', '{0:.2f}'.format(b / wl2.height))
    print(wl2.height, wl2.width)
    print('')
    for bad_cov in ignore:
        print(bad_cov)
    wl2.output('tsv', filename=tmpdir.joinpath('ds').as_posix(), subset=True, rows=dict(
        doculect = 'not in' +str(ignore)))

    wl3 = Wordlist(tmpdir.joinpath('ds.tsv').as_posix())
    wl3.output('tsv', filename='../data/Dogon-{0}-{1}'.format(wl3.height, wl3.width),
            prettify=False)

print('missing concepts not mapped in concepticon')
for concept in inactive:
    print(concept)

# exclude synonyms and put them in a variants field
wl = Wordlist(wl3)
variants = {}
excludes = []
for taxon in wl.cols:
    word_ids = wl.get_dict(taxon=taxon)
    words = wl.get_dict(taxon=taxon, entry='tokens')
    for concept in wl.concepts:
        if concept in word_ids:
            idxs, tokens = word_ids[concept], words[concept]
            variants[idxs[0]] = []
            for idx, word in zip(idxs[1:], tokens[1:]):
                variants[idxs[0]] += [' '.join(word)]
                excludes += [idx]
                variants[idx] = []
wl.add_entries('variants', variants, lambda x: ' // '.join(x))
wl.output('tsv', filename='../data/Dogon-{0}-{1}'.format(wl.height, wl.width),
        subset=True, rows=dict(ID = 'not in '+str(excludes)))
