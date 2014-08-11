Dogon
=====

A script and accompanying files to convert a generic wordlist (tab delimited file) into QLC/Lingpy input format.

Another script to take the QLC/Lingpy formatted files and create phylogenetic analyses.

- dogon_wordlists.tsv - various wordlists from Dogon; see dogonlanguages.org
- wordlist-to-qlc.py - script to convert dogon_wordlists.tsv into QLC / Lingpy format; see lingpy.org
- Heath2014.prf - Dogon wordlists orthography profile (input to wordlist-to-qlc.py)
- dogon.bl - Dogon blacklist file (input to wordlist-to-qlc.py)
- English.qlc - output file (Dogon basic vocabulary)
- Leipzig-Jakarta.qlc - output file (Leipzig-Jakarata wordlist for Dogon)
- Swadesh-AH.qlc - output file (Dogon Swadesh list via Abbie Hantgan)
- get_distances.py - this script uses Lingpy to generate cognate sets, distance matrices and phylogenetic trees
