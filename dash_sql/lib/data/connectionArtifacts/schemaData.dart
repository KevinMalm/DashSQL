

import 'package:dash_sql/data/connectionArtifacts/tableData.dart';
import 'package:dash_sql/data/databaseConnection.dart';

class DatabaseSchemaData extends DatabaseArtifact {
  
  /// Schema name in database
  final String schemaName;
  /// Feed when Schema is described
  List<DatabaseTableData>? tables;

  DatabaseSchemaData({
    required this.schemaName
  });


}