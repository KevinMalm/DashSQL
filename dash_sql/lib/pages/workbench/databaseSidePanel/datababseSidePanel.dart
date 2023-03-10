


import 'package:dash_sql/data/databaseConnection.dart';
import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/libraries/inputLibrary.dart';
import 'package:dash_sql/managers/databaseConnectionManager.dart';
import 'package:dash_sql/pages/workbench/databaseSidePanel/widgets/defaukltDatabaseConnectionWidget.dart';
import 'package:flutter/material.dart';

class DatabaseWorkbenchSidePanel extends StatefulWidget {

  const DatabaseWorkbenchSidePanel({super.key});

  @override
  State<StatefulWidget> createState() => _DatabaseWorkbenchSidePanelState();

}


class _DatabaseWorkbenchSidePanelState extends State<DatabaseWorkbenchSidePanel> {
  final double headerHeight = 25;

  void openNewConnectionPage(dynamic args) {

  }

  Widget buildConnectionHeader(context) {
    return Positioned(
      top: 0,
      child: Row(children: [
        DashInputLibrary.buildButton(
          context,
          height:   headerHeight,
          callback: openNewConnectionPage,
          child:    const Icon(Icons.add))
      ],),
    );
  }

  Widget buildConnectionOutline(context) {
    late List<DatabaseConnection> connections;
    late List<Widget>             connectionWidgets;

    connections       = DatabaseConnectionManager.getInstance().connections; 
    connectionWidgets = List<Widget>.generate(
      connections.length, (index) => connections[index].builder(connections[index]));
    connectionWidgets.insert(0, SizedBox(height: headerHeight + 2));
    return ListView(children: connectionWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DashColorLibrary.backgroundDark,
      child:  Stack(
        children: [
          buildConnectionOutline(context),
          buildConnectionHeader(context)
        ],
      )
    );
  }

  
}