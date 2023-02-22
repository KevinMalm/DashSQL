
import 'package:dash_sql/data/connectionArtifacts/fieldData.dart';
import 'package:dash_sql/data/connectionArtifacts/schemaData.dart';
import 'package:dash_sql/data/connectionArtifacts/tableData.dart';
import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/managers/databaseConnectionManager.dart';
import 'package:dash_sql/pages/workbench/databaseSidePanel/widgets/templateConnectionBar.dart';
import 'package:flutter/material.dart';

class TableConnectionWidget extends TemplateConnectionWidget {

  final DatabaseTableData        table;
  List<DatabaseFieldData>?       fields;
  late DatabaseConnectionManager databaseConnectionManager;
  bool                           isSelected = false;
  TableConnectionWidget({
    super.key,
    required super.connection,
    required this.table,
    required super.thisOffset
  }) {
    databaseConnectionManager = DatabaseConnectionManager.getInstance();
  }


  /*
    ---------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------
  */


  Future<void> refresh(context) async {
    await openRefresh();
    return;
  }

  Future<void> expandOutline(context) async {
    if(expanded) {
      /* --- CASE: already expanded, so close --- */
      setState(() {
        expanded = false;
      });
      return;
    }
    openBody();
  }

  Widget buildTableName(context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => databaseConnectionManager.updateActiveElement(obj: table),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(table.tableName, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey),),
        ),
      ),
    );
  }

  Widget buildLeadingIcon(context) {
    return GestureDetector(
      onTap: () => expandOutline(context),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Icon(
          Icons.equalizer,
          color: ((isSelected || expanded) ? DashColorLibrary.bluePrimary : DashColorLibrary.backgroundBlack),
        )),
    );
  }

  /*
    ---------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------
  */

  @override
  Widget buildHeader(context) {

    return StreamBuilder(
      stream: databaseConnectionManager.stream.stream,
      builder: (context, snapshot) {
        isSelected = databaseConnectionManager.activeArtifact == table;
        return Padding(
          padding: EdgeInsets.only(left: thisOffset - leftOffset),
          child: Container(
            color: ((isSelected || (databaseConnectionManager.activeArtifact == table.schemaData)) ? DashColorLibrary.backgroundLight : Colors.transparent),
            child: Row(
              children: [
                SizedBox(width: leftOffset),
                buildLeadingIcon(context),
                const SizedBox(width: 5),
                buildTableName(context),
              ],
            ),
          ),
        );
      }
    );
  }

  /*
    ---------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------
  */

  IconData getIcon(String dataType) {
    String formatted = dataType.split('(').first.toLowerCase();
    if((formatted == 'varchar') || (formatted == 'char')) { return Icons.text_fields; }
    if((formatted == 'bigint') || (formatted == 'int') || (formatted == 'double')) { return Icons.numbers; }
    if((formatted == 'tinyint') ) { return Icons.book; }
    return Icons.device_unknown;
  }

  @override
  Widget buildBody(context) {
    if(fields == null) { return const Text("error"); }
    return StreamBuilder(
      stream: databaseConnectionManager.stream.stream,
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: thisOffset - leftOffset),
          child: Container(
            color: ((isSelected || (databaseConnectionManager.activeArtifact == table.schemaData)) ? DashColorLibrary.backgroundLight : Colors.transparent),
            child: Column(
              children: List<Widget>.generate(fields!.length, (index) { return Row(
                children: [
                  SizedBox(width: 2*leftOffset,),
                  Icon(getIcon(fields![index].fieldDataType)),
                  const SizedBox(width: 5),
                  Text(fields![index].fieldName),
                  const Spacer(),
                  Text((fields![index].isPk ? "<PK>" : (fields![index].isFk ? "<FK>" : "")))
                ],
              ); })
            ),
          ),
        );
      }
    );
  }
  /*
    ---------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------
  */

  @override
  Future<void> openRefresh() async {
    fields = await connection.describeTable(table: table);
  }
}
