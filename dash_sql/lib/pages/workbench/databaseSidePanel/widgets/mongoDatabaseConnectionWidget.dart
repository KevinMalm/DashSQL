

import 'package:dash_sql/data/connections/mongoDatabaseConnection.dart';
import 'package:dash_sql/data/databaseConnection.dart';
import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/libraries/populLibrary.dart';
import 'package:flutter/material.dart';

class MongoDatabaseConnectionWidget extends StatefulWidget {

  bool                    expanded = false;
  final MongoDbConnection connection;

  MongoDatabaseConnectionWidget({
    required this.connection,
    super.key
  });
  
  static Widget builder(DatabaseConnection connection) => MongoDatabaseConnectionWidget(connection: connection as MongoDbConnection);

  @override
  State<StatefulWidget> createState() => _MongoDatabaseConnectionWidgetState();

}

class _MongoDatabaseConnectionWidgetState extends State <MongoDatabaseConnectionWidget> {

  /*
    ---------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------
  */
  Future<bool> attemptLogin(context) async {
    String? password = await DashPopUplLibrary.getUserInput(context,
                                        title: Text("Password for ${widget.connection.name}"),
                                        hint: "password",
                                        obscure: true
                                      );
    if(password == null) { return false; }
    String? error = await widget.connection.connect(password: password);
    if(error != null) {
      print(error);
      return false;
    }
    /* --- rebuild with new connection --- */
    setState(() => widget.expanded = widget.connection.connected);
    return true;
  }

  Future<void> discconect(context) async {
    int? option = await DashPopUplLibrary.getUserConfirmation(context, options: const [Text("Disconnect"), Text("Cancel")]);
    if((option == null) || (option == 1)) { return; }
    await widget.connection.disconnect();
    setState(() => widget.connection.connected = widget.connection.connected);
    return;
  }

  Future<void> expandOutline(context) async {
    if(widget.expanded) {
      /* --- CASE: already expanded, so close --- */
      setState(() {
        widget.expanded = false;
      });
      return;
    }
      /* --- CASE: already expanded, so close --- */
    if(widget.connection.connected == false) {
      /* --- CASE: not connected, so attempt login --- */
      if((await attemptLogin(context)) == false) { return; }
    }
    setState(() {
      widget.expanded = true;
    });
  }

  /*
    ---------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------
  */

  /// When Connected: builds disconnect button
  /// When Disconnected: builds connection option
  Widget buildActionButton(context) {
    if(widget.connection.connected) {
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
        child: Icon(Icons.label_off, color: (widget.connection.connected ? DashColorLibrary.bluePrimary : DashColorLibrary.backgroundBlack),)),
    );
  }

  Widget buildHeader(context) {
    return Row(children: [
      buildLeadingIcon(context),
      Text(widget.connection.name, style: TextStyle(color: Colors.grey),),
      const Spacer(),
      buildActionButton(context)
    ]);
  }

  /*
    ---------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------
  */

  Widget buildBoy(context) {
    Widget body   = const SizedBox();
    double height = 0;
    if(widget.expanded) {
      height = 50;
      body = Text("ho");
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: height,
      child: body
    );
  }

  /*
    ---------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------
  */

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader(context),
        buildBoy(context)
      ],
    );
  }

}
