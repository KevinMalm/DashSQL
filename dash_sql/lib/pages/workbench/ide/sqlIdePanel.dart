import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class SqlIdePanel extends StatefulWidget {

  const SqlIdePanel({super.key});

  @override
  State<StatefulWidget> createState() => _SqlIdePanelState();

}


class _SqlIdePanelState extends State<SqlIdePanel> {
  QuillController _controller = QuillController.basic();
  
  @override
  Widget build(BuildContext context) {
    return Container(color: DashColorLibrary.accentDark,
      child: Column(
          children: [
            QuillToolbar.basic(controller: _controller),
            Expanded(
              child: Container(
                child: QuillEditor.basic(
                  controller: _controller,
                  readOnly: false, // true for view only mode
                ),
              ),
            )
          ],
        ),
    );
  }

  
}