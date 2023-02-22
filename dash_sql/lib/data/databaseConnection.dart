

import 'package:dash_sql/data/connectionArtifacts/fieldData.dart';
import 'package:dash_sql/data/connectionArtifacts/queryData.dart';
import 'package:dash_sql/data/connectionArtifacts/schemaData.dart';
import 'package:dash_sql/data/connectionArtifacts/tableData.dart';


class DatabaseArtifact {

}

class DatabaseConnection extends DatabaseArtifact {
  /// Internal Id
  /// Name
  /// Comments
  /// 
  /// Username
  /// Password
  /// Save Password?
  /// 
  /// Host Address
  /// Port
  /// Default Database
  /// 
  /// SSL required?
  /// 
  /// Use SSH?
  /// Tunnel Host
  /// Tunnel Port
  /// Username
  /// Password (option a)
  /// Id file (option b)

  /* ------------------------------- */
  /* ----------- CONFIG ------------ */
  /* ------------------------------- */
  /// Display name of Connection
  final String name;
  /// IP / Host name for establishing connection
  final String connectionHost;
  /// Port to connect on
  final int    connectionPort;
  /// Default Database to connect to
  final String databaseName;
  /// State of if connected
  bool         connected = false;
  /// Saved Username for establishing connection
  final String username;
  /// Key to encrypted - saved password
  String?      passwordVaultKey;

  late bool     useSSL;
  late bool     readOnly;
  /* ------------------------------- */
  /* ------- REFRESH-ABLE ---------- */
  /* ------------------------------- */
  /// List of Databases paired with schema name
  List<DatabaseSchemaData>? schemas;
   


  DatabaseConnection({
    required this.name,
    required this.connectionHost,
    required this.connectionPort,
    required this.databaseName,
    required this.username,
    this.useSSL   = false,
    this.readOnly = false
  });

  void setReadOnlyMode({required bool mode}) => readOnly = mode;

  Future<String?> connect({required String password}) async => throw UnimplementedError();
  Future<void> disconnect() async => throw UnimplementedError();
  Future<QueryResult>   query({required String query}) => throw UnimplementedError();
  Future<List<DatabaseSchemaData>?> listSchemas() async => throw UnimplementedError();
  Future<List<DatabaseTableData>?> listTables({required DatabaseSchemaData schema}) async => throw UnimplementedError();
  Future<List<DatabaseFieldData>?> describeTable({required DatabaseTableData table}) async => throw UnimplementedError();
}

