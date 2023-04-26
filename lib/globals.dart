import 'package:dolphinsr_dart/dolphinsr_dart.dart';
import 'package:flutter/material.dart';

bool isLookupButtonPressed = false;
bool isMenuVisible         = true;

String currentSavePath     = ""; 

late int currWordIndex;

DolphinSR dolphin = DolphinSR();

var appDir;

bool selectMode = false;

List<String> selected = [];
List<Widget> widgetList = []; // dynamic delete button widget (the list should always have size of 1)
