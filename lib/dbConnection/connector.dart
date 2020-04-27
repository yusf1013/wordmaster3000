import 'dbManager.dart';

class Meaning {
  int meaningId;
  String meaning;
  List<String> example = List<String>();
}

class PartsOfSpeech {
  int id;
  String partsOfSpeech;
  List<Meaning> meaning = List<Meaning>();
  List<String> synonyms = List<String>();
  List<String> moreExample = List<String>();
}

class Connector {
  String word;
  List<String> idioms = new List<String>();
  List<String> phrases = new List<String>();
  List<PartsOfSpeech> property = List<PartsOfSpeech>();

  DBManager DbManager = new DBManager();

  getIdioms(String word) async {
    List<Map> maps;
    maps = await DbManager.getidioms(word);
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        Map<dynamic, dynamic> map = maps[i];
        this.idioms.add(map["idioms"]);
        print(map["idioms"]);
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
      print(searchItem);
      this.word = searchItem;
      print(this.word);
      getIdioms(searchItem);
      getPhrases(searchItem);
      for (int i = 0; i < maps.length; i++) {
        PartsOfSpeech partsofspeech = PartsOfSpeech();
        Map<dynamic, dynamic> map = maps[i];
        int id = map["id"];
        var parts = map["parts_of_speech"];
        partsofspeech.id = id;
        partsofspeech.partsOfSpeech = parts;

        //for synosyms
        List<Map> synonyms = await DbManager.getSynonyms(id);
        if (synonyms.length > 0) {
          for (int i = 0; i < synonyms.length; i++) {
            Map<dynamic, dynamic> synonym = synonyms[i];
            partsofspeech.synonyms.add(synonym["synonyms"]);
          }
        }

        //more examples
        List<Map> moreexample = await DbManager.getMoreExample(id);
        if (moreexample.length > 0) {
          for (int i = 0; i < moreexample.length; i++) {
            Map<dynamic, dynamic> more = moreexample[i];
            partsofspeech.moreExample.add(more["more_example"]);
          }
        }

        //meaning
        List<Map> meaning = await DbManager.getMeaning(id);
        if (meaning.length > 0) {
          for (int j = 0; j < meaning.length; j++) {
            Map<dynamic, dynamic> mean = meaning[j];
            Meaning m = Meaning();
            m.meaningId = mean["meaning_id"];
            m.meaning = mean["meaning"];
            //example
            List<Map> meaningexample = await DbManager.getExample(m.meaningId);
            if (meaningexample.length > 0) {
              for (int k = 0; k < meaningexample.length; k++) {
                Map<dynamic, dynamic> exampleofmeaning = meaningexample[k];
                m.example.add(exampleofmeaning["example"]);
                //String example=exampleofmeaning["example"];
                //print("the pushed example is $example");
              }
            }
            partsofspeech.meaning.add(m);
          }
        }
        this.property.add(partsofspeech);
      }
      //return searched;
    } else
      this.word = "sorry word not found";
  }
}
