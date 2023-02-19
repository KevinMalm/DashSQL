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


  @override
  Future<String?> connect({required String password}) async {
    try {
      database = await MySqlConnection.connect(
        ConnectionSettings(
          host:     connectionHost,
          port:     connectionPort,
          user:     username,
          password: password,
          db:       databaseName
        )
      );
      connected = (database != null);
    } catch(e) {
      connected = false;
      return e.toString();
    }
  }

  @override
  Future<void> disconnect() async {
    if(database == null) { return; }
    await database!.close();
    connected = false;
  }


  @override
  Future<List<String>?> listSchemas() async {
    late Results results;
    List<String> databases = <String>[];
    if(database == null) { return null; }

    try {
      results = await database!.query("SHOW DATABASES");
    } catch (e) { return null; }

    for(var row in results) {
      databases.add(row['Database']);
    }
    return databases;
  }
  @override
  Future<List<String>?> listTables({required String schema}) async {
    late Results results;
    List<String> tables = <String>[];
    if(database == null) { return null; }

    try {
      await database!.query("USE $schema");
      results = await database!.query("SHOW TABLES");
    } catch (e) { print(e); return null; }

    for(var row in results) {
      tables.add(row["Tables_in_$schema"]);
    }
    return tables;
  }

  Future<List<TableFieldDefinition>?> describeTable({required String schema, required String table}) async {
    late Results results;
    List<TableFieldDefinition> fields = <TableFieldDefinition>[];
    if(database == null) { return null; }

    try {
      results = await database!.query("DESCRIBE $schema.$table");
    } catch (e) { print(e); return null; }

    for(var row in results) {
      fields.add(
        TableFieldDefinition(
          fieldName: row['Field'],
          fieldType: (row['Type'] as Blob).toString(),
          isPk: row['Key'] == "PRI",
          isFk: false
        )
      );
    }
    return fields;
  }


  Future<QueryResult> query({required String query}) async {
    if(database == null) { return QueryResult(errorMessage: "Database $name is not connected"); }
    try {
      Results     results = await database!.query(query);
      QueryResult res     = QueryResult();
      for(var row in results) { res.addRecord(row.fields); }
      return res;
    } catch(e) {
      return QueryResult(errorMessage: e.toString());
    }
  }

}