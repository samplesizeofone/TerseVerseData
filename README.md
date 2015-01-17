TerseVerseData
==============

A set of functionality for suggesting Terse Verse or Hig Pigs.

## What is Hig Pig?
A Hig Pig, also known as Terse Verse, is a riddle who's answer consists of two rhyming words. Some examples include:

* What do you call an over-weight feline? A "fat cat".
* What do you call a crustacean involved in organized crime? A "mobster lobster".
* What do you call an adacious flourish? A "brave wave".

## Current features
Provides a python script for extracting CMU pronounciation data to a CSV and a Mathematica package the provides a simple interface for listing rhymes.

## Planned features
A Mathematica interface for suggesting possible Hig Pigs by selecting synonyms to the solution words. The selected synonyms will probably be of the form <Adjective> <Noun>.

Once complete, I plan to provide versioned access to a generated database of possible Hig Pigs to alleviate the need for Mathematica to be present.

# Requirements
* Python 2.7
* The nltk python package (including the `cmudict` corpa)
* Mathematica
* make

# Implementation

## Derived data
`make build` will populate `derived_data/`. Note this will blindly overwrite existing files.

## Higpig.m
A Mathematica interface for generating potential terse verse.

``Higpig`rhymeWord[word_]`` lists words that rhyme with `word`. Note, at present a word rhymes `word` if `word` is one syllable and the last syllables are the same or, if `word` has more than one syllable, the last two syllables are the same.

``Higpig`countSyllables[phonemes_]`` yields the number of syllables (as determined by the number of arpabet vowels) in `phonemes`.

``Higpig`wordPronounciations`` is an association from a word to all its possible pronounciations.