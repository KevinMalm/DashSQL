


import 'dart:async';

import 'package:flutter/material.dart';


class TabbedWindowInstance {
  String? title;
  Widget  child;
  bool    allowDelete;

  TabbedWindowInstance({
    required this.child,
    this.title,
    this.allowDelete = true
  });
}

class TabbedWindowController {
  final StreamController<Object> stream = StreamController<Object>();


  Function(int)?                  onPageChange;
  late List<TabbedWindowInstance> pages;


  TabbedWindowController({
    List<TabbedWindowInstance>? pages
  }) {
    this.pages = pages??<TabbedWindowInstance>[];
  }


  bool                  canRemoveTab({required int index})         => true;
  Future<TabbedWindowInstance?> tabBuilder({required BuildContext context}) => throw UnimplementedError();

  void newTabBuilder(context) async {
    TabbedWindowInstance? inst = await tabBuilder(context: context);
    if(inst == null) {
      return;
    }
    pages.add(inst);
    stream.add(this);
  }

  void removeTab({required int index}) {
    if(canRemoveTab(index: index)) {
      pages.removeAt(index);
      stream.add(this);
    }
  }
}