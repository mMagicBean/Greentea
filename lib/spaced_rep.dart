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

  String tableName = globals.currBookName.replaceAll('.pdf', '').replaceAll('-', '_');
  
  late String newPath;
  late var db;

  List<String> prevTableNames = [];
  
  Review() {
    reviewFile = File('Reviews/reviews.db');
    
    if (!reviewFile.existsSync()) {
      reviewFile.createSync(recursive: true);
    }
    
    db = sqlite3.open('Reviews/reviews.db');

    prevTableNames.add(tableName);


    // this is temporary
    for (int i=0; i < prevTableNames.length; i++) {
      if (tableName != prevTableNames[i]) {
        db.execute('''
          CREATE TABLE '$tableName' (
          id INTEGER NOT NULL PRIMARY KEY,
          word TEXT NOT NULL,
          translation TEXT NOT NULL,
          eval TEXT NOT NULL
        );
          ''');
      }
    }
    
      
    grabReviewsFromFile();    
  }

  void saveReviewToFile(String word, String translation, String review) {
    final stmt = db.prepare('INSERT INTO $tableName (word, translation, eval) VALUES (?, ?, ?)');

    stmt
      ..execute(['$word', '$translation', '$review']);
      
    final ResultSet resultSet = db.select('SELECT * FROM $tableName');

    for (final Row row in resultSet) {
      print('${tableName}[id: ${row['id']}, word: ${row['word']}]');
    }

    db.createFunction(
      functionName: 'dart_version',
      argumentCount: const AllowedArgumentCount(0),
      function: (args) => Platform.version,
    );

    print(db.select('Select dart_version()'));
  }

  void grabReviewsFromFile() {
    var contents = reviewFile.readAsStringSync(encoding: latin1);

    late List<String> word;
    late List<String> trans;
    late List<String> eval;
  }  
}
