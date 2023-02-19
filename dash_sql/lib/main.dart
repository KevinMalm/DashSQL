import 'package:dash_sql/libraries/gridSheet/gridData.dart';
import 'package:dash_sql/libraries/gridSheet/gridDecorator.dart';
import 'package:dash_sql/libraries/gridSheet/gridSheet.dart';
import 'package:dash_sql/pages/workbench/workbenchPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WorkbenchPage()
    );

    return MaterialApp(
      home: Scaffold(
        body: GridSheet(
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
            headerDecorator: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15)
              )
            )
          ),
      ),
    ));
  }
}
