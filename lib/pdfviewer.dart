import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class Book extends StatefulWidget {
  late File bookPath;
  
  Book(this.bookPath) {
    this.bookPath = bookPath;
  }
  
  @override
  _BookState createState() => _BookState();
}


class _BookState extends State<Book> {
  late PdfViewerController _pdfViewerController;

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter PDF Viewer'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      
      body: SfPdfViewer.file(
         widget.bookPath,
        key: _pdfViewerKey,
      ),
    );
  }
}
