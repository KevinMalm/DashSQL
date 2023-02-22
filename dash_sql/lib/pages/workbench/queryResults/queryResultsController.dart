


import 'package:dash_sql/data/connectionArtifacts/queryData.dart';
import 'package:dash_sql/libraries/tabbedWindow/tabbedWindowController.dart';
import 'package:dash_sql/managers/queryResultsManager.dart';
import 'package:dash_sql/pages/workbench/queryResults/queryResultsTab.dart';

class QueryResultsController extends TabbedWindowController {


  QueryResultsController() {
    QueryResultsManager resultsManager = QueryResultsManager.getInstance();
    onPageChange = pageChange;

    resultsManager.results.forEach((key, value) {
      pages.add(
        TabbedWindowInstance(
          title: key,
          allowDelete: false,
          child: QueryResultsTab(results: value)
        )
      );
    });
  }

  /*
    ***********************************************************************************************

    ***********************************************************************************************
  */
  void pageChange(int i) {

  }
  /*
    ***********************************************************************************************

    ***********************************************************************************************
  */
  
  @override
  Future<TabbedWindowInstance?> tabBuilder({required context}) async {
    return null;
  }
}