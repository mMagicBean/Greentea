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

    /*
    db = sqlite3.open('Reviews/reviews.db');

    prevTableNames.add(tableName);

    for (int i=0; i < prevTableNames.length; i++) {
      // check if table name exists already
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
      */
      
    grabReviewsFromFile();    
  }

  void saveReviewToFile(String word, String translation, String review) {
    db = sqlite3.open('Reviews/reviews.db');
    
    db.execute('''
      CREATE TABLE '$tableName' (
      id INTEGER NOT NULL PRIMARY KEY,
      word TEXT NOT NULL,
      translation TEXT NOT NULL,
      eval TEXT NOT NULL
    );
      ''');

    
    final wordStmt = db.prepare('INSERT INTO $tableName (word) VALUES (?)');
    //wordStmt.execute();
    
    wordStmt
      ..execute(['$word']);

    wordStmt.dispose();
      
    final transStmt = db.prepare('INSERT INTO $tableName (translation) VALUES (?)');

    transStmt
      ..execute(['$translation']);

    final evalStmt = db.prepare('INSERT INTO $tableName (eval) VALUES (?)');

    evalStmt
      ..execute(['${review}']);

    final ResultSet resultSet = db.select('SELECT * FROM ${tableName}');

    for (final Row row in resultSet) {
      print('${tableName}[id: ${row['id']}, word: ${row['word']}]');
    }

    db.createFunction(
      functionName: 'dart_version',
      argumentCount: const AllowedArgumentCount(0),
      function: (args) => Platform.version,
    );

    print(db.select('Select dart_version()'));

    db.dispose();
  }

  void grabReviewsFromFile() {
    var contents = reviewFile.readAsStringSync(encoding: latin1);

    late List<String> word;
    late List<String> trans;
    late List<String> eval;
  }
  
  void evaluateReviews() {
    
  }
}
