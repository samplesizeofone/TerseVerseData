TerseVerseData
==============

# Derived data
`make build` will populate `derived_data/`. Note this will blindly overwrite existing files.

# Higpig.m
A Mathematica interface for generating potential terse verse.

``Higpig`rhymeWord[word_]`` lists words that rhyme with `word`. Note, at present a word rhymes `word` if `word` is one syllable and the last syllables are the same or, if `word` has more than one syllable, the last two syllables are the same.

``Higpig`countSyllables[phonemes_]`` yields the number of syllables (as determined by the number of arpabet vowels) in `phonemes`.

``Higpig`wordPronounciations`` is an association from a word to all its possible pronounciations.