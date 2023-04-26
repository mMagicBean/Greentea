import 'dart:io';
import 'package:translator/translator.dart';


Future<String> quickTranslation(String word) async {
  GoogleTranslator t = GoogleTranslator();

  Translation translation = await t.translate(word);

  return translation.text;
}
