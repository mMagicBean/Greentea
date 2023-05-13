import 'dart:io';
import 'dart:convert';
import 'globals.dart' as globals;
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';


class Review {
  late String word;
  late String review;
  late File reviewFile;

  String revDir = 'Reviews/';

  late String tableName;
  late String newPath;
  late var db;

  List<String> prevTableNames = [];
  
  Review() {
    reviewFile = File('Reviews/reviews.db');
    
    if (!reviewFile.existsSync()) {
      reviewFile.createSync(recursive: true);
    }
    
    db = sqlite3.open('Reviews/reviews.db');

    tableName = globals.currBookName.replaceAll('.pdf', '').replaceAll('-', '_');
    prevTableNames = _getPrevTableNames();

    // check if table already exists before creating it 
    if (_checkIfTableNameExists(prevTableNames, tableName) != true) {
      _saveTableNameToFile(tableName);

      // create table 
      db.execute('''
        CREATE TABLE '$tableName' (
        id INTEGER NOT NULL PRIMARY KEY,
        word TEXT NOT NULL,
        translation TEXT NOT NULL,
        eval TEXT NOT NULL
      );
        ''');
    }
    
    print('amount of prev tableNames = ${prevTableNames.length}');
    //grabReviewsFromFile();    
  }

  void _saveTableNameToFile(String tName) {
    if (tName == null) {
      return;
    }
    
    var file = File('Reviews/saved_table_names.txt');    
    var sink = file.openWrite(mode: FileMode.append);

    sink.write('$tName' + ',');
    sink.close();
  }

  List<String> _getPrevTableNames() {
    final file = File('Reviews/saved_table_names.txt');
    file.createSync(recursive: true); 
    
    final contents = file.readAsStringSync(); 
    
    final pairs = contents.split(',');
    
    return pairs;
  }

  bool _checkIfTableNameExists(List<String> tNames, String newTable) {
    for (int i=0; i < tNames.length; i++) {
      if (tNames[i] == newTable) {
        return true;
      } 
    }

    return false;
  }

  void saveReviewToFile(String sWord, String translation, String review) {
    sWord = sWord.replaceAll('\n', '');

    final ResultSet resultSet = db.select('SELECT * FROM $tableName');

    for (final Row row in resultSet) {
      print('${tableName}[id: ${row['id']}, word: ${row['word']}]');

      // check for duplicates before inserting
      if (row['word'] == sWord) {
        return;   
      } 
    }

    final stmt = db.prepare('INSERT INTO $tableName (word, translation, eval) VALUES (?, ?, ?)');

    stmt
    ..execute(['$sWord', '$translation', '$review']);
    
    db.createFunction(
      functionName: 'dart_version',
      argumentCount: const AllowedArgumentCount(0),
      function: (args) => Platform.version,
    );

    print(db.select('Select dart_version()'));
  }
}
