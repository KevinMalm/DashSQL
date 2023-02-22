



import 'package:dash_sql/data/connectionArtifacts/fieldData.dart';
import 'package:dash_sql/data/connectionArtifacts/schemaData.dart';
import 'package:dash_sql/data/databaseConnection.dart';

class DatabaseTableData extends DatabaseArtifact {


  /// Table name
  final String             tableName;
  /// Back Reference to the schema it belongs too
  final DatabaseSchemaData schemaData;
  /// Populated when Field is described
  List<DatabaseFieldData>? fields;


  DatabaseTableData({
    required this.tableName,
    required this.schemaData
  });

}