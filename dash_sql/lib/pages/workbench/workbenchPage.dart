import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/pages/workbench/databaseSidePanel/datababseSidePanel.dart';
import 'package:dash_sql/pages/workbench/ide/sqlIdePanel.dart';
import 'package:dash_sql/pages/workbench/queryResults/queryResultsPanel.dart';
import 'package:flutter/material.dart';
import 'package:resizable_widget/resizable_widget.dart';


class WorkbenchPage extends StatefulWidget {


  const WorkbenchPage({super.key});

  @override
  State<StatefulWidget> createState() => _WorkbenchPageState();

}


class _WorkbenchPageState extends State<WorkbenchPage> {


  @override
  Widget build(BuildContext context) {
    Widget sidePanel    = const DatabaseWorkbenchSidePanel();
    Widget topPanel     = SqlIdePanel();
    Widget bottomPanel  = const QueryResultsPanel();

    Widget mainBody     = ResizableWidget(
                            isHorizontalSeparator: true,
                            percentages: const [0.75,0.25],
                            maxPercentages: const [double.infinity, 0.9],
                            minPercentages: const [0, 0.1],
                            separatorColor: DashColorLibrary.accentDark,
                            children: [topPanel, bottomPanel]
                          );
    Widget page         = ResizableWidget(
                            maxPercentages: const [0.5, double.infinity],
                            minPercentages: const [0.2, 0],
                            percentages: const [0.25,0.75],
                            separatorColor: DashColorLibrary.backgroundDark,
                            children: [sidePanel, mainBody]
                          );

    return Scaffold(
      body: page
    );
  }

}