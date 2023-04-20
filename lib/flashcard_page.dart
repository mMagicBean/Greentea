import 'package:flutter/material.dart';
import 'package:dolphinsr_dart/dolphinsr_dart.dart';
import 'handle_saved_words.dart';


class Flashcard extends StatelessWidget {
  final dolphin = DolphinSR();

  late String path;
  late SavedWords sw;
  
  Flashcard(this.path) {
    sw = SavedWords(path);
    _createMasters(dolphin);
  }
  
  // Visibility Widget Stuff
  bool isQuestionVisible     = true;
  bool isEvaluationRevealed  = false;
  bool isRevealButtonVisible = true;
  bool isAnswerVisible       = false;
  
  bool isCardLengthReached   = false;

  int masterIdIndex = 0;
  
  void _createMasters(DolphinSR dolphin) {
    for (masterIdIndex = 0; masterIdIndex < sw.trans.length; masterIdIndex++) {
      dolphin.addMasters([
          Master(id: masterIdIndex.toString(), fields: [
              sw.words[masterIdIndex],
              sw.trans[masterIdIndex],
            ], combinations: const [
              Combination(front: [0], back: [1]),
          ]),
      ]);
    }

    var stats = dolphin.summary();
    print("${stats.due}-${stats.later}-${stats.learning}-${stats.overdue}");
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
      ),

      body: Container(
        padding: const EdgeInsets.all(10.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:  MainAxisAlignment.center,
              children: <Widget> [
                Visibility(
                  visible: isQuestionVisible,
                  child: Center(
                    child: Text(
                      "Question Text",
                      textAlign: TextAlign.center,

                      style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white),
                    ), // Text
                  ), // Center
                ), // Visibility


                Visibility(
                  visible: isAnswerVisible,
                  child: Center(
                    child: Text(
                      "Answer Text",
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.blue),
                    ), // Text
                  ), // Center
                ), // Visibility
              ] // Widget 
            ), // Row
          ] // Widget 
        ), // Column
      ), // Container
    ); // Scaffold
  }
}
