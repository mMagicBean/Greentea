import 'dart:io';
import 'dart:async';
import 'handle_saved_words.dart';

void main() {
  SavedWords sw = SavedWords("Save/saved_words/SherlockHolmes-Romanian.txt");

  sw.grabWordsFromFile();
  
  print(sw.trans);
  print(sw.words);
}
