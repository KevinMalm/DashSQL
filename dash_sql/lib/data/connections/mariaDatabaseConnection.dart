import 'package:dash_sql/data/connectionArtifacts/fieldData.dart';
import 'package:dash_sql/data/connectionArtifacts/queryData.dart';
import 'package:dash_sql/data/connectionArtifacts/schemaData.dart';
import 'package:dash_sql/data/connectionArtifacts/tableData.dart';
import 'package:dash_sql/data/databaseConnection.dart';
import 'package:mysql1/mysql1.dart';

class MariaDbConnection extends DatabaseConnection {
  
  MySqlConnection? database;

  MariaDbConnection({
    required super.name,
    required super.connectionHost,
    required super.connectionPort,
    required super.databaseName,
    required super.username
  });


  /// Connect to a Maria Database Instance
  @override
  Future<String?> connect({required String password}) async {
    try {
      database = await MySqlConnection.connect(
        ConnectionSettings(
          host:     connectionHost,
          port:     connectionPort,
          user:     username,
          password: password,
          db:       databaseName,
          useSSL:   useSSL
        )
      );
      connected = (database != null);
    } catch(e) {
      connected = false;
      return e.toString();
    }
  }


  /// Disconnect to a Maria Database Instance
  @override
  Future<void> disconnect() async {
    if(database == null) { return; }
    await database!.close();
    connected = false;
  }

  /// Runs query on connected database
  /// Inputs:
  /// - query (String): query to run
  @override
  Future<QueryResult> query({required String query}) async {
    if(database == null) { return QueryResult(errorMessage: "Database $name is not connected"); }
    try {
      Results     results = await database!.query(query);
      QueryResult res     = QueryResult();
      for(var row in results) {
        res.addRecord(row.fields);
      }
      return res;
    } catch(e) {
      return QueryResult(errorMessage: e.toString());
    }
  }

  @override
  Future<List<DatabaseSchemaData>?> listSchemas() async {
    late Results             results;
    List<DatabaseSchemaData> schemaData = <DatabaseSchemaData>[];

    if(database == null) { return null; }

    /* --- STEP A: run query ---- */
    try {
      results = await database!.query("SHOW DATABASES");
    } catch (e) {
      return null;
    }

    /* --- STEP B: parse returned results ---- */
    for(var row in results) {
      String schemaName = row['Database'];
      schemaData.add(DatabaseSchemaData(schemaName: schemaName));
    }
    schemas = schemaData;
    return schemas;
  }

  @override
  Future<List<DatabaseTableData>?> listTables({required DatabaseSchemaData schema}) async {
    late Results            results;
    List<DatabaseTableData> tables = <DatabaseTableData>[];

    if(database == null) { return null; }

    /* --- STEP A: run query ---- */
    try {
      await database!.query("USE ${schema.schemaName}");
      results = await database!.query("SHOW TABLES");
    } catch (e) {
      print(e);
      return null;
    }

    /* --- STEP B: parse returned results ---- */
    for(var row in results) {
      tables.add(DatabaseTableData(tableName: row['Tables_in_${schema.schemaName}'], schemaData: schema));
    }
    schema.tables = tables;
    return tables;
  }

  @override
  Future<List<DatabaseFieldData>?> describeTable({required DatabaseTableData table}) async {
    late Results            results;
    List<DatabaseFieldData> fields = <DatabaseFieldData>[];

    if(database == null) { return null; }

    /* --- STEP A: run query ---- */
    try {
      results = await database!.query("DESCRIBE ${table.schemaData.schemaName}.${table.tableName}");
    } catch (e) {
      print(e);
      return null;
    }
  
    /* --- STEP B: parse returned results ---- */
    for(var row in results) {
      fields.add(
        DatabaseFieldData(
          fieldName:     row['Field'],
          fieldDataType: (row['Type'] as Blob).toString(),
          isPk:          row['Key'] == 'PRI',
          isFk:          false,
          isNullable:    false
        )
      );
    }

    table.fields = fields;
    return fields;
  }

  
}