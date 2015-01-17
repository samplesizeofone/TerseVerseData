BeginPackage["Higpig`"];

rhymeWord::usage = "Gives words rhyming with rhymeWord[word_]";

Begin["`Private`"]

(* Utility *)
stripStress[phoneme_] :=
    StringReplace[phoneme, x_ /; DigitQ[x] -> ""]

(* Filters *)
onlyNounQ[word_] :=
    partsOfSpeech[word] == {"Noun"}

onlyAdjectiveQ[word_]
    partsOfSpeech[word] == {"Adjective"}

nounQ[word_] :=
    SubsetQ[partsOfSpeech[word], {"Noun"}]

adjectiveQ[word_] :=
    SubsetQ[partsOfSpeech[word], {"Adjective"}]

(* WordData *)
listPartsOfSpeech[word_, targetPartsOfSpeech_] :=
    Module[{partsOfSpeech},
        partsOfSpeech = WordData[word, "PartsOfSpeech"];
        If[Head[partsOfSpeech] === WordData,
            Null,
            partsOfSpeech
        ]
    ]

(* Rhyme database *)
arpabetVowels = {"AO", "AA", "IY", "UW", "EH", "IH", "UH", "AH", 
   "AX", "AE", "EY", "AY", "OW", "AW", "OY", "ER"};

countSyllables[phonemes_] :=
    Length[Cases[phonemes, phoneme_ /; MemberQ[arpabetVowels, phoneme]]]

findLastSyllables[phonemes_] :=
    Module[{vowelPositions, numberOfSyllables},
        vowelPositions =
            Position[
                phonemes,
                phoneme_/;MemberQ[arpabetVowels, phoneme]
            ];
        If[countSyllables[phonemes] >= 2,
            numberOfSyllables = 2,
            numberOfSyllables = 1
        ];
        If[Length[vowelPositions] >= numberOfSyllables,
            Take[
                phonemes,
                {vowelPositions[[-numberOfSyllables, 1]], Length[phonemes]}
            ],
            {}
        ]
    ]

cmuToWordPronunciations[cmu_] :=
    Module[{wordPronounciations, word, pronounciation},
        wordPronounciations = <||>;
        Do[
            {word, pronounciation} = {
                entry[[1]],
                Drop[entry, 1]
            };
            If[Not[KeyExistsQ[wordPronounciations, word]],
                wordPronounciations[word] = {}
            ];
            AppendTo[wordPronounciations[word], stripStress/@pronounciation],
            {entry, cmu}
        ];
        wordPronounciations
    ]

wordPronounciationsToWordEndings[wordPronounciations_] :=
    Module[{endings, lastSyllables},
        <|
            Flatten[
                Table[
                    endings =
                        Table[
                            findLastSyllables[pronounciation],
                            {pronounciation, wordPronounciations[word]}
                        ] /. {} :> Sequence[];
                    word->endings,
                    {word, Keys[wordPronounciations]}
                ]
            ] /. (word_->{}) :> Sequence[]
        |>
    ]

wordEndingsToEndingWords[wordEndings_] :=
    Module[{endingWords},
        endingWords = <||>;
        Do[
            If[Not[KeyExistsQ[endingWords, ending]],
                endingWords[ending] = {}
            ];
            AppendTo[endingWords[ending], word],
            {word, Keys[wordEndings]},
            {ending, wordEndings[word]}
        ];
        endingWords
    ]

rhymeWord[word_] :=
    Complement[
        Flatten[Higpig`endingWords /@ Higpig`wordEndings[word]],
        {word}
    ]

End[]

cmu = Import["Projects/TerseVerseData/derived_data/cmu.csv"];
wordPronounciations = `Private`cmuToWordPronunciations[cmu];
wordEndings = `Private`wordPronounciationsToWordEndings[wordPronounciations];
endingWords = `Private`wordEndingsToEndingWords[wordEndings];

EndPackage[]