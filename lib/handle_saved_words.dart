import 'dart:io';
import 'dart:convert';
import 'dart:core';
import 'translate_util.dart';

/*
void createSaveDir() {
  var saveDir = Directory('Save/saved_words').createSync(recursive: true);
}

String createSavePathFromBookPath(String path) {
  final saveDir = '/Save/saved_words/';
  final txtExtension = '.txt';

  final fileNameStart = path.lastIndexOf('/') + 1;
  final fileNameEnd   = path.lastIndexOf('.');

  final bookName      = path.substring(fileNameStart, fileNameEnd).replaceAll('/', '').replaceAll('.', '');

  final savePath = '$saveDir$bookName$txtExtension';

  return savePath;
}

void saveWordWithTranslation(String path, String word) async {  
  word = removeJunkChars(word);
  
  createSaveDir();
  
  var translation = await quickTranslation(word);

  final List<String> pathChars = path.split(' ');

  String savePath = createSavePathFromBookPath(path);
  
  var file = File(savePath);
  var sink = file.openWrite(mode: FileMode.append);

  sink.write(word + ',' + translation + ';');
  sink.write('\n');

  sink.close();
}
*/

class SavedWords {
  late String savePath;
  
  late List<String> words = [];
  late List<String> trans = [];

  int totalLength = 0;

  SavedWords(this.savePath) {
    _createSaveDir(); // NOTE: this is probably gonna be ran on every instance created
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

    final List<String> pathChars = path.split(' ');

    String _savePath = createSavePathFromBookPath(path);

    var file = File(_savePath);
    var sink = file.openWrite(mode: FileMode.append);

    sink.write(word + ',' + translation + ';');
    sink.write('\n');
    
    sink.close();
  }
  
  List<String> _grabWordsFromFile() {
    final file = File(savePath);
    
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
