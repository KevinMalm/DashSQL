import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/libraries/gridSheet/gridData.dart';
import 'package:dash_sql/libraries/gridSheet/gridDecorator.dart';
import 'package:dash_sql/libraries/gridSheet/gridSheet.dart';
import 'package:flutter/material.dart';

class QueryResultsPanel extends StatefulWidget {

  const QueryResultsPanel({super.key});

  @override
  State<StatefulWidget> createState() => _QueryResultsPanelState();

}


class _QueryResultsPanelState extends State<QueryResultsPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: DashColorLibrary.backgroundLight,
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridSheet(
              data: GridData(
                data: [
                  ["Rachel", "12", "15.2"],
                  ["Peter", "82", "8.1"],
                  ["Kevin", null, "-1"],
                ],
                titles: ["Name", "Age", "Score"]
              ),
              decorator: GridSheetDecorator(
                oddRow: Colors.blue[100],
                rowNumberStyle: const TextStyle(color: Colors.white),
                headerDecorator: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15)
                  )
                ),
                headerStyle: const TextStyle(color: Colors.white),
                selectedStyle: const TextStyle(color: Colors.white),
              ),
          ),
        ),
      ),
    );
  }

  
}