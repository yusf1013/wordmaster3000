import 'package:flutter/cupertino.dart';

class Category {
  Category(
      {this.title = '',
      this.imagePath = '',
      this.wordCount = 0,
      this.time = 0,
      this.text = "",
      @required this.id});

  String title;
  int wordCount;
  int time;
  String text, id;
  String imagePath;
  static int type = 0;

  static List<Category> wordList = <Category>[
    Category(
      imagePath: 'assets/design_course/clock.png',
      title: 'Recently Searched Words',
      wordCount: 24,
      time: 25,
      text: '',
    ),
    Category(
      imagePath: 'assets/design_course/book(1).png',
      title: 'My Word List one(1)',
      wordCount: 22,
      time: 18,
      text: '',
    ),
    Category(
      imagePath: 'assets/design_course/book(2).png',
      title: 'My Word List two(2)',
      wordCount: 24,
      time: 25,
      text: '',
    ),
    Category(
      imagePath: 'assets/design_course/book(3).png',
      title: 'My Word List three(3)',
      wordCount: 22,
      time: 18,
      text: '',
    ),
  ];

  static List<Category> courseList = <Category>[
    Category(
      imagePath: 'assets/design_course/books.png',
      title: 'Master IELTS In 30 Days',
      wordCount: 1000,
      time: 16,
      text: "/Day",
    ),
    Category(
      imagePath: 'assets/design_course/book(1).png',
      title: 'GRE Top 5000 words',
      wordCount: 5000,
      time: 18,
      text: '/Day',
    ),
    Category(
      imagePath: 'assets/design_course/book(2).png',
      title: 'General Vocabulary Builder',
      wordCount: 2500,
      time: 25,
      text: '/Day',
    ),
    Category(
      imagePath: 'assets/design_course/book(3).png',
      title: 'Saifur\'s magic words',
      wordCount: 500,
      time: 12,
      text: '/Day',
    ),
  ];

  static List<Category> popularCourseList = <Category>[
    Category(
      imagePath: 'assets/design_course/spelling.png',
      title: 'Spelling Master',
      wordCount: 250,
      time: 25,
      text: '',
    ),
    /*Category(
      imagePath: 'assets/design_course/versus.png',
      title: 'Vocab Battle',
      wordCount: 100,
      time: 208,
      text: '',
    ),
    Category(
      imagePath: 'assets/design_course/helicopter.png',
      title: 'Word Copter',
      wordCount: 0,
      time: 25,
      text: '',
    ),*/
  ];
}
