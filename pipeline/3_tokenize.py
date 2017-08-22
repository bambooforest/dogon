""" Tokenizer Dogon wordlist data """

import csv
import pandas as pd
from segments import Tokenizer


def convert_tone(s):
    """ Takes a space-delimited segments string as input and converts accent tone to stand-alone tone. """
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
with open('op/tones.csv', mode='r') as infile:
    reader = csv.reader(infile)
    tones = {rows[0]: rows[1] for rows in reader}


# Heath2016 orthography profile
t = Tokenizer("op/Heath2016-profile.tsv")

# Dogon data to tokenize
df = pd.read_csv("data/dogon-wordlist-long.csv", index_col="ID")

# Tokenize
tokenizer = lambda x: t.transform(x, column="IPA")
tone_changer = lambda x: convert_tone(x)
df['TOKENS'] = pd.Series(df['COUNTERPART'].apply(tokenizer))
df['TOKENS_CHAO'] = pd.Series(df['TOKENS'].apply(tone_changer))
df['TOKENS'] = df['TOKENS'].str.strip()
df['TOKENS_CHAO'] = df['TOKENS_CHAO'].str.strip()

df.to_csv('data/dogon-wordlist-lingpy-format.csv')
# df.to_csv('final-wordlist-new-tone.tsv', sep="\t")

