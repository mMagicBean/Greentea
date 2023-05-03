import 'dart:io';
import 'globals.dart' as globals;
import 'package:path/path.dart' as p;

class Review {
  late String word;
  late String review;
  late File reviewFile;

  String revDir = 'Reviews/';
  String revFilePath = globals.currBookName;
  late String newPath;
  
  Review() {
    revFilePath = revFilePath.replaceAll('.pdf', '.txt');

    newPath = p.join('$revDir', '$revFilePath');

    print('newPath = $newPath');
    
    reviewFile = File(newPath);
    
    if (!reviewFile.existsSync()) {
      reviewFile.createSync(recursive: true);
    }
  }

  void saveReviewToFile(String word, String translation, String review) {
    var sink = reviewFile.openWrite(mode: FileMode.append);
    
    sink.write('${word}' + ',' + '${translation}' + '.' + '${review}' + ';');

    sink.close();
  } 
}
