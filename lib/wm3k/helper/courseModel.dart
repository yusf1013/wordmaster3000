List<String> tags = ["Word List", "TOEFL", "IELTS", "GRE", "BCS", "SAT"];

class CourseModel {
  String name;
  String description;
  String author;
  String rating;
  List<String> tags;

  CourseModel(
      {this.name, this.description, this.rating, this.author, this.tags});
}

class CourseList {
  static List<CourseModel> list = [
    CourseModel(
      name: "Radowan's Word",
      description: "HI, i am Radowan. Welcome to my word list",
      author: "University Of Dhaka",
      rating: "4.5",
      tags: ["Radowan's list", "Popular words"],
    ),
    CourseModel(
      name: "Yousuf's list",
      description: "Hi there, i am yousuf and welcome to my wordlist",
      author: "IIT,DU",
      rating: "4.9",
      tags: ["LIst yousuf", "Hard words"],
    ),
    CourseModel(
      name: "Gafurs Word list",
      description: "Hi i am gafur. Nam to sunahi hoga",
      author: "IIT,DU",
      rating: "4.4",
      tags: ["Big words", "Hard words"],
    ),
  ];
}
