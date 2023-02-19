
import 'package:dash_sql/data/databaseConnection.dart';
import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/pages/workbench/databaseSidePanel/widgets/tableConnectionWidget.dart';
import 'package:dash_sql/pages/workbench/databaseSidePanel/widgets/templateConnectionWidget.dart';
import 'package:flutter/material.dart';

class SchemaConnectionWidget extends TemplateConnectionWidget {

  final String       schema;
  List<String>?      tables;
  SchemaConnectionWidget({
    super.key,
    required super.connection,
    required this.schema,
    required super.thisOffset
  });


  /*
    ---------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------
  */


  Future<void> refresh(context) async {
    await openRefresh();
    return;
  }

  Future<void> expandOutline(context) async {
    if(expanded) {
      /* --- CASE: already expanded, so close --- */
      setState(() {
        expanded = false;
      });
      return;
    }
    openBody();
  }

  /// When Connected: builds disconnect button
  /// When Disconnected: builds connection option
  Widget buildActionButton(context) {
    if(expanded == false) { return const SizedBox(); }
    return GestureDetector(
      onTap: () => refresh(context),
      child: const MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Icon(Icons.refresh),
      ),
    );
    }

  Widget buildLeadingIcon(context) {
    return GestureDetector(
      onTap: () => expandOutline(context),
      child: const MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Icon(Icons.newspaper)),
    );
  }

  /*
    ---------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------
  */

  @override
  Widget buildHeader(context) { return Row(
    children: [
      SizedBox(width: thisOffset),
      buildLeadingIcon(context),
      const SizedBox(width: 5),
      Text(schema, style: const TextStyle(color: Colors.grey),),
      const Spacer(),
      buildActionButton(context)
    ],
  ); }

  @override
  Widget buildBody(context) {
    if(tables == null) { return const Text("error"); }
    return Column(
      children: List<Widget>.generate(tables!.length, (index) { return TableConnectionWidget(
                                                                          connection: connection,
                                                                          schema: schema,
                                                                          table: tables![index],
                                                                          thisOffset: thisOffset + leftOffset,
                                                                      ); })
    );
  }
  /*
    ---------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------
  */

  @override
  Future<void> openRefresh() async {
    tables = await connection.listTables(schema: schema);
  }
}