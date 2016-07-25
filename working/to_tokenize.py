""" Apply tokenizer to new Dogon wordlist data """
import sys
sys.path.append('/Users/stiv/Dropbox/Github/orthotokenizer')
from orthotokenizer.tokenizer import Tokenizer
import pandas as pd
import csv


# Load Heath OP to tokenize
t = Tokenizer("Heath2014.prf")
df = pd.read_csv("per_concept.csv", index_col="ID")
print(df.head())
"""
# Test orthotokenizer
print(t.tokenize("string", column="IPA"))
print(df.head())
"""
l = df['COUNTERPART'].tolist()

tokenizer = lambda x: t.tokenize(x, column="IPA")
df['TOKENS'] = pd.Series(df['COUNTERPART'].apply(tokenizer))
df['TOKENS'] = df['TOKENS'].str.strip()
df.to_csv('per_concept_tokenized.csv')

# wl = pd.read_csv("collapsed-dogon-wordlists.tsv", index_col="ID", sep="\t")
# wl.loc[wl.ID.isin(df.ID), ['TOKENS']] = df[['TOKENS']]
# wl['TOKENS'] = wl['ID'].map(df.set_index('ID')['TOKENS']) # Fails with NAs
# wl['TOKENS'].update(pd.Series(m))
# print(wl.ID.isin(df.ID))
# wl.update(df)
# print(wl.head(40))
# wl.to_csv("final-wordlist.csv")
