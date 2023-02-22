
import 'package:dash_sql/data/connectionArtifacts/queryData.dart';
import 'package:dash_sql/libraries/gridSheet/gridData.dart';
import 'package:dash_sql/libraries/gridSheet/gridDecorator.dart';
import 'package:dash_sql/libraries/gridSheet/gridSheet.dart';
import 'package:flutter/material.dart';

class QueryResultsTab extends StatefulWidget {

  QueryResult? results;

  QueryResultsTab({
    super.key,
    required this.results
  });

  @override
  State<StatefulWidget> createState() => _QueryResultsTab();

}

class _QueryResultsTab extends State<QueryResultsTab> {

  @override
  Widget build(BuildContext context) {
    if(widget.results == null) {
      return Text("No results");
    }
    if(widget.results!.errorMessage != null) {
      return Text(widget.results!.errorMessage!);
    }

    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        GridSheet(
          data: GridData(
            data:   widget.results!.data!,
            titles: widget.results!.fields
          ),
          decorator: GridSheetDecorator(
            oddRow: Colors.blue[100],
            dividerHeight: 2,
            headerDecorator: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15)
              )
            )
          ),
        ),
      ],
    );
  }

}