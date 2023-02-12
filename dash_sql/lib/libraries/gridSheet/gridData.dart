
import 'package:flutter/material.dart';
import 'package:dash_sql/libraries/gridSheet/util/gridIterators.dart';


class GridData {

  bool                      empty = true;
  final List<List<String?>> data;
  late final List<String>   titles;
  late List<double>         percents;
  late final int            rows;
  late final int            columns;

  GridData({
    required this.data,
    List<String>? titles
  }) {
    if(data.isEmpty) {
      empty = true;
      return;
    }
    this.titles = titles??List<String>.generate(data.first.length, (index) => "Column $index");
    rows        = data.length;
    columns     = data.first.length;
  }

  /*
    ----------------------------------------------------------------------------------------------------

    ----------------------------------------------------------------------------------------------------
  */

  GridColumnIterable getIterator({required int columnIndex}) {
    return GridColumnIterable(data: data, columnIndex: columnIndex);
  }
  GridColumnIterableIterable getColumnIterator() {
    return GridColumnIterableIterable(data: data);
  }

  /*
    ----------------------------------------------------------------------------------------------------

    ----------------------------------------------------------------------------------------------------
  */



}