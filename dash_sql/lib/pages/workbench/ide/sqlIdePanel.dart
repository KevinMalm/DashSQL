import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/pages/workbench/ide/editorNotepad/editorNoteController.dart';
import 'package:dash_sql/pages/workbench/ide/editorNotepad/editorNotePad.dart';
import 'package:dash_sql/pages/workbench/ide/editorNotepad/tabbedWindow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';


class SqlIdePanel extends StatefulWidget {

  late EditorNoteController controller;

  SqlIdePanel({super.key}) {
    controller = EditorNoteController();
  }

  @override
  State<StatefulWidget> createState() => _SqlIdePanelState();

}


class _SqlIdePanelState extends State<SqlIdePanel> {
  final double headerHeight = 32;

  Widget buildHeader(context) {
    /// Buttons:
    /// - Open
    /// - Save
    /// - Query
    /// - Insert Block
    /// - Copy Block 
    /// - Delete Block 
    /// - Query all
    /// - Set Read Only
    /// 
    return Container(
      height: headerHeight,
      child: Row(children: [
        ElevatedButton(onPressed: (){}, child: const Icon(Icons.folder)),        // open file
        ElevatedButton(onPressed: (){}, child: const Icon(Icons.save)),          // save as file
        ElevatedButton(onPressed: (){}, child: const Icon(Icons.find_in_page)),  // query 

        ElevatedButton(onPressed: (){}, child: const Icon(Icons.undo)),          // undo from stack
        ElevatedButton(onPressed: (){}, child: const Icon(Icons.redo)),          // redo from stack

        ElevatedButton(onPressed: (){}, child: const Icon(Icons.add_box)),       // add new box 
        ElevatedButton(onPressed: (){}, child: const Icon(Icons.copy)),          // duplicate block
        ElevatedButton(onPressed: (){}, child: const Icon(Icons.delete)),        // delete block 

        ElevatedButton(onPressed: (){}, child: const Icon(Icons.playlist_play)), // run all
        ElevatedButton(onPressed: (){}, child: const Icon(Icons.lock)),          // read only mode
        ElevatedButton(onPressed: (){}, child: const Icon(Icons.upload)),        // commit
      ]),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(color: DashColorLibrary.accentDark,
      child: Column(
        children: [
          buildHeader(context),
          Expanded(
            child: TabbedWindow(
              controller: widget.controller,
            ),
          ),
        ],
      ) 
    );
  }
}
