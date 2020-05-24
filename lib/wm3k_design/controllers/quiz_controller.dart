class QuizController {
  List<String> wrongOptions;

  QuizController(this.wrongOptions);

  List<String> _chooseRandom(String s1, String s2, String s3) {
    List<String> list = List();
    list.add(s1);
    list.add(s2);
    list.add(s3);
    list.shuffle();
    return list.sublist(1);
  }

  int _findAnswer(List<String> options, String ans) {
    int none = -1;
    for (int i = 0; i < options.length; i++)
      if (options[i] == ans)
        return i;
      else if (options[i] == 'none') none = i;

    return none;
  }

  Map getOptions(String ans) {
    List<String> list = wrongOptions, list2 = List();
    list.shuffle();
    Map map = Map();
    for (int i = 0; list2.length < 2; i++) {
      if (list[i] != ans) list2.add(list[i]);
    }
    list2.addAll(_chooseRandom(ans, list[8], 'none'));
    list2.shuffle();

    for (int i = 0; i < list2.length; i++)
      if (list2[i].endsWith(":"))
        list2[i] = list2[i].substring(0, list2[i].length - 1);

    if (ans.endsWith(":")) ans = ans.substring(0, ans.length - 1);

    map = {'options': list2, 'answer': _findAnswer(list2, ans)};
    return map;
  }
}
