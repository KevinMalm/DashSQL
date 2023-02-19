
import 'package:dash_sql/data/databaseConnection.dart';
import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/pages/workbench/databaseSidePanel/widgets/templateConnectionWidget.dart';
import 'package:flutter/material.dart';

class TableConnectionWidget extends TemplateConnectionWidget {

  final String                schema;
  final String                table;
  List<TableFieldDefinition>? fields;
  TableConnectionWidget({
    super.key,
    required super.connection,
    required this.schema,
    required this.table,
    required super.thisOffset
  });


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
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(table, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey),),
      ),
    );
  }

  Widget buildLeadingIcon(context) {
    return GestureDetector(
      onTap: () => expandOutline(context),
      child: const MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Icon(Icons.table_chart)),
    );
  }

  /*
    ---------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------
  */

  @override
  Widget buildHeader(context) { return Row(
    children: [
      SizedBox(width: thisOffset),
      buildLeadingIcon(context),
      const SizedBox(width: 5),
      buildTableName(context),
    ],
  ); }

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
    return Column(
      children: List<Widget>.generate(fields!.length, (index) { return Row(
        children: [
          SizedBox(width: thisOffset+leftOffset,),
          Icon(getIcon(fields![index].fieldType)),
          const SizedBox(width: 5),
          Text(fields![index].fieldName),
          const Spacer(),
          Text((fields![index].isPk ? "<PK>" : (fields![index].isFk ? "<FK>" : "")))
        ],
      ); })
    );
  }
  /*
    ---------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------
  */

  @override
  Future<void> openRefresh() async {
    fields = await connection.describeTable(schema: schema, table: table);
  }
}