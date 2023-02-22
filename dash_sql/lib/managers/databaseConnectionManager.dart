import 'dart:async';

import 'package:dash_sql/data/connections/mariaDatabaseConnection.dart';
import 'package:dash_sql/data/connections/mongoDatabaseConnection.dart';
import 'package:dash_sql/data/databaseConnection.dart';

class DatabaseConnectionManager {

  static DatabaseConnectionManager? instance;

  static DatabaseConnectionManager getInstance() {
    instance ??= DatabaseConnectionManager();
    return instance!;
  }

  /* ------------------------------------------------------------------------------------------------------------------------------ */
  /// Controls refreshed when Active Object is changed
  final StreamController stream         = StreamController.broadcast();
  DatabaseArtifact?      activeArtifact;

  List<DatabaseConnection> connections = <DatabaseConnection>[
    MongoDbConnection(
      name: "Doctor DB",
      connectionHost: "127.0.0.1",
      connectionPort: 23002,
      databaseName: "DOCTOR",
      username: "tester"
    ),
    MariaDbConnection(
      name: "Maria DB",
      connectionHost: "127.0.0.1",
      connectionPort: 3306,
      databaseName: "rscape",
      username: "rscapeUser"
    ),
    MongoDbConnection(name: "123", connectionHost: "127", connectionPort: 5, databaseName: "abc", username: "abc"),
  ];



  List<DatabaseConnection> getConnectedInstances() {
    List<DatabaseConnection> connectedInstances = <DatabaseConnection>[];
    connections.forEach((element) { if(element.connected) {connectedInstances.add(element); } });
    return connectedInstances;
  }


  DatabaseConnectionManager() {
    connections[1].connect(password: 'user_password_!0');
  }

  void updateActiveElement({required DatabaseArtifact obj}) {
    activeArtifact = obj;
    stream.add(this);
  }

}