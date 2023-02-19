

class DatabaseConnection {
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
  final String name;
  final String connectionHost;
  final int    connectionPort;
  final String databaseName;
  bool         connected = false;
  final String username;
  String?      passwordVaultKey;
  /* ------------------------------- */
  /* ------- REFRESH-ABLE ---------- */
  /* ------------------------------- */
  List<String>? databaseNames;
  List<String>? schemaNames;


  DatabaseConnection({
    required this.name,
    required this.connectionHost,
    required this.connectionPort,
    required this.databaseName,
    required this.username
  });



  Future<String?> connect({required String password}) async => throw UnimplementedError();
  Future<void> disconnect() async => throw UnimplementedError();
  Future<QueryResult>   query({required String query}) => throw UnimplementedError();
  Future<List<String>?> listSchemas() async => throw UnimplementedError();
  Future<List<String>?> listTables({required String schema}) async => throw UnimplementedError();
  Future<List<TableFieldDefinition>?> describeTable({required String schema, required String table}) async => throw UnimplementedError();
}

class TableFieldDefinition {
  final String fieldName;
  final String fieldType;
  final bool   isPk;
  final bool   isFk;

  TableFieldDefinition({
    required this.fieldName,
    required this.fieldType,
    required this.isPk,
    required this.isFk
  });
}

class QueryResult {
  List<String>?        fields;
  List<List<String?>>? data;
  String?              errorMessage;
  QueryResult({this.errorMessage}) {
    if(errorMessage == null) {
      data   = <List<String?>>[];
    }
  }


  void addRecord(Map<String, dynamic> data) {
    if(fields == null) { 
      fields = <String>[];
      data.forEach((key, value) { fields!.add(key); });
     }
     List<String?> dataRows = <String?>[];
     data.forEach((key, value) { dataRows.add((value == null ? null : value.toString())); });
     this.data!.add(dataRows);
  }

}