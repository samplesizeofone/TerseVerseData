BeginPackage["Higpig`"];

filterPartOfSpeech::usage = "Filters wordList by partsOfSpeech. Options include \"exact\"."

rhymeNoun::usage = ""
rhymeAdjective::usage = ""
possibleNounSynonyms::usage = ""
possibleAdjectiveSynonyms::usage = ""
allWords

Begin["`Private`"]

passThroughOption[option_] :=
    option

passThroughOption[option_ -> "default"] :=
    Sequence[]

(* Filters *)
partsOfSpeechQ[word_, targetPartsOfSpeech_, OptionsPattern[]] :=
    Module[{partsOfSpeech},
        partsOfSpeech = WordData[word, "PartsOfSpeech"];
        If[Head[partsOfSpeech] === WordData,
            Return[False]
        ];
        If[OptionValue["exact"],
            SubsetQ[partsOfSpeech, targetPartsOfSpeech]
            && SubsetQ[targetPartsOfSpeech, partsOfSpeech],
            SubsetQ[WordData[word, "PartsOfSpeech"], targetPartsOfSpeech]
        ]
    ]
Options[partsOfSpeechQ] = {"exact" -> True}

nounQ[word_] :=
    partsOfSpeech[word, {"Noun"}]

adjectiveQ[word_]
    partsOfSpeech[word, {"Adjective"}]

filterPartOfSpeech[wordList_, partsOfSpeech_, OptionsPattern[]] :=
    Cases[
        wordList,
        word_/;partsOfSpeechQ[
                word,
                partsOfSpeech,
                passThroughOption["exact" -> OptionValue["exact"]]
            ]
    ]
Options[filterPartOfSpeech] = {"exact" -> "default"}

(* WordData *)
possibleSynonyms[word_] :=
    Flatten[#[[2]]& /@ WordData[word, "Synonyms"]]

possiblePartsOfSpeechSynonyms[word_, partsOfSpeech_, OptionsPattern[]] :=
    filterPartOfSpeech[
        possibleSynonyms[word],
        partsOfSpeech,
        passThroughOption["exact" -> OptionValue["exact"]]
    ]
Options[possiblePartsOfSpeechSynonyms] = {"exact" -> "default"}

possibleNounSynonyms[word_] :=
    possiblePartsOfSpeechSynonyms[word, {"Noun"}]

possibleAdjectiveSynonyms[word_] :=
    possiblePartsOfSpeechSynonyms[word, {"Adjective"}]

(* Rhyme database *)
rhymeCSV = Drop[Import["Projects/TerseVerseData/rhyme.tsv"], 1]

allRhymes = <|
    Table[
        rhymeCSV[[i, 2]] -> Flatten[Table[{#,j - 2}& /@ StringSplit[rhymeCSV[[i, j]], ", "], {j, 3, 12}], 1],
        {i, Length[rhymeCSV]}
    ]
|>

allWords = Keys[allRhymes]

syllableCount = <|
    Table[
        word -> Length[WordData[word, "Hyphenation"]],
        {word, allWords}
    ]
|>

rhymeWord[word_, OptionsPattern[]] :=
    Module[{rhymes},
        rhymes = Cases[
            allRhymes[word],
            {rhyme_, syllables_}/;OptionValue["syllables"] === Null || OptionValue["syllables"] === syllables :> rhyme
        ];
        If[OptionValue["partsOfSpeech"] =!= Null,
            rhymes =
                filterPartOfSpeech[
                    rhymes,
                    OptionValue["partsOfSpeech"],
                    passThroughOption["exact" -> OptionValue["exact"]]
                ]
        ];
        rhymes
    ]
Options[rhymeWord] = {
    "syllables" -> Null,
    "partsOfSpeech" -> Null,
    "exact" -> "default"
}

rhymeNoun[word_] :=
    rhymeWord[word, "partsOfSpeech" -> {"Noun"}, "syllables" -> 1]

rhymeAdjective[word_] :=
    rhymeWord[word, "partsOfSpeech" -> {"Adjective"}, "syllables" -> 1]

End[]
EndPackage[]