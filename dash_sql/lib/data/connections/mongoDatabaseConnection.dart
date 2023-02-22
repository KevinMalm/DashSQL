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


}