class WordList {
  String name, description;
  List<String> words = new List(), meanings = new List();

  WordList(this.name, this.description, words, meanings) {
    for (var word in words) this.words.add(word);
    for (var word in meanings) this.meanings.add(word);
  }
}
