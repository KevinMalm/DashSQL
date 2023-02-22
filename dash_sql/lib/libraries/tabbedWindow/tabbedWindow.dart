

import 'package:dash_sql/data/connectionArtifacts/queryData.dart';
import 'package:dash_sql/data/databaseConnection.dart';
import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/libraries/tabbedWindow/tabbedWindowController.dart';
import 'package:dash_sql/managers/databaseConnectionManager.dart';
import 'package:dash_sql/managers/queryResultsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TabbedWindow extends StatefulWidget {

  final TabbedWindowController controller;
  Widget?                      emptyPrompt;

  TabbedWindow({
    required this.controller,
    super.key
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
    ------------------------------------------------------------------------------------------------------
  */


  Widget buildAddHeaderButton(context) {
    return SizedBox(
      //height: tabBarHeight, width: tabBarHeight,
      child: ElevatedButton(
        onPressed: () => widget.controller.newTabBuilder(context),
        child:     const FittedBox(child: Icon(Icons.add)),
      ),
    );
  }

  /*
    ------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
  */

  void enabledTitleEditing(int i) {
    titleController.text = widget.controller.pages[i].title??"";
    setState(() => editingIndex = i);
  }

  void doneEditing() {
    if(editingIndex == null) { return; }
    setState(() {
      widget.controller.pages[editingIndex!].title = (titleController.text.isEmpty ? null : titleController.text);
      editingIndex = null;
    });
  }


  void removeTab({required int index}) {
    activeIndex--;
    widget.controller.removeTab(index: index);
  }

  Widget buildHeaderInstance({required int i}) {
    late Widget          titleRow;
    TabbedWindowInstance inst     = widget.controller.pages[i];

    Widget titleBar = ((editingIndex == i) ? 
            TextField(controller: titleController, onEditingComplete: doneEditing,)
            : Text(inst.title??"Tab ${i + 1}", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontWeight: (activeIndex == i ? FontWeight.bold : FontWeight.w300)),)
    );


    if(activeIndex == i) {
      titleRow = Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: titleBar),
                    (inst.allowDelete ?
                      GestureDetector(onTap: () => removeTab(index: i), child: const Icon(Icons.delete, color: Colors.red, )) :
                      GestureDetector(onTap: () {},                     child: const Icon(Icons.delete, color: Colors.grey,))
                    )
                  ],
                );
    } else {
      titleRow = titleBar;
    }


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
    ------------------------------------------------------------------------------------------------------
  */
  
  Widget buildHeader(context) {
    List<Widget> titles = List<Widget>.generate(widget.controller.pages.length, (index) => buildHeaderInstance(i: index));
    if(titles.isEmpty) { titles.add( const Spacer() ); }
    titles.add( buildAddHeaderButton(context) );

    return SizedBox(
      height: tabBarHeight,
      child: Row(
        children: titles
      ),
    );
  }

  /*
    ------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
  */
  
  KeyEventResult keyboardCallbacks(FocusNode node, RawKeyEvent event) {
    if(event.isKeyPressed(LogicalKeyboardKey.arrowRight) && (event.isControlPressed)) {
      /* ---- GO TO PREV TAB ---- */
      if(activeIndex < (widget.controller.pages.length - 1)) {
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

  /*
    ------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
  */
  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream:  widget.controller.stream.stream,
      builder: (context, snapshot) {
        return Column(children: [
          buildHeader(context),
            (
              widget.controller.pages.isEmpty ? 
                Expanded(child: Center(child: widget.emptyPrompt ?? const Text("No Tabs open", style: TextStyle(color: Colors.white),))) :
                buildBody(context, body: widget.controller.pages[activeIndex].child)
            )
          ]
        );
      }
    );
  }





  void runQuery() async {
    late QueryResult result;
    DatabaseConnection conn = DatabaseConnectionManager.getInstance().connections[1];

    result = await conn.query(query: "SELECT * FROM doctor.node");
    QueryResultsManager.getInstance().clearQueryResults();

    await Future.delayed(const Duration(seconds: 1));
    QueryResultsManager.getInstance().prepQueryResult(tabName: "ABC");

    return;
  }
}