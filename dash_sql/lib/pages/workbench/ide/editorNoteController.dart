

import 'dart:async';

import 'package:dash_sql/data/databaseConnection.dart';
import 'package:dash_sql/libraries/popupLibrary.dart';
import 'package:dash_sql/libraries/tabbedWindow/tabbedWindowController.dart';
import 'package:dash_sql/managers/databaseConnectionManager.dart';
import 'package:dash_sql/pages/workbench/ide/widgets/dataComponents/overviewPanel.dart';
import 'package:dash_sql/pages/workbench/ide/widgets/noteEditor/noteEditor.dart';
import 'package:dash_sql/pages/workbench/ide/widgets/noteEditor/noteEditorController.dart';
import 'package:flutter/material.dart';

class EditorNoteController extends TabbedWindowController {
  
  List<EditorNotePadController> controllers  = <EditorNotePadController>[];
  final StreamController        headerStream = StreamController<Object>();

  EditorNoteController() {
    onPageChange = pageChange;
    pages.add(
      TabbedWindowInstance(
        child: const DatabaseOverviewPanel(),
        title: "Overview",
        allowDelete: false
      )
    );
  }

  /*
    ***********************************************************************************************

    ***********************************************************************************************
  */
  void pageChange(int i) {

  }
  /*
    ***********************************************************************************************

    ***********************************************************************************************
  */
  
  @override
  Future<TabbedWindowInstance?> tabBuilder({required context}) async {
    /* --- Get Database Connection --- */
    List<DatabaseConnection>  connectedInstances = DatabaseConnectionManager.getInstance().getConnectedInstances();
    int?                      selectedResult;
    if(connectedInstances.length != 1) {
      selectedResult = await DashPopUpLibrary.getUserSelection(context,
                                                title:         const Text("Select Database Connection"),
                                                noOptionError: const Text("No Databases Connected"),
                                                options:       List<Widget>.generate(
                                                                    connectedInstances.length,
                                                                    (index) => Text(connectedInstances[index].name)
                                                                )
                                              );
    } else {
      selectedResult = 0;
    }
    if(selectedResult == null) { return null; }  
    /* --- Build new Window --- */
    controllers.add(EditorNotePadController(connection: connectedInstances[selectedResult]));
    return TabbedWindowInstance(child: NoteEditor(controller: controllers.last,));
  }
  
  /*
    ***********************************************************************************************

    ***********************************************************************************************
  */
  void openFile() {
    print("Opening File");
  }

  void saveFile() {
    print("Saving File");
  }


  void undoAction() {
    print("Undo-ing");
  }

  void redoAction() {
    print("Redo-ing");
  }

  void duplicateBlock() {
    print("Duplicating Block");
  }

  void addNewBlock() {
    print("Adding new Block");
  }

  void deletingBlock() {
    print("Deleting Block");
  }

  void runAllBlocks() {
    print("Running all");
  }

  void toggleReadOnlyMode() {
    print("Setting Read Only mode");
  }

  void commitSession() {
    print("Committing...");
  }

  /*
    ***********************************************************************************************

    ***********************************************************************************************
  */
}