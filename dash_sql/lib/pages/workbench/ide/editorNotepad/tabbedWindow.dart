import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/pages/workbench/ide/editorNotepad/editorNoteController.dart';
import 'package:dash_sql/pages/workbench/ide/editorNotepad/editorNotePad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TabbedWindowInstance {
  String? name;
  Widget  child;

  TabbedWindowInstance({
    required this.child,
    this.name
  });
}

class TabbedWindow extends StatefulWidget {

  EditorNoteController       controller;
  List<TabbedWindowInstance> children    = <TabbedWindowInstance>[];

  TabbedWindow({
    super.key,
    required this.controller
  });

  @override
  State<StatefulWidget> createState() => _TabbedWindowState();


}

class _TabbedWindowState extends State<TabbedWindow> {
  final double                tabBarHeight    = 30;
  final TextEditingController titleController = TextEditingController();

  int  activeIndex = 0;
  int? editingIndex;


  /*
    ------------------------------------------------------------------------------------------------------
    Builds Text(name) + Delete Button 
    ------------------------------------------------------------------------------------------------------
  */
  void enabledTitleEditing(int i) {
    titleController.text = widget.children[i].name??"";
    setState(() => editingIndex = i);
  }

  void doneEditing() {
    if(editingIndex == null) { return; }
    setState(() {
      widget.children[editingIndex!].name = (titleController.text.isEmpty ? null : titleController.text);
      editingIndex = null;
    });
  }

  Widget buildHeaderInstance({required int i}) {
    TabbedWindowInstance inst = widget.children[i];

    Widget titleBar = ((editingIndex == i) ? 
            Expanded(child: TextField(controller: titleController, onEditingComplete: doneEditing,))
            : Text(inst.name??"Tab ${i + 1}", style: TextStyle(color: Colors.white, fontWeight: (activeIndex == i ? FontWeight.bold : FontWeight.w300)),)
    );

    Widget titleRow = Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          titleBar,
                          GestureDetector(onTap: (){print("Deletiing $i"); }, child: Icon(Icons.delete))
                        ],
                      );

    return Expanded(
      flex: (i == activeIndex ? 3 : 1),
      child: GestureDetector(
          onTap: () { print("Tap!"); setState(() => activeIndex = i); },
          onLongPress: () { print("Double Tap!"); enabledTitleEditing(i); },
          child: Container(
            color: (i == activeIndex ? DashColorLibrary.backgroundLight : DashColorLibrary.backgroundDark),
            child: titleRow)),
    );
  }

  /*
    ------------------------------------------------------------------------------------------------------
    Does: Adds new Instance
    ------------------------------------------------------------------------------------------------------
  */

  void addNewNotePad(context) async {
    EditorNoteSubController? newController = await widget.controller.addNewController(context);
    if(newController == null) { return; }
    TabbedWindowInstance     newInstance   = TabbedWindowInstance(child: EditorNotePad(controller: newController,));
    setState( () => widget.children.add(newInstance));
  }

  Widget buildAddHeaderButton(context) {
    return SizedBox(
      //height: tabBarHeight, width: tabBarHeight,
      child: ElevatedButton(
        onPressed: () => addNewNotePad(context),
        child:     const FittedBox(child: Icon(Icons.add)),
      ),
    );
  }

  /*
    ------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------
  */

  Widget buildHeader(context) {
    List<Widget> titles = List<Widget>.generate(widget.children.length, (index) => buildHeaderInstance(i: index));
    if(titles.isEmpty) { titles.add( const Spacer() ); }
    titles.add( buildAddHeaderButton(context) );

    return SizedBox(
      height: tabBarHeight,
      child: Row(
        children: titles
      ),
    );
  }

  KeyEventResult keyboardCallbacks(FocusNode node, RawKeyEvent event) {
    if(event.isKeyPressed(LogicalKeyboardKey.arrowRight) && (event.isControlPressed)) {
      /* ---- GO TO PREV TAB ---- */
      if(activeIndex < (widget.children.length - 1)) {
        setState(() => activeIndex++ );
      }
      return KeyEventResult.handled;
    }
    if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft) && (event.isControlPressed)) {
      /* ---- GO TO PREV TAB ---- */
      if(activeIndex > 0) {
        setState(() => activeIndex-- );
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Widget buildBody(context, {required Widget body}) {
    return Expanded(
      child: Focus(
        onKey: keyboardCallbacks,
        child: body)
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader(context),
        (
          widget.children.isEmpty ? 
            const Expanded(child: Center(child: Text("No Notepads open", style: TextStyle(color: Colors.white),))) :
            buildBody(context, body: widget.children[activeIndex].child)
        )
        
      ],
    );
  }

}