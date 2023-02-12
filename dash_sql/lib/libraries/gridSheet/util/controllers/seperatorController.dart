


import 'package:dash_sql/libraries/gridSheet/util/controllers/gridSheetController.dart';
import 'package:flutter/material.dart';


/// Created by each instance of [Separator]
/// Interfaces with the global GridView Controller to resize each colum
class SeparatorController {
  final int index;
  final GridSheetController parentController;

  const SeparatorController({required this.index, required this.parentController});

  void onPanUpdate(context, {required DragUpdateDetails details}) {
    parentController.requestResize(index: index, drag: details.delta);
  }
}