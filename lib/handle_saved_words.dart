import 'dart:io';
import 'dart:convert';
import 'dart:core';
import 'translate_util.dart';
import 'globals.dart' as globals;
import 'package:sqlite3/sqlite3.dart';


class SavedWords {
  late String savePath;
  
  late List<String> words = [];
  late List<String> trans = [];

  SavedWords(this.savePath) {
    _createSaveDir(); 
    _grabWordsFromFile();
  }

  void _createSaveDir() {
    Directory('Save/saved_words').createSync(recursive: true);
  }

  String createSavePathFromBookPath(String sPath) {
    final saveDir = 'Save/saved_words/';
    final txtExtension = '.txt';

    final fileNameStart = sPath.lastIndexOf('/') + 1;
    final fileNameEnd   = sPath.lastIndexOf('.');

    final bookName      = sPath.substring(fileNameStart, fileNameEnd).replaceAll('/', '').replaceAll('.', '');

    String newPath = '$saveDir$bookName$txtExtension';

    newPath.replaceAll('/', '\\');
    
    return newPath;
  }  

  void saveWordWithTranslation(String path, String word) async {
    word = _removeJunkChars(word);

    var translation = await quickTranslation(word);

    String _savePath = createSavePathFromBookPath(path); 
    
    var file = File(_savePath);
    var sink = file.openWrite(mode: FileMode.append);
    
    sink.write(word + ',' + translation + ';');
    sink.write('\n');
      
    sink.close();  
  }
  
  List<String> _grabWordsFromFile() {
    String sPath = createSavePathFromBookPath(savePath);

    final file = File(sPath);
    file.createSync(recursive: true);
    
    final contents = file.readAsStringSync(encoding: latin1);

    final pairs = contents.split(';');
    
    words = [];
    trans = [];

    for (final pair in pairs) {
      final parts = pair.split(',');
       
      if (parts.length == 2) {
        words.add(parts[0]);
        trans.add(parts[1]);
      }
    }

    print('saved words = ${words}');
    print('saved trans = ${trans}');
    
    return words;
  }
  
  String _removeJunkChars(String word) {
    List<String> junkChars =
    [',', '!', '?', ':', '-', '+', '(', ')', '&', '*', '^', '%', '\$', '#', '@',
      ';', '<', '>', '/', '\\', '_', '=', '.', '\n'];

    for (var i=0; i < junkChars.length; i++) {
      word = word.replaceAll(junkChars[i], '');
    }

    return word;
  }
}
