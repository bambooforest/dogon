# Data preparation pipeline for Dogon paper

## Requirements

- csvkit
- wget
- R (tidyr, reshape2, dplyr)
- Python3 (pandas, segments, csv)

## Step 1

Run the bash command `sh 1_get_data.sh` to download the Dogon data to the `data` directory and convert it to a csv file.

## Step 2

Run R on the command line `Rscript 2_convert_format.R` to convert the wide CSV format to long LingPy CSV.

## Step 3

Run the Python script `python3 3_tokenize.py` to tokenize the data.

