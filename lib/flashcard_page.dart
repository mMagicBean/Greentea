import 'package:flutter/material.dart';
import 'package:dolphinsr_dart/dolphinsr_dart.dart';
import 'handle_saved_words.dart';


class Flashcard extends StatefulWidget {    
  final path;
  final sw;

  Flashcard(this.path, this.sw);
  
  @override
  _FlashcardState createState() => _FlashcardState();
}


class _FlashcardState extends State<Flashcard> {
  final dolphin = DolphinSR();
   
  // Visibility Widget Stuff
  bool isQuestionVisible     = true;
  bool isEvaluationRevealed  = false;
  bool isRevealButtonVisible = true;
  bool isAnswerVisible       = false;
  
  bool isCardLengthReached   = false;

  int masterIdIndex = 0;
  int currWordIndex = 0; 

  @override
  initState() {
    _createMasters(dolphin, widget.sw);
  }

  void _createMasters(DolphinSR dolphin, SavedWords sw) {
    print("length of translated words: ${widget.sw.words.length}");
    
    for (var i = 0; i < widget.sw.trans.length; i++) {
      dolphin.addMasters([
          Master(id: i.toString(), fields: [
              widget.sw.words[i],
              widget.sw.trans[i],
            ], combinations: const [
              Combination(front: [0], back: [1]),
          ]),
      ]);
    }

    var stats = dolphin.summary();
    print("${stats.due}-${stats.later}-${stats.learning}-${stats.overdue}");
  }

  void _revealAnswer() {
    setState(() {
        isAnswerVisible = true;
    });
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

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:  MainAxisAlignment.center,
              
              children: <Widget> [
                Visibility(
                  visible: isQuestionVisible,
                  child: Center(
                    child: Text(
                      "${widget.sw.words[currWordIndex]}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white),
                    ), // Text
                  ), // Center
                ), // Visibility
                
                Visibility(
                  visible: isAnswerVisible,
                  
                  child: Center(
                    child: Text(
                      "${widget.sw.trans[currWordIndex]}",
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.blue),
                    ), // Text
                  ), // Center
                ), // Visibility


                Visibility(
                  visible: isRevealButtonVisible,
                  child: Expanded(
                    child: Center(
                      //alignment: Alignment.center,
                      child: TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.white)
                            )
                          )
                        ),

                        onPressed: () {
                          _revealAnswer();
                          isEvaluationRevealed = true;
                        },
                        
                        child: const Text(
                          "Reveal",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                    ), // Align
                  ), // Expanded
                ), // Visibility

                Visibility(
                  visible: isEvaluationRevealed,
                  child: Expanded(
                    flex: 2,
                    
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Row(
                        //padding: const EdgeInsets.all(10.0),
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 80,
                            width: 250,
                            child: TextButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blue),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueGrey.shade900),
                              ), // SizedBox

                              onPressed: () {
                                
                              },

                              child: Text("Easy", style: const TextStyle(fontSize: 32, color: Colors.green)),
                            ),
                          ), // SizedBox

                          SizedBox(
                            height: 80,
                            width: 250,
                            child: TextButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blue),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueGrey.shade900),
                              ), // SizedBox

                              onPressed: () {
                                
                              },

                              child: Text("Hard", style: const TextStyle(fontSize: 32, color: Colors.green)),
                            ),
                          ), // SizedBox
                        ]
                      ),
                    ), // Align
                  ), // Expanded
                ), // Visibility
              ] // Widget 
            ), // Row
          ] // Widget 
        ), // Column
      ), // Container
    ); // Scaffold
  }
}
