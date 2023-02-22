


import 'package:dash_sql/data/databaseConnection.dart';

class DatabaseFieldData extends DatabaseArtifact {

  final String fieldName;
  final String fieldDataType;
  final bool   isPk;
  final bool   isFk;
  final bool   isNullable;

  DatabaseFieldData({
    required this.fieldName,
    required this.fieldDataType,
    this.isPk       = false,
    this.isFk       = false,
    this.isNullable = false
  });

}