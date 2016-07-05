"""
Script to use LingPy and Dogon data given some paramenters to:

- create distance matrix
- phonetic alignments
- clustering, phylogenetic tree creations

Steven Moran <steven.moran@uzh.ch>
August 2014

"""

import sys
from lingpy import *
from lingpy.convert.plot import *


def get_distances(filename, method, id, threshod):
    """
    Output simple distance matrices given several parameters
    """
    output = filename+"-"+method+"-"+str(threshold)

    print("[i] Loading file")
    lex = LexStat(filename+".qlc")
    
    print("[i] Loading scorer")
    lex.get_scorer(force=True)
    lex.pickle()

    print("[i] Clustering words into cognate sets")
    lex.cluster(method=method, threshold=threshold, verbose=False)

    print("[i] Writing distance matrix to disk")
    lex.output('dst', filename=output, ref=id)


def main(filename, method, id, threshold):
    """
    Method to output tress, distance matrices, etc.
    """
    output = filename+"-"+method+"-"+str(threshold)

    print("[i] Loading file")
    lex = LexStat(filename+".qlc")
    
    print("[i] Loading scorer")
    lex.get_scorer(force=True)

    print("[i] Pickling file")
    lex.pickle()

    print("[i] Clustering words into cognate sets")
    lex.cluster(method=method, threshold=threshold, verbose=False)

    print("[i] Writing csv output to disk")
    lex.output(
        'qlc',
        filename=output,
        subset=True,
        formatter='concepts',
        cols=['concepts', 'taxa', 'counterpart', 'tokens', id]
    )

    print("[i] Processing phonetic alignments")
    alm = Alignments(output+".qlc", ref=id)
    alm.align(method='library', output=True)
    alm.output("html", filename=output, ref=id)
    alm.output("alm", filename=output, ref=id)
    alm.output("qlc", filename=output, ref=id)

    print("[i] Calculating trees")
    lex.calculate('dst', ref=id)
    lex.calculate('tree', ref=id, tree_calc='neighbor', distances=True)
    print(lex.tree)
    sys.exit(1)

    print("[i] Writing distance matrix to disk")
    lex.output('dst', filename=output, ref=id)

    print("[i] Getting distances and taxa for plotting trees")
    matrix = lex.get_distances()
    taxa = lex.taxa
    neighbor(matrix,taxa)

    print("[i] Plotting neighbor joining tree")
    plot_tree(neighbor(matrix,taxa), filename=output+"-tree")

    print("[i] Printing the ASCII representation")
    print(lex.tree.asciiArt())
    ascii_tree = open(output+"-ascii.tree", "w")
    ascii_tree.write(lex.tree.asciiArt())
    ascii_tree.close()

if __name__=="__main__":
    filenames = ["English", "Leipzig-Jakarta", "Swadesh-AH"]
    methods = ["lexstat", "edit-dist"]
    ids = ["lexstatid", "editid"] # ids assigned by lingpy (why not simply cogid?)
    thresholds = [0.5, 0.6, 0.7]

    # main(filenames[0], methods[0], ids[0], thresholds[0])
    # print("rm -R __lingpy__/")

    # main(filenames[0], methods[0], ids[0], thresholds[0])
    main(filenames[1], methods[0], ids[0], thresholds[0])




