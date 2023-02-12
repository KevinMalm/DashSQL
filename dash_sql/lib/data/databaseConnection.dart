


import 'package:dash_sql/pages/workbench/databaseSidePanel/widgets/defaukltDatabaseConnectionWidget.dart';
import 'package:flutter/material.dart';

class DatabaseConnection {

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
  Widget Function(DatabaseConnection) builder;
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
    required this.username,
    this.builder = DatabaseConnectionWidget.builder
  });



  Future<String?> connect({required String password}) async => throw UnimplementedError();
  Future<void> disconnect() async => throw UnimplementedError();
  Future<List<String>?> listDatabases() async => throw UnimplementedError();
  Future<List<String>?> listSchemas() async => throw UnimplementedError();
}