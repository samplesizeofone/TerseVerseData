import csv

import nltk

entries = nltk.corpus.cmudict.entries()

with open('rhymes_out.csv', 'wb') as rhymes_file:
    rhymes_csv = csv.writer(rhymes_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL, lineterminator='\n')
    for (word, phonemes) in entries:
        rhymes_csv.writerow([word] + phonemes)
