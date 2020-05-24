import 'package:wm3k/dbConnection/connector.dart';

class WordList {
  String name, description;
  List<FireBaseSubMeaning> subMeanings;
  int id;

  WordList(this.name, this.description, this.subMeanings, this.id);

  getShuffledWordList() {
    List<FireBaseSubMeaning> newSubMeanings = List();
    for (FireBaseSubMeaning subMeaning in subMeanings)
      newSubMeanings.add(subMeaning);
    newSubMeanings.shuffle();
    return WordList(name, description, newSubMeanings, id);
  }

  bool hasWord(String id, int index) {
    print(
        "In list $name, given id: $id, given index $index, length: ${subMeanings.length}");
    for (FireBaseSubMeaning sm in subMeanings)
      if (sm.isSameSubMeaning(id, index)) return true;

    return false;
  }
}

class FireBaseSubMeaning {
  String id, subMeaning, word;
  int index;
  List<String> examples = List();

  FireBaseSubMeaning(
      this.id, this.subMeaning, this.word, List<dynamic> examples, this.index) {
    word = word[0].toUpperCase() + word.substring(1);
    subMeaning = subMeaning[0].toUpperCase() + subMeaning.substring(1);
    for (String example in examples) this.examples.add(example);
  }

  bool isSameSubMeaning(String id, int index) {
    print("\t inside submeaning func: ${this.id}, ${this.index}");
    return (this.id == id && this.index == index);
  }

  String getSubMeaning() {
    if (subMeaning.endsWith(":"))
      return subMeaning.substring(0, subMeaning.length - 1);
    else
      return subMeaning;
  }

  String getFirstExample() {
    if (examples.length > 0)
      return examples[0];
    else
      return null;
  }
}
