


import 'dart:async';

import 'package:dash_sql/data/connectionArtifacts/queryData.dart';

class QueryResultsManager {
  
  static QueryResultsManager? instance;

  static QueryResultsManager getInstance() {
    instance ??= QueryResultsManager();
    return instance!;
  }


  final StreamController stream = StreamController<Object>();

  Map<String, QueryResult?> results = <String, QueryResult?>{};


  void clearQueryResults() {
    results = <String, QueryResult?>{};
    stream.add(this);
  }

  void prepQueryResult({required String tabName}) {
    results[tabName] = null;
    stream.add(this);
  }

  void writeQueryResults({required String tabName, required QueryResult? results}) {
    this.results[tabName] = results;
    stream.add(this);
  }

}