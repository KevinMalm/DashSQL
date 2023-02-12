


import 'package:dash_sql/data/connections/mongoDatabaseConnection.dart';
import 'package:dash_sql/data/databaseConnection.dart';

class DatabaseConnectionManager {

  static DatabaseConnectionManager? instance;

  static DatabaseConnectionManager getInstance() {
    instance ??= DatabaseConnectionManager();
    return instance!;
  }

  /* ------------------------------------------------------------------------------------------------------------------------------ */
  List<DatabaseConnection> connections = <DatabaseConnection>[
    MongoDbConnection(
      name: "Doctor DB",
      connectionHost: "127.0.0.1",
      connectionPort: 23002,
      databaseName: "DOCTOR",
      username: "tester"
    ),
    MongoDbConnection(name: "123", connectionHost: "127", connectionPort: 5, databaseName: "abc", username: "abc"),
  ];




}