



import 'dart:async';

import 'package:dash_sql/libraries/gridSheet/gridData.dart';
import 'package:flutter/widgets.dart';




class GridSheetController {
  final StreamController stream   = StreamController<Object>();
  final double           minWidth = 10;
  final double           maxWidth = 300;
  GridData               data;
  late List<double>      widths;
  late double            totalWidth;
  late List<List<bool>>  selectedMatrix;
  bool                   allSelected = false;

  bool getSelectedState(int i, int j) => selectedMatrix[i][j];


  double clampWidth(double f) { 
    if(f < minWidth) { return minWidth; }
    if(f > maxWidth) { return maxWidth; }
    return f;
  }

  GridSheetController({required this.data}) {
    totalWidth = 0;
    /* --------------------------------------------- */
    widths = List<double>.generate(
      data.columns, (index){
        double individualWidth = data.titles[index].length * 25;
        totalWidth += individualWidth;
        return individualWidth;
      });
    /* --------------------------------------------- */
    selectedMatrix = List<List<bool>>.generate(
                      data.rows, (index) => List<bool>.generate(
                                                data.columns, (index) => false
                      ));
  }

  double getColumnWidth(int index) => widths[index];

  void requestResize({required int index, required Offset drag}) {
    double currentSize = widths[index];
    double appliedSize = currentSize + drag.dx;
    appliedSize        = clampWidth(appliedSize);
    widths[index]      = appliedSize;
    stream.add(this);
    return;
  }

  void clearSelection({bool state = false}) {
    selectedMatrix.forEach((element) { for(int j = 0; j < data.columns; j++) { element[j] = state; }});
  }

  /// Called when a single cell is selected. 
  /// Clears all other selected states. 
  /// Toggles state of request
  void singleActionToggleSelection({required int i, required int j}) {
    bool state = selectedMatrix[i][j];
    clearSelection();
    selectedMatrix[i][j] = !state;
    stream.add(this);
  }

  void setDragSelected({required int i, required int j}) {
    selectedMatrix[i][j] = true;
    stream.add(this);
  }

  void selectRow({required int i}) {
    clearSelection();
    for(int j = 0; j < data.columns; j++) { selectedMatrix[i][j] = true; }
    stream.add(this);
  }
  void selectColumn({required int j}) {
    clearSelection();
    selectedMatrix.forEach((element) { element[j] = true; });
    stream.add(this);
  }

  void selectAll() {
    allSelected = !allSelected;
    clearSelection(state: allSelected);
    stream.add(this);
  }
}
