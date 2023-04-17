import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/services.dart';


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

  OverlayEntry? _contextOverlayEntry;
  OverlayEntry? _translateOverlayEntry;

  OverlayState? _contextOverlayState;
  OverlayState? _transOverlayState;
  
  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }


  void _showContextMenu(BuildContext context, PdfTextSelectionChangedDetails details) async {

    _contextOverlayState = Overlay.of(context)!;

    _contextOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy + 10,
        left: details.globalSelectedRegion!.bottomLeft.dx,

        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.14),
                blurRadius: 2,
                offset: Offset(0, 0),
              ),

              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.12),
                blurRadius: 2,
                offset: Offset(0, 2),
              ),

              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ), // BoxDecoration

          constraints: BoxConstraints.tightFor(
            width: 100, height: 90),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              Container(
                height: 30,
                width: 100,
                child: RawMaterialButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: details.selectedText));
                    print('Text copied to clipboard: ' + details.selectedText.toString());
                    //savedWordWithTranslationToFile(bookFile.toString(), details.selectedText.toString());
                    _pdfViewerController.clearSelection();
                  },

                  child: Text('Remember Word', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400)),
                ),
              ),

              Container(
                height: 30,
                width: 100,
                child: RawMaterialButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: details.selectedText));
                    print('Text copied to clipboard: ' + details.selectedText.toString());
                    //saveWordWithTranslationToFile(bookFile.toString(), details.selectedText.toString());
                    _pdfViewerController.clearSelection();
                  },

                  child: Text('Listen', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400)),
                ),
              ),
            ]
          ), // Container
        ),
      ),
    ); // OverlayEntry
    _contextOverlayState!.insert(_contextOverlayEntry!);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        
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
        initialZoomLevel: 1,

        onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
          if (details.selectedText == null && _contextOverlayEntry != null) {
            _contextOverlayEntry!.remove();
            _contextOverlayEntry = null;
          }

          if (details.selectedText != null && _contextOverlayEntry == null) {
            _showContextMenu(context, details);
          }
 
          /*
          if (details.selectedText == null && _translateOverlayEntry != null) {
            _translateOverlayEntry!.remove();
            _translate
          }

          if (details.selectedText != null && _translateOverlayEntry == null) {
            _showTranslationOverlay(context, details);
          }
            */
        },
        controller: _pdfViewerController,
      ),
    );
  }
}
