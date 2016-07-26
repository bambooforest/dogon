from lingpy import *
from lingpy.convert.plot import plot_tree
from lingpy.convert.html import colorRange

groups = {
    "Bangime" : "?",
    "Bankan_Tey" : "East-5",
    "Ben_Tey" : "East-5",
    "Bunoge" : "West-6",
    "Dogul_Dom" : "West-5",
    "Donno_So" : "East-7",
    "Gourou" : "?",
    "Jamsay_Douentza" : "East-2",
    "Mombo" : "West-6",
    "Najamba" : "West-3",
    "Nanga" : "East-5",
    "Penange" : "West-6",
    "Perge_Tegu" : "?",
    "Tebul_Ure" : "?",
    "Tiranige" : "West-4",
    "Togo_Kan" : "East-6",
    "Tommo_So" : "East-7",
    "Toro_Tegu" : "East-1",
    "Yanda_Dom" : "West-1",
    "Yorno_So" : "?",
        }

vals = sorted(set(groups.values()))
colors = dict(zip(vals, colorRange(len(vals))))
#['red', 'green', 'blue', 'black', 'gray', 'yellow',
#    '0.7', 'cyan', '0.2', '0.1', '0.5', '#ff00ff']))
colord = {}
labels = {}
for g in groups:
    colord[g] = {"bg" : colors[groups[g]]}
    labels[g] = g+'-'+groups[g]

wl = Wordlist('../data/Dogon-227-20-cognates.tsv')
wl.calculate('tree', tree_calc='upgma', ref='lexstatid')
plot_tree(wl.tree, fileformat='pdf', filename='../plots/dogon-upgma',
        node_dict=colord, labels=labels, figsize=(15,15))

wl = Wordlist('../data/Dogon-227-20-cognates.tsv')
wl.calculate('tree', tree_calc='neighbor', ref='lexstatid')
plot_tree(wl.tree, fileformat='pdf', filename='../plots/dogon-neighbor',
        node_dict=colord, labels=labels, figsize=(15,15))
