"""
Example script that uses Lingpy's Spreadsheet reader. Uses Dogon wordlist data as input (Heath et al 2014).

Author: Steven Moran
Date: Aug 2014
"""

__author__ = "Steven Moran"
__date__ = "2014-28-02"

import sys
from lingpy import *
from lingpy.basic import *
from lingpy.basic.spreadsheet import Spreadsheet # Spreadsheet is not part of standard Lingpy package
from lingpy.settings import rcParams

# Set debug and/or verbose mode on or off
rcParams["debug"]=True
# rcParams["verbose"]=True

# Which subset (column) will you choose?
wordlists = ["Leipzig-Jakarta", "Swadesh-AH", "English"] # English == Dogon Basic Vocabulary list

for wordlist in wordlists:
    # Load the spreadsheet and specify attributes like the blacklist file and the column for concepts
    s = Spreadsheet(
        "data/dogon_wordlists.tsv", 
        meanings = wordlist,
        skip_empty_concepts=False, 
        cellsep="\\\\", 
        blacklist="dogon.bl")

    # Load as LingPy wordlist, tokenize and create QLC output format
    wl = Wordlist(s)
    wl.tokenize("Heath2014", column="ipa")

    # Write the data to an output file
    wl.output('qlc',filename=wordlist)

    # If you want some descriptive stats from the Spreadsheet dat
    # s.stats()
    # analyses = s.analyze("words")
    # analyses = s.analyze("graphemes")
    # s.pprint(analyses[0])
