




import 'package:dash_sql/libraries/gridSheet/util/controllers/gridSheetController.dart';
import 'package:dash_sql/libraries/gridSheet/util/controllers/seperatorController.dart';
import 'package:flutter/material.dart';

class ColumnSeparator extends StatefulWidget {

  final int                 index;
  final double              height;
  final double              width;
  final GridSheetController parentController;

  const ColumnSeparator({
    super.key,
    required this.index, required this.height, required this.parentController,
    this.width = 1
  });

  @override
  State<StatefulWidget> createState() => _ColumnSeparatorState();

}



class _ColumnSeparatorState extends State<ColumnSeparator> {

  late final SeparatorController controller;

  @override
  void initState() {
    super.initState();
    controller = SeparatorController(index: widget.index, parentController: widget.parentController);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          child: Container(
            color: Colors.black,
            width:  widget.width,
            height: widget.height,
          ),
        ),
        onPanUpdate: (details) => controller.onPanUpdate(context, details: details),
      );
  }
  
}