import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'dart:typed_data';
import 'pdfviewer.dart';
import 'globals.dart' as globals;


class BookShelf extends StatefulWidget {
  BookShelf();
  
  @override
  _BookShelfState createState() => _BookShelfState();
}

class _BookShelfState extends State<BookShelf> {
  List<dynamic> bookNames = [];

  _BookShelfState() {
    _getBooksFromFolder();
  }

  void _getBooksFromFolder() async {
    Directory bookDir = Directory("Books/");

    if (bookDir.existsSync()) {
      print("Success: Book Folder exists\n");
    } else {
      print("Failed: Book Folder doesn't exist");
      bookDir.create();
    }

    for (var book in bookDir.listSync(recursive: false, followLinks: false)) {
      bookNames.add(book);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (globals.canReloadBookshelf == true) {
      setState((){});
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(50),
      itemCount: bookNames.length,

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ), // gridDelegate

      itemBuilder: (BuildContext context, int index) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 350,
                width: 250,
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.yellow),

                  ), // ButtonStyle

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Book(bookNames[index])),
                    );

                    globals.currBookName = bookNames[index].path.replaceAll('Books/', '');
                    //globals.bookName.replaceAll('Books/', '');
                    
                    //print("current book name = ${globals.bookName}");
                  },

                  child: BookCover(bookNames[index].path),
                )
              ),
            ] // children: <Widget>
          ), // Column
        );// SingleChildScrollView
      }
    );// GridView.builder
  }
}


class BookCover extends StatelessWidget {
  late String bookPath;

  BookCover(this.bookPath) {
    this.bookPath = bookPath;
  }

  Future<Uint8List> _convertPdfToBytes() async {
    final document  = await PdfDocument.openFile(bookPath);
    final page      = await document.getPage(1);
    final pageImage = await page.render(width: 250, height: 350);

    await page.close();

    return pageImage!.bytes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _convertPdfToBytes(),

      builder: (
        BuildContext context,
        AsyncSnapshot<Uint8List> snapshot,
      ) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!);
          }
        }

        return Text("Unable to Load Pdf");
      }
    ); // FutureBuilder
  }
}
