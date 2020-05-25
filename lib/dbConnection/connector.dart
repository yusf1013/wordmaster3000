import 'dart:collection';

import 'dbManager.dart';

class SubMeaning {
  String subMeaning;
  List<String> examples = List<String>();

  @override
  String toString() {
    return subMeaning;
  }
}

class Meaning {
  String partsOfSpeech;
  String meaning = "";
  List<SubMeaning> subMeaning = List<SubMeaning>();
  List<String> synonyms = List<String>();
  List<String> moreExample = List<String>();
  int id;
}

class SearchedWord {
  String word;
  List<String> idioms = new List<String>();
  List<String> phrases = new List<String>();
  //List<Meaning> searchedWordMeaning = List<Meaning>();
  List<String> posList;
  LinkedHashMap<String, List<Meaning>> pos = new LinkedHashMap(
    equals: (a, b) => a.toLowerCase() == b.toLowerCase(),
    hashCode: (key) => key.toLowerCase().hashCode,
  );

  DBManager DbManager = new DBManager();

  getIdioms(String word) async {
    List<Map> maps;
    maps = await DbManager.getidioms(word);
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        Map<dynamic, dynamic> map = maps[i];
        this.idioms.add(map["idioms"]);
      }
    }
  }

  getPhrases(String word) async {
    List<Map> maps;
    maps = await DbManager.getphrases(word);
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        Map<dynamic, dynamic> map = maps[i];
        this.phrases.add(map["phrases"]);
      }
    }
  }

  search(String searchItem) async {
    // Word searched;
    List<Map> maps;
    //DbManager.opendb();
    maps = await DbManager.getWords(searchItem);

    if (maps.length > 0) {
      this.word = searchItem;
      getIdioms(searchItem);
      getPhrases(searchItem);

      for (int i = 0; i < maps.length; i++) {
        Meaning meaningObject = Meaning();
        Map<dynamic, dynamic> map = maps[i];
        int id = map["id"];
        meaningObject.partsOfSpeech = map["parts_of_speech"];
        meaningObject.meaning = map["meaning"] == null
            ? ""
            : map["meaning"]; //add meaningObj.id = id in next line if you want.

        meaningObject.id = id;

        //for synosyms
        List<Map> synonyms = await DbManager.getSynonyms(id);
        if (synonyms.length > 0) {
          for (int i = 0; i < synonyms.length; i++) {
            Map<dynamic, dynamic> synonym = synonyms[i];
            meaningObject.synonyms.add(synonym["synonyms"]);
          }
        }

        //more examples
        List<Map> moreexample = await DbManager.getMoreExample(id);
        if (moreexample.length > 0) {
          for (int i = 0; i < moreexample.length; i++) {
            Map<dynamic, dynamic> more = moreexample[i];
            meaningObject.moreExample.add(more["more_example"]);
          }
        }

        //Sub_meaning
        List<Map> submeaningObjectMap = await DbManager.getSubMeaning(id);

        if (submeaningObjectMap.length > 0) {
          for (int j = 0; j < submeaningObjectMap.length; j++) {
            Map<dynamic, dynamic> submean = submeaningObjectMap[j];
            SubMeaning m = SubMeaning();
            int SUBMEANINGId = submean["submeaning_id"];
            m.subMeaning = submean["submeaning"];

            //example
            List<Map> submeaningexample =
                await DbManager.getExample(SUBMEANINGId);
            if (submeaningexample.length > 0) {
              for (int k = 0; k < submeaningexample.length; k++) {
                Map<dynamic, dynamic> exampleofsubmeaning =
                    submeaningexample[k];
                m.examples.add(exampleofsubmeaning["example"]);
                //String example=exampleofmeaning["example"];
                //print("the pushed example is $example");
              }
            }
            meaningObject.subMeaning.add(m);
          }
        }
        //this.searchedWordMeaning.add(meaningObject);
        if (meaningObject.partsOfSpeech == null) {
          if (this.pos[meaningObject.partsOfSpeech] == null)
            this.pos["Other"] = List();
          this.pos["Other"].add(meaningObject);
        } else {
          if (this.pos[meaningObject.partsOfSpeech] == null)
            this.pos[meaningObject.partsOfSpeech] = List();
          this.pos[meaningObject.partsOfSpeech].add(meaningObject);
        }

        posList = pos.keys.toList();
        posList.add("More");
      }
      //return searched;
    } else
      this.word = "sorry word not found";
  }

  List<String> getPartsOfSpeechList() {
    return posList;
  }

  List<Meaning> getParticularPOS(String givenPos) {
    return pos[givenPos];
  }
}
