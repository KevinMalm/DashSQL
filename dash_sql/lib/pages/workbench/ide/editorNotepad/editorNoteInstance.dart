


import 'package:dash_sql/data/databaseConnection.dart';
import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/pages/workbench/ide/editorNotepad/editorNoteController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

class EditorNoteInstance extends StatefulWidget {

  late bool      isFocused = false;
  late FocusNode focusNode;
  /* ------------------------------------ */
  EditorNoteInstance? prev;
  EditorNoteInstance? next;
  /* ------------------------------------ */
  int                           index;
  void Function({int? i})       insertCallback;
  /* ------------------------------------ */
  TextEditingController       controller;
  DatabaseConnection          connection;
  
  EditorNoteInstance({
    super.key,
    required this.controller,
    required this.connection,
    required this.index,
    required this.insertCallback
  });

  void requestFocus() { focusNode.requestFocus(); }


  @override
  State<StatefulWidget> createState() => _EditorNoteInstanceState();

}

class _EditorNoteInstanceState extends State<EditorNoteInstance> {

  String lineCounterStr = '1';
  int    lineCounter    = 1;

  void requestFocus() { setState(() => widget.focusNode.requestFocus()); }

  /// Called inside Widget and runs SQL statement in the _controller
  ///  
  void executeStatement() async {
    print("Executing: ${widget.controller.text}");
    requestFocus();
    
    QueryResult result = await widget.connection.query(query: widget.controller.text);

    return;
  }

  /// Adds new SQL block under this widget
  /// 
  void insertNextBlock() {
    widget.insertCallback(i: widget.index + 1);
  }

  @override
  void initState(){ 
    super.initState();
    widget.focusNode = FocusNode();
    widget.focusNode.addListener(() {
      setState(() {
        widget.isFocused = widget.focusNode.hasFocus;
      });
    });
  }


  void insertText(String value) {
    final String     newText  = widget.controller.text.replaceRange(widget.controller.selection.start, widget.controller.selection.end, value);
    TextEditingValue newValue = TextEditingValue(
                                  text: newText, selection: TextSelection.collapsed(offset: widget.controller.selection.baseOffset + 1)
                                );
      setState(() => widget.controller.value = newValue);
  }

  KeyEventResult keyboardCallbacks(FocusNode node, RawKeyEvent event) {
    if(event.isKeyPressed(LogicalKeyboardKey.tab) && (event.isShiftPressed == false)) {
      insertText('\t');
      return KeyEventResult.handled;
    }
    if(event.isKeyPressed(LogicalKeyboardKey.tab) && (event.isShiftPressed == true) && (event.isControlPressed == false)) {
      /* ---- GO TO NEXT ---- */
      if(widget.next != null) { widget.next!.requestFocus(); }
      return KeyEventResult.handled;
    }
    if(event.isKeyPressed(LogicalKeyboardKey.tab) && (event.isShiftPressed == true) && (event.isControlPressed)) {
      /* ---- GO TO PREV ---- */
      if(widget.prev != null) { widget.prev!.requestFocus(); }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }



  Widget buildExecuteButton(context, {double size = 18}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: size, width: size,
            child: GestureDetector(
              onTap: executeStatement,
              child: const MouseRegion(
                cursor: SystemMouseCursors.click,
                child: FittedBox(child: Icon(Icons.play_arrow, color: Colors.green,)),
              ),
            ),
          ),
          SizedBox(
            width: size,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FittedBox(
                child: ReorderableDragStartListener(
                  index: widget.index,
                  child: Icon(Icons.drag_handle, color: DashColorLibrary.bluePrimary,))),
            ),
          ),
          SizedBox(height: size,)
        ],
      ),
    );
  }
  Widget buildMoreOptionsButton(context, {double size = 18}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: size, width: size,
        child: GestureDetector(
          onTap: insertNextBlock,
          child: const MouseRegion(
            cursor: SystemMouseCursors.click,
            child: FittedBox(child: Icon(Icons.add, color: Colors.white,)),
          ),
        ),
      ),
    );
  }

  Widget buildRowNumber(context) {
    return SizedBox(width: 20);//,child: Text(lineCounterStr),);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: ( widget.isFocused ? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0) : const EdgeInsets.only(top: 2, bottom: 0, left: 16.0, right: 16.0)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: (widget.isFocused ? DashColorLibrary.backgroundLight : DashColorLibrary.backgroundDark),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildExecuteButton(context),
            const SizedBox(width: 4.0,),
            buildRowNumber(context),
            const SizedBox(width: 4.0,),
            Expanded(
              child: Focus(
                onKey: keyboardCallbacks,
                child: TextField(
                  autofillHints: ['hello', 'world'],
                  focusNode:    widget.focusNode,
                  keyboardType: TextInputType.multiline,
                  controller:   widget.controller,
                  onChanged:    (str) { if(str[str.length - 1] == '\n') { lineCounter += 1; setState(() => lineCounterStr += '\n$lineCounter'); }},
                  maxLines:     null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 4.0,),
            buildMoreOptionsButton(context),
          ],
        ),
      ),
    );
  }

}


