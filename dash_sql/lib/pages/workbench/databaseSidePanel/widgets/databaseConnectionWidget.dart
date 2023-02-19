

import 'package:dash_sql/data/databaseConnection.dart';
import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/libraries/popupLibrary.dart';
import 'package:dash_sql/libraries/widgetLibrary.dart';
import 'package:dash_sql/pages/workbench/databaseSidePanel/widgets/schemaConnectionWidget.dart';
import 'package:dash_sql/pages/workbench/databaseSidePanel/widgets/templateConnectionWidget.dart';
import 'package:flutter/material.dart';

class DatabaseConnectionWidget extends TemplateConnectionWidget {
  
  bool                     expanded             = false;
  late List<String>?       loadedSchemas;

  DatabaseConnectionWidget({
    required super.connection,
    required super.thisOffset,
    super.key
  });
  
  /*
    ---------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------
  */
  Future<bool> attemptLogin(context) async {
    String? password = await DashPopUpLibrary.getUserInput(context,
                                        title: Text("Password for ${connection.name}"),
                                        hint: "password",
                                        obscure: true
                                      );
    if(password == null) { return false; }
    String? error = await connection.connect(password: password);
    if(error != null) {
      print(error);
      return false;
    }
    /* --- rebuild with new connection --- */
    if(connection.connected) {
      openBody();
    }
    return true;
  }

  Future<void> discconect(context) async {
    int? option = await DashPopUpLibrary.getUserConfirmation(context, options: const [Text("Disconnect"), Text("Cancel")]);
    if((option == null) || (option == 1)) { return; }
    await connection.disconnect();
    setState(() => connection.connected = connection.connected);
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
      /* --- CASE: already expanded, so close --- */
    if(connection.connected == false) {
      /* --- CASE: not connected, so attempt login --- */
      if((await attemptLogin(context)) == false) { return; }
    }
    openBody();
  }

  /// When Connected: builds disconnect button
  /// When Disconnected: builds connection option
  Widget buildActionButton(context) {
    if(connection.connected) {
      /* --------- ACTION: disconnect --------- */
      return GestureDetector(
        onTap: () => discconect(context),
        child: const MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Icon(Icons.link_off),
        ),
      );
    }
    /* --------- ACTION: connect --------- */
    return GestureDetector(
      onTap: () => attemptLogin(context),
      child: const MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Icon(Icons.link),
        ),
    );
  }

  Widget buildLeadingIcon(context) {
    return GestureDetector(
      onTap: () => expandOutline(context),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Icon(Icons.label_off, color: (connection.connected ? DashColorLibrary.bluePrimary : DashColorLibrary.backgroundBlack),)),
    );
  }


  @override
  Widget buildHeader(context) { return Row(
    children: [
      buildLeadingIcon(context),
      Text(connection.name, style: const TextStyle(color: Colors.grey),),
      const Spacer(),
      buildActionButton(context)
    ],
  ); }
  
  /*
    ---------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------
  */

  Widget buildBody(context) {
    if(loadedSchemas == null) { return const Text("Errors"); }
    return Column(children: List<Widget>.generate(loadedSchemas!.length, (index) => SchemaConnectionWidget(
                                                                                        connection: connection,
                                                                                        thisOffset: thisOffset + leftOffset,
                                                                                        schema: loadedSchemas![index])));
  }

  /*
    ---------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------
  */

  @override
  Future<void> openRefresh() async {
    loadedSchemas = await connection.listSchemas();
  }

}
