import 'dbManager.dart';

class SubMeaning {
  String submeaning;
  List<String> example = List<String>();
}

class Meaning {
  String partsOfSpeech;
  String meaning;
  List<SubMeaning> sub_meaning = List<SubMeaning>();
  List<String> synonyms = List<String>();
  List<String> moreExample = List<String>();
}

class SearchedWord {
  String word;
  List<String> idioms = new List<String>();
  List<String> phrases = new List<String>();
  List<Meaning> searchedWordMeaning = List<Meaning>();

  DBManager DbManager = new DBManager();

  getIdioms(String word) async {
    List<Map> maps;
    maps = await DbManager.getidioms(word);
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        Map<dynamic, dynamic> map = maps[i];
        this.idioms.add(map["idioms"]);
        //print(map["idioms"]);
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
    print("calling for get word");
    //DbManager.opendb();
    maps = await DbManager.getWords(searchItem);

    if (maps.length > 0) {
      //print(searchItem);
      this.word = searchItem;
      //print(this.word);
      getIdioms(searchItem);
      getPhrases(searchItem);

      for (int i = 0; i < maps.length; i++) {
        Meaning meaningObject = Meaning();
        Map<dynamic, dynamic> map = maps[i];
        int id = map["id"];
        meaningObject.partsOfSpeech = map["parts_of_speech"];
        meaningObject.meaning=map["meaning"];

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
            m.submeaning = submean["submeaning"];

            //example
            List<Map> submeaningexample = await DbManager.getExample(SUBMEANINGId);
            if (submeaningexample.length > 0) {
              for (int k = 0; k < submeaningexample.length; k++) {
                Map<dynamic, dynamic> exampleofsubmeaning = submeaningexample[k];
                m.example.add(exampleofsubmeaning["example"]);
                //String example=exampleofmeaning["example"];
                //print("the pushed example is $example");
              }
            }
            meaningObject.sub_meaning.add(m);
          }
        }
        this.searchedWordMeaning.add(meaningObject);
      }
      //return searched;
    } else
      this.word = "sorry word not found";
  }

  List<String> getPartsOfSpeechList() {
    List<String> list = new List();
    for (Meaning pos in searchedWordMeaning) {
      String temp = (pos.partsOfSpeech.toUpperCase() + pos.partsOfSpeech.substring(1));
      temp = temp.split("[")[0];
      print("Dhur miah: $temp");
      list.add(temp);
    }
    /*for (PartsOfSpeech pos in property)
      list.add((pos.partsOfSpeech[0].toUpperCase() +
          pos.partsOfSpeech.substring(1)));*/
    list.add("More");
    return list;
  }

  Meaning getParticularPOS(String givenPos) {
    for (Meaning pos in searchedWordMeaning)
      if (givenPos.toLowerCase() == pos.partsOfSpeech.toLowerCase() || pos.partsOfSpeech.toLowerCase().contains(givenPos.toLowerCase()))
        return pos;
    return null;
  }
}
