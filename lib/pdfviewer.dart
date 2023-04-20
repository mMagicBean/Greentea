import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/services.dart';
import 'handle_saved_words.dart';
import 'translate_util.dart';
import 'flashcard_page.dart';


class Book extends StatefulWidget {
  final File bookPath;
  
  Book(this.bookPath);
     
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

  late SavedWords sw;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    print("${widget.bookPath}");
    super.initState();
  }
 
  void _showContextMenu(BuildContext context, PdfTextSelectionChangedDetails details) async {
    var translationText = await quickTranslation(details.selectedText!);
    
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
                    saveWordWithTranslation(widget.bookPath.toString(), details.selectedText.toString());
                    _pdfViewerController.clearSelection();
                  },

                  child: Text('Save Word', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400)),
                ),
              ),
              
              Container(
                height: 30,
                width: 100,
                
                child: RawMaterialButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: details.selectedText));
                    print('Text copied to clipboard: ' + details.selectedText.toString());
                    //saveWordWithTranslation(bookFile.toString(), details.selectedText.toString());
                    _pdfViewerController.clearSelection();
                  },
                  
                  child: Text('${translationText}', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w400)),
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
          ), // IconButton

          Padding(
            padding:EdgeInsets.only(right: 50.0),

            child: GestureDetector(
              onTap: () {
                final file = File(createSavePathFromBookPath(widget.bookPath.path));

                print('${file.path} - ${file.toString()}');

                if (!file.existsSync()) {
                  Widget okButton = TextButton(child: Text("Ok"), onPressed: () {},);
                  
                  AlertDialog noSavesAlert = AlertDialog(
                    title: const Text('No Saved Words'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('You need to save words'),
                          Text('to use flashcards'),
                          okButton,
                        ],
                      ),
                    ), 
                  );
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => noSavesAlert),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Flashcard(file.toString())),
                  ); 
                }
              },

              child: Icon(
                Icons.videogame_asset,
                size: 26.0,
              ),
            ), // GestureDetector
          ), // Padding
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
        },
        
        controller: _pdfViewerController,
      ),
    );
  }
}
