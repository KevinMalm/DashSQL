



import 'package:flutter/material.dart';

class GridSheetDecorator {
  /* ----------------------------------- */
  late final TextStyle headerStyle;
  late final TextStyle rowNumberStyle;
  late final TextStyle dataStyle;
  late final TextStyle selectedStyle;
  /* ----------------------------------- */
  late final Color         selected; 
  late final Color         evenRow; 
  late final Color         evenRowOddColumn;
  late final Color         oddRow;
  late final Color         oddRowOddColumn;
  late final BoxDecoration headerDecorator;
  late final BoxDecoration oddHeaderDecorator;
  /* ----------------------------------- */
  late final Color columnDividerColor;
  late final Color rowDividerColor;
  /* ----------------------------------- */
  late final double dividerHeight;
  late final double titleHeight;
  late final double rowHeight;



  GridSheetDecorator({
    TextStyle? headerStyle,
    TextStyle? rowNumberStyle,
    TextStyle? dataStyle,
    TextStyle? selectedStyle,

    Color? selected,
    Color? evenRow,
    Color? oddRow,
    Color? evenRowOddColumn,
    Color? oddRowOddColumn,

    BoxDecoration? headerDecorator,
    BoxDecoration? oddHeaderDecorator,

    Color? columnDividerColor,
    Color? rowDividerColor,

    this.dividerHeight = 1,
    this.titleHeight   = 15,
    this.rowHeight     = 15
  }) {
    /* ---------------------------------------------------------------------- */
    this.headerStyle        = headerStyle    ?? const TextStyle();
    this.rowNumberStyle     = rowNumberStyle ?? const TextStyle();
    this.dataStyle          = dataStyle      ?? const TextStyle();
    this.selectedStyle      = selectedStyle  ?? const TextStyle();
    /* ---------------------------------------------------------------------- */
    this.selected           = selected??Colors.blue;
    this.evenRow            = evenRow ?? Colors.white;
    this.oddRow             = oddRow  ?? const Color.fromARGB(255, 230, 230, 230);
    this.evenRowOddColumn   = evenRowOddColumn  ?? this.evenRow;
    this.oddRowOddColumn    = oddRowOddColumn   ?? this.oddRow;
    /* ---------------------------------------------------------------------- */
    this.headerDecorator    = headerDecorator    ?? const BoxDecoration();
    this.oddHeaderDecorator = oddHeaderDecorator ?? this.headerDecorator;
    /* ---------------------------------------------------------------------- */
    this.columnDividerColor = columnDividerColor ?? Colors.black;
    this.rowDividerColor    = rowDividerColor    ?? Color(Colors.grey[800]!.value);
    /* ---------------------------------------------------------------------- */
  }
}