


import 'package:dash_sql/data/databaseConnection.dart';
import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/pages/workbench/ide/editorNotepad/editorNoteController.dart';
import 'package:dash_sql/pages/workbench/ide/editorNotepad/editorNoteInstance.dart';
import 'package:flutter/material.dart';

class EditorNotePad extends StatefulWidget {

  EditorNoteSubController  controller;


  EditorNotePad({
    super.key,
    required this.controller
  }) {
    controller.addNewNotePadInstance();
  }


  
  @override
  State<StatefulWidget> createState() => _EditorNotePadState();

}

class _EditorNotePadState extends State<EditorNotePad> {


  /*
    ------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------
  */




  /*
    ------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------
  */

  void saveAsFile() {
    print("Saving as File");
  }

  void queryInPage() {
    print("Querying File");
  }

  void undoAction() {
    print("Undoing");
  }

  void redoAction() {
    print("Re-do whoops");
  }


  void addNewBlock() {
    print("Adding new Block");
  }

  void duplicateActiveBlock() {
    print("Duplicating Active Block");
  }

  void deleteActiveBlock() {
    print("Deleting Active Block");
  }


  void runAllBlocks() {
    print("Running all Blocks");
  }

  void setReadOnly(bool state) {
    print("Setting read-only to $state");
  }


  void commit() {
    print("Saving as File");
  }


  /*
    ------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------
  */

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
            onReorder: (i,j) => widget.controller.reorderList(i, j, setState),
            buildDefaultDragHandles: false,
            children: widget.controller.instances,
            proxyDecorator: proxyDecorator,
          );
  }
  
  
  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          elevation: 0,
          color: Colors.transparent,
          child: child,
        );
      },
      child: child,
    );
  }


}