


import 'package:dash_sql/libraries/gridSheet/gridData.dart';
import 'package:dash_sql/libraries/gridSheet/gridDecorator.dart';
import 'package:dash_sql/libraries/gridSheet/util/controllers/gridSheetController.dart';
import 'package:dash_sql/libraries/gridSheet/util/gridIterators.dart';
import 'package:dash_sql/libraries/gridSheet/util/seperator.dart';
import 'package:flutter/material.dart';

class GridSheet extends StatefulWidget {

  final GridData data;
  late GridSheetDecorator decorator;

  GridSheet({
    super.key,
    required this.data,
    GridSheetDecorator? decorator
  }) {
    this.decorator = decorator??GridSheetDecorator();
  }

  @override
  State<StatefulWidget> createState() => _GridSheetState();


}


class _GridSheetState extends State<GridSheet> {
  late       GridSheetController _controller;
  late final double              _titleHeight;
  late final double              _divHeight;
  late final double              _rowHeight;
  late final double              _height;

  @override
  void initState() {
    super.initState();
    _controller  = GridSheetController(data: widget.data);
    _divHeight   = widget.decorator.dividerHeight;
    _titleHeight = widget.decorator.titleHeight;
    _rowHeight   = widget.decorator.rowHeight;
    _height      = (widget.data.rows * _rowHeight) + (_titleHeight) + (widget.data.rows + 1) * _divHeight;
  }




  Widget buildRowDiv() {
    return Container(height: _divHeight, color: Colors.grey,);
  }
  Widget buildColumnDiv() {
    return Container(width: _divHeight, height: _height, color: Colors.grey,);
  }

  Widget buildCell(context, {required String? value, required int rowI, required int columnJ}) {
    bool isSelected = _controller.getSelectedState(rowI, columnJ);
    return GestureDetector(
      onTap: () => _controller.singleActionToggleSelection(i: rowI, j: columnJ),
      child: MouseRegion(
        child: Container(
          height: _rowHeight,
          color: (
            isSelected ? widget.decorator.selected /// CASE: cell is selected
            :
            (rowI%2 == 1) ? (
              (columnJ%2 == 1) ?
                widget.decorator.oddRowOddColumn :  /// CASE: odd row & odd column
                widget.decorator.oddRow   /// CASE: odd row & even column
            ) : (
              (columnJ%2 == 1) ?
                widget.decorator.evenRowOddColumn : /// CASE: even row & odd column
                widget.decorator.evenRow  /// CASE: even row & even column
            )
          ),
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(value??"NULL", style: (isSelected ? widget.decorator.selectedStyle : widget.decorator.dataStyle),),
          ),
        ),
      ),
    );
  }

  Widget buildHeaderCell(context, {required String value, required int columnJ}) {
    return GestureDetector(
      onTap: () => _controller.selectColumn(j: columnJ),
      child: Container(
        width: double.infinity,
        height: _titleHeight,
        decoration: (
          (columnJ % 2 == 1) ? 
          widget.decorator.oddHeaderDecorator : 
          widget.decorator.headerDecorator
        ),
        child: Text(value, style: widget.decorator.headerStyle,),
      ),
    );
  }

  Widget buildColumn(context, {required GridColumnIterable iter, required int columnJ}) {
    int i = 0;
    List<Widget>       values = <Widget>[
      buildHeaderCell(context, value: widget.data.titles[iter.columnIndex],  columnJ: columnJ)
    ];
    values.add(buildRowDiv());
    for(var data in iter) {
      values.add(buildCell(context, value: data, rowI: i++,  columnJ: columnJ));
      values.add(buildRowDiv());
    }
    return SizedBox(
      width:  _controller.getColumnWidth(columnJ),
      height: _height,
      child:  Column(mainAxisAlignment: MainAxisAlignment.start, children: values,));
  }

  Widget buildIndexColumn(context, {required GridColumnIterable iter}) {
    return SizedBox(
      height: _height,
      child: Column(
        children: List<Widget>.generate(iter.length + 1, (index) {
          if(index == 0) { return GestureDetector(
            onTap: () => _controller.selectAll(),
            child: SizedBox(height: 16, width: 15, child: FittedBox(child: Icon(Icons.bar_chart, color: widget.decorator.rowNumberStyle.color??Colors.black,)),)); }
           return GestureDetector(
            onTap: () => _controller.selectRow(i: index -1),
            child: SizedBox(height: _rowHeight + _divHeight, child: Text(index.toString(), style: widget.decorator.rowNumberStyle,)));
        }),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:  _controller.stream.stream,
      builder: (context,  snapshot) {
        int          index              = 0;
        List<Widget> columns            = <Widget>[];
        GridColumnIterableIterable iter = widget.data.getColumnIterator();
        columns.add(buildIndexColumn(context, iter: iter.first));
          columns.add(buildColumnDiv());
        for(var data in iter) {
          columns.add(buildColumn(context, iter: data, columnJ: index));
          columns.add(ColumnSeparator(
            index:            index++,
            height:           _height - _titleHeight,
            width:            _divHeight,
            parentController: _controller,
          ));
        }
        return Row(
          children: columns,
          crossAxisAlignment: CrossAxisAlignment.end, /// required to keep [ColumnSeparator] anchored correctly
        );
    });
  }

}