





import 'package:dash_sql/data/connectionArtifacts/schemaData.dart';
import 'package:dash_sql/data/connectionArtifacts/tableData.dart';
import 'package:dash_sql/data/databaseConnection.dart';
import 'package:dash_sql/managers/databaseConnectionManager.dart';
import 'package:flutter/material.dart';

class DatabaseOverviewPanel extends StatefulWidget {

  const DatabaseOverviewPanel({super.key});

  @override
  State<StatefulWidget> createState() => _DatabaseOverviewPanelState();
}

class _DatabaseOverviewPanelState extends State<DatabaseOverviewPanel> {

  final DatabaseConnectionManager _connectionManager = DatabaseConnectionManager.getInstance();

  Widget buildNoActiveElement(context) {
    return const Text("No Active Element");
  }

  Widget buildDatabaseElement(context) {
    DatabaseConnection activeConnection = _connectionManager.activeArtifact as DatabaseConnection;
    return Text("Active Database: ${activeConnection.name}");
  }

  Widget buildSchemaElement(context) {
    DatabaseSchemaData activeSchema = _connectionManager.activeArtifact as DatabaseSchemaData;
    return Text("Active schema: ${activeSchema.schemaName}");
  }

  Widget buildTableElement(context) {
    DatabaseTableData activeTable = _connectionManager.activeArtifact as DatabaseTableData;
    return Text("Active table: ${activeTable.tableName}");
  }



  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:  _connectionManager.stream.stream,
      builder: ((context, snapshot) {
        /* ------------------------------------------------------------------------ */
        if(_connectionManager.activeArtifact == null) {
          return buildNoActiveElement(context);
        }
        /* ------------------------------------------------------------------------ */
        if(_connectionManager.activeArtifact.runtimeType == DatabaseConnection) {
          return buildDatabaseElement(context);
        }
        /* ------------------------------------------------------------------------ */
        if(_connectionManager.activeArtifact.runtimeType == DatabaseSchemaData) {
          return buildSchemaElement(context);
        }
        /* ------------------------------------------------------------------------ */
        if(_connectionManager.activeArtifact.runtimeType == DatabaseTableData) {
          return buildTableElement(context);
        }
        return const Text("Oh no");
      })
    );
  }

}