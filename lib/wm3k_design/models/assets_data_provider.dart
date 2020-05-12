class AssetNameProvider {
  int _wordListImageCollectionIndex = -1;
  int _courseImageCollectionIndex = -1;
  List<String> _wordListImageCollection = [
    'assets/design_course/book(1).png',
    'assets/design_course/book(2).png',
    'assets/design_course/book(3).png'
  ];

  String getWordListImage(bool reset) {
    if (_wordListImageCollectionIndex == -1 || reset) {
      _wordListImageCollectionIndex = 0;
      return 'assets/design_course/clock.png';
    }

    String imagePath = _wordListImageCollection[_wordListImageCollectionIndex];
    _wordListImageCollectionIndex =
        (_wordListImageCollectionIndex + 1) % _wordListImageCollection.length;
    return imagePath;
  }

  String getCourseImage() {
    _courseImageCollectionIndex =
        (_courseImageCollectionIndex + 1) % _wordListImageCollection.length;
    String imagePath = _wordListImageCollection[_courseImageCollectionIndex];

    return imagePath;
  }
}
