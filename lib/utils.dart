import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

Future<Null> pause(int d) {
  return Future.delayed(Duration(milliseconds: d));
}

Future<List<String>> loadWords() async {
  List<String> words = [];

  String contents = await rootBundle.loadString("assets/dataset.txt");
  words = contents.split("\n");

  return words;
}
  