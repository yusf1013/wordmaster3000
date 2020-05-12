import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle headWord = GoogleFonts.merriweather(
  textStyle: TextStyle(fontSize: 45, color: Colors.blue[900]),
);

TextStyle tabSelectedWord = TextStyle(
    fontSize: 22, color: Colors.blue[900], fontWeight: FontWeight.bold);

TextStyle tabWord =
    TextStyle(fontSize: 18, color: Colors.black45, fontWeight: FontWeight.bold);

TextStyle dictionaryNumber = GoogleFonts.lato(
  textStyle: TextStyle(fontSize: 20),
  fontWeight: FontWeight.bold,
);

TextStyle dictionaryWords = GoogleFonts.lato(
  textStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
);

TextStyle dictionarySentences = GoogleFonts.lato(
  textStyle: TextStyle(fontSize: 18),
);

TextStyle dictionaryIdiomsAndPhrases = GoogleFonts.lato(
    textStyle: TextStyle(fontSize: 18, decoration: TextDecoration.underline));
