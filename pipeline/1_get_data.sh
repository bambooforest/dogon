# Get the raw data from the Dogon-data repository
wget -O data/Dogon.comp.vocab.UNICODE-2017.xls https://github.com/clld/dogonlanguages-data/raw/master/beta/Dogon.comp.vocab.UNICODE-2017.xls

# Convert it to csv
in2csv data/Dogon.comp.vocab.UNICODE-2017.xls > data/Dogon.comp.vocab.UNICODE-2017.csv