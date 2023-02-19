import 'package:mongo_dart/mongo_dart.dart';
import 'package:dash_sql/data/databaseConnection.dart';

class MongoDbConnection extends DatabaseConnection {
  
  Db? database;

  MongoDbConnection({
    required super.name,
    required super.connectionHost,
    required super.connectionPort,
    required super.databaseName,
    required super.username
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
  Future<List<String>?> listSchemas({String? database}) async {
    if(this.database == null) { return null; }
    List<String?> collections = await this.database!.getCollectionNames();
    schemaNames = List<String>.generate(collections.length, (index) => (collections[index]??"N/A"));
    return schemaNames;
  }
  @override
  Future<List<String>?> listTables({String? schema}) async => throw UnimplementedError();
}