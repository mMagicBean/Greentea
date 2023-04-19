import 'package:flutter/material.dart';
import 'package:dolphinsr_dart/dolphinsr_dart.dart';
import 'handle_saved_words.dart';



class Flashcard extends StatefulWidget {
  late String path;

  Flashcard(this.path) {
    this.path = path;
  }

  @override
  _FlashcardState createState() => _FlashcardState();
}


class _FlashcardState extends State<Flashcard> {
  late var sw;

  // Visibility Widget Stuff
  bool isQuestionVisible     = true;
  bool isEvaluationRevealed  = false;
  bool isRevealButtonVisible = true;
  bool isAnswerVisible       = false;
  
  bool isCardLengthReached   = false;
  
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
