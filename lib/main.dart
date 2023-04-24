import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'bookshelf.dart';
import 'pdfviewer.dart';


void main() {
  runApp(Greentea());
}

class Greentea extends StatefulWidget {
  @override
  _GreenteaState createState() => _GreenteaState();
}

class _GreenteaState extends State<Greentea> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: HomePage(),
        
      ), // Container
    ); // MaterialApp
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool canReloadBookShelf = false;

  late String impBookName;
  
  Future<Uint8List> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false, withData: true);

    if (result == null) {
      throw Exception('File selection cancelled');
    }

    if (result.files.length != 1) {
      throw Exception('Please select exactly one file');
    }

    print(result.files.first);
    
    final file = result.files.first;

    if (file.bytes == null) {
      throw Exception('Selected file is empty');
    }

    impBookName = file.name;
    
    return file.bytes!;
  }

  void _importFileToBooks() async {
    Uint8List bytes = await _pickFiles();

    final newFile = File('C:/Users/Bean/projects/greentea/Books/${impBookName}');
    newFile.createSync(recursive: true);

    newFile.writeAsBytes(bytes!);// as Uint8List;    

    canReloadBookShelf = true;
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: Stack(
          children: <Widget>[
            BookShelf(),

            Align(
              alignment: Alignment.topCenter,
              child: TextButton(
                child: Text(
                  "Import a PDF",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),

                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.green)
                    )
                  )
                ),

                onPressed: () {
                  _importFileToBooks();
                }
              ),
            ),
          ]
        ),
      ), // Container
    ); // MaterialApp
  }
}
