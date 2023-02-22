
import 'package:dash_sql/data/connectionArtifacts/schemaData.dart';
import 'package:dash_sql/data/connectionArtifacts/tableData.dart';
import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/managers/databaseConnectionManager.dart';
import 'package:dash_sql/pages/workbench/databaseSidePanel/widgets/tableConnectionWidget.dart';
import 'package:dash_sql/pages/workbench/databaseSidePanel/widgets/templateConnectionBar.dart';
import 'package:flutter/material.dart';

class SchemaConnectionWidget extends TemplateConnectionWidget {

  final DatabaseSchemaData       schema;
  List<DatabaseTableData>?       tables;
  late DatabaseConnectionManager databaseConnectionManager;
  bool                           isSelected = false;

  SchemaConnectionWidget({
    super.key,
    required super.connection,
    required this.schema,
    required super.thisOffset
  }) {
    databaseConnectionManager = DatabaseConnectionManager.getInstance();
  }


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
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Icon(
          Icons.dataset_outlined,
          color: (expanded || isSelected ? DashColorLibrary.bluePrimary : DashColorLibrary.backgroundBlack),
        )),
    );
  }

  Widget buildSchemaName(context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => DatabaseConnectionManager.getInstance().updateActiveElement(obj: schema),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(schema.schemaName, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey),),
        ),
      ),
    );
  }

  /*
    ---------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------
  */

  @override
  Widget buildHeader(context) {
    return StreamBuilder(
      stream: databaseConnectionManager.stream.stream,
      builder: (context, snapshot) {
        isSelected = databaseConnectionManager.activeArtifact == schema;
        return Padding(
          padding: EdgeInsets.only(left: thisOffset),
          child: Container(
            color: ((databaseConnectionManager.activeArtifact == schema)) ? DashColorLibrary.backgroundLight : Colors.transparent,
            child: Row(
              children: [
                //SizedBox(width: thisOffset),
                buildLeadingIcon(context),
                const SizedBox(width: 5),
                buildSchemaName(context),
                buildActionButton(context)
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Widget buildBody(context) {
    if(tables == null) { return const Text("error"); }
    return Column(
      children: List<Widget>.generate(tables!.length, (index) { return TableConnectionWidget(
                                                                          connection: connection,
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
