import 'dart:io';
import 'dart:convert';
import 'dart:core';
import 'translate_util.dart';


void createSaveDir() {
  var saveDir = Directory('Save/saved_words').createSync(recursive: true);
}


String createSaveFromBookPath(String path) {
  final saveDir = 'Save/saved_words/';
  final txtExtension = '.txt';

  final fileNameStart = path.lastIndexOf('/') + 1;
  final fileNameEnd   = path.lastIndexOf('.');

  final bookName      = path.substring(fileNameStart, fileNameEnd).replaceAll('/', '').replaceAll('.', '');

  final savePath = '$saveDir$bookName$txtExtension';

  return savePath;
}


String removeJunkChars(String word) {
  List<String> junkChars =
  [',', '!', '?', ':', '-', '+', '(', ')', '&', '*', '^', '%', '\$', '#', '@',
   ';', '<', '>', '/', '\\', '_', '=', '.', '\n'];

 for (var i=0; i < junkChars.length; i++) {
   word = word.replaceAll(junkChars[i], '');
 }

 return word;
}


void saveWordWithTranslation(String path, String word) async {
  if (word.contains(' ')) {
    print('save one word at a time!');
  }
  
  word = removeJunkChars(word);
  
  createSaveDir();
  
  var translation = await quickTranslation(word);

  final List<String> pathChars = path.split(' ');

  String savePath = "";

  try {
    savePath = createSaveFromBookPath(path);
  }
  
  on Exception {
    return;
  }

  var file = File(savePath);
  var sink = file.openWrite(mode: FileMode.append);

  sink.write(word + ',' + translation + ';');
  sink.write('\n');

  sink.close();
}

class SavedWords {
  late List<String> words;
  late List<String> trans;
  
  late String currBookPath;

  List<String> grabWordsFromFile(String path) {
    final file = File(path);

    if (!file.existsSync()) {
      return [];
    }

    final contents = file.readAsStringSync(encoding: latin1);

    final pairs = contents.split(';');

    final words = <String>[];
    final translations = <String>[];

    for (final pair in pairs) {
      final parts = pair.split(',');
      
      if (parts.length == 2) {
        words.add(parts[0]);
        translations.add(parts[1]);
      }
    }

    return words;
  }
}
