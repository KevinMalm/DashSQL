

import 'package:dash_sql/data/databaseConnection.dart';
import 'package:dash_sql/libraries/popupLibrary.dart';
import 'package:dash_sql/managers/databaseConnectionManager.dart';
import 'package:dash_sql/pages/workbench/ide/editorNotepad/editorNoteInstance.dart';
import 'package:flutter/material.dart';
import 'package:rich_text_controller/rich_text_controller.dart';




class EditorNoteSubController {

  final Map<RegExp, TextStyle> patternUser = {
    RegExp(r"\B@[a-zA-Z0-9]+\b"):
        const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
      RegExp(r"SELECT|FROM|GROUP BY|WHERE|ORDER BY|AND|DISTINCT"):
        const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
      RegExp(r"DELETE|TRUNCATE"):
        const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
  };


  List<RichTextController>       subControllers = <RichTextController>[];
  final List<EditorNoteInstance> instances      = <EditorNoteInstance>[];
  final DatabaseConnection       connection;

  EditorNoteSubController({required this.connection});

  void addNewController({required int index}) {
    subControllers.insert(index, RichTextController(
      patternMatchMap: patternUser,
      onMatch: (List<String> values) {  },
      deleteOnBack: true 
    ));
  }

  /// Creates a new Notepad Block
  /// If [i] is provided, new block will be created at given index. Else added to the end
  /// 
  /// Inputs:
  /// - i?: requested index. 
  /// ------------------------------------------------------------------------------------------------
  void addNewNotePadInstance({int? i}) {
    int                index        = i??instances.length;
    addNewController(index: index);
    EditorNoteInstance thisInstance = EditorNoteInstance(
                                              key:            GlobalKey(),
                                              controller:     subControllers[index],
                                              connection:     connection,
                                              index:          instances.length,
                                              insertCallback: addNewNotePadInstance
                                            );
    instances.insert(index, thisInstance);
    if(index < (instances.length - 1)) {
      /* --- CASE: there is a block below this --- */
      instances[index].next     = instances[index + 1];
      instances[index + 1].prev = instances[index];
    }

    if(index > 0) {
      /* --- CASE: there is a block above this --- */
      instances[index].prev     = instances[index - 1];
      instances[index - 1].next = instances[index];
    }
    for(int i = 0; i < instances.length; i++) { instances[i].index = i; }
  }

  /// Re=orders list on user request
  /// 
  /// Inputs:
  /// - oldIndex: reference to object being moved
  /// - newIndex: requested new index of child
  /// ------------------------------------------------------------------------------------------------
  void reorderList(int oldIndex, int newIndex, Function setState) {
    print("Moving $oldIndex to $newIndex");
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final items = instances.removeAt(oldIndex);
      instances.insert(newIndex, items);
      for(int i = 0; i < instances.length; i++) { instances[i].index = i; }
    });
  }

  void requestNextFocus() {

  }

  void requestPrevFocus() {

  }

}


class EditorNoteController {
  List<EditorNoteSubController> subControllers = <EditorNoteSubController>[];


  Future<EditorNoteSubController?> addNewController(context) async {
    List<DatabaseConnection>  connectedInstances = await DatabaseConnectionManager.getInstance().getConnectedInstances();
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
    subControllers.add(
      EditorNoteSubController(connection: connectedInstances[selectedResult])
    );
    return subControllers.last;
  }
}