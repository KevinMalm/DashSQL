import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/libraries/tabbedWindow/tabbedWindow.dart';

import 'package:flutter/material.dart';

import 'editorNoteController.dart';


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


  Widget buildHeaderSpacer() => const SizedBox(width: 5,);

  Widget buildHeaderButton({required void Function() callback, required IconData icon, required String tooltip}) {
    return Tooltip(
      message: tooltip,
      child: ElevatedButton(
        onPressed: callback,
        style:     ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(DashColorLibrary.bluePrimary)),
        child:     Icon(icon)
      ),
    );
  }

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
    return StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return SizedBox(
          height: headerHeight,
          child: Row(children: [
            buildHeaderButton(          // open file
              callback: widget.controller.openFile,
              icon: Icons.folder,
              tooltip: 'Open File'
            ),  
            buildHeaderButton(          // save file
              callback: widget.controller.saveFile,
              icon: Icons.save,
              tooltip: 'Save'
            ),
            buildHeaderButton(          // save file
              callback: widget.controller.saveFile,
              icon: Icons.save_as,
              tooltip: 'Save As'
            ),
            buildHeaderSpacer(),
            buildHeaderButton(          // undo from stack
              callback: widget.controller.undoAction,
              icon: Icons.undo,
              tooltip: 'Undo Action'
            ),  
            buildHeaderButton(          // redo from stack
              callback: widget.controller.redoAction,
              icon: Icons.redo,
              tooltip: 'Redo Action'
            ),
            buildHeaderSpacer(),
            ElevatedButton(onPressed: (){}, child: const Icon(Icons.find_in_page)),  // query 
            buildHeaderSpacer(),
            buildHeaderButton(          // add new block
              callback: widget.controller.addNewBlock,
              icon: Icons.add_box,
              tooltip: 'Add Notepad'
            ),  
            buildHeaderButton(          // duplicate block
              callback: widget.controller.duplicateBlock,
              icon: Icons.copy,
              tooltip: 'Duplicate Notepad'
            ),
            buildHeaderButton(          // delete block
              callback: widget.controller.deletingBlock,
              icon: Icons.delete,
              tooltip: 'Delete Notepad'
            ),
            buildHeaderSpacer(),
            buildHeaderButton(          // run all
              callback: widget.controller.runAllBlocks,
              icon: Icons.playlist_play,
              tooltip: 'Run Notebook'
            ),
            buildHeaderButton(          // read only mode
              callback: widget.controller.toggleReadOnlyMode,
              icon: Icons.lock,
              tooltip: 'Set Read-only'
            ),
            buildHeaderButton(          // commit
              callback: widget.controller.commitSession,
              icon: Icons.upload,
              tooltip: 'Commit'
            ),
          ]),
        );
      }
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
