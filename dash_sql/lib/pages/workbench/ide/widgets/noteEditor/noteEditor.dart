

import 'package:dash_sql/pages/workbench/ide/widgets/noteEditor/noteEditorController.dart';
import 'package:flutter/material.dart';

class NoteEditor extends StatefulWidget {
  
  final EditorNotePadController controller;

  const NoteEditor({
    super.key,
    required this.controller
  });

  @override
  State<StatefulWidget> createState() => _NoteEditorState();

}


class _NoteEditorState extends State<NoteEditor>{


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