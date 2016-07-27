""" Apply tokenizer to new Dogon wordlist data """
import sys
sys.path.append('/Users/stiv/Dropbox/Github/orthotokenizer')
from orthotokenizer.tokenizer import Tokenizer
import pandas as pd
import csv

def convert_tone(s):
    """ Takes a space-delimited segments string as input and converts accent tone to stand-alone tone """
    result = []
    segments = s.split()
    for segment in segments:
        new_segment = ""
        tone = ""
        for c in segment:
            if c in tones:
                tone += tones[c]
            else:
                new_segment += c
        if len(new_segment) > 0: result.append(new_segment)
        if len(tone) > 0: result.append(tone)
    return " ".join(result)


# Load tones.csv as lookup table                                                                                                                           
with open('tones.csv', mode='r') as infile:
    reader = csv.reader(infile)
    tones = {rows[0]:rows[1] for rows in reader}


# Load Heath OP to tokenize
t = Tokenizer("Heath2016.prf")

# To tokenize just the new data:
# df = pd.read_csv("per_concept.csv", index_col="ID")
# To tokenize the already combined final data

df = pd.read_csv("final-wordlist.csv", index_col="ID")
print(df.head())

"""
# Test orthotokenizer
print(t.tokenize("string", column="IPA"))
print(df.head())
"""
# l = df['COUNTERPART'].tolist()

tokenizer = lambda x: t.tokenize(x, column="IPA")
tone_changer = lambda x: convert_tone(x)

df['TOKENS'] = pd.Series(df['COUNTERPART'].apply(tokenizer))
df['TOKENS'] = pd.Series(df['TOKENS'].apply(tone_changer))
df['TOKENS'] = df['TOKENS'].str.strip()
df.to_csv('final-wordlist-new-tone.csv')

# Test data
input = ""
output = ""
# compare input/output

# wl = pd.read_csv("collapsed-dogon-wordlists.tsv", index_col="ID", sep="\t")
# wl.loc[wl.ID.isin(df.ID), ['TOKENS']] = df[['TOKENS']]
# wl['TOKENS'] = wl['ID'].map(df.set_index('ID')['TOKENS']) # Fails with NAs
# wl['TOKENS'].update(pd.Series(m))
# print(wl.ID.isin(df.ID))
# wl.update(df)
# print(wl.head(40))
# wl.to_csv("final-wordlist.csv")
