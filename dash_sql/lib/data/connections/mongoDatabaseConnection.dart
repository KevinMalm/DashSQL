import 'package:dash_sql/pages/workbench/databaseSidePanel/widgets/mongoDatabaseConnectionWidget.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:dash_sql/data/databaseConnection.dart';

class MongoDbConnection extends DatabaseConnection {
  
  Db? database;

  MongoDbConnection({
    required super.name,
    required super.connectionHost,
    required super.connectionPort,
    required super.databaseName,
    required super.username,
    super.builder = MongoDatabaseConnectionWidget.builder
  });


  @override
  Future<String?> connect({required String password}) async {
    try {
      database = Db("mongodb://$connectionHost:$connectionPort/$databaseName");

      await database!.open();
      connected = true;
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
  Future<List<String>?> listDatabases() async {
    if(database == null) { return null; }
    return [database!.databaseName!];
  }
  @override
  Future<List<String>?> listSchemas() async {
    if(database == null) { return null; }
    List<String?> collections = await database!.getCollectionNames();
    schemaNames = List<String>.generate(collections.length, (index) => (collections[index]??"N/A"));
    return schemaNames;
  }
}