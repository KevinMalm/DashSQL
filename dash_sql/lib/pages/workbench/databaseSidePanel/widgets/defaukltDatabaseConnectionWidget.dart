

import 'package:dash_sql/data/databaseConnection.dart';
import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/libraries/populLibrary.dart';
import 'package:flutter/material.dart';

class DatabaseConnectionWidget extends StatefulWidget {

  final DatabaseConnection connection;

  DatabaseConnectionWidget({
    required this.connection,
    super.key
  });
  
  static Widget builder(DatabaseConnection connection) => DatabaseConnectionWidget(connection: connection);

  @override
  State<StatefulWidget> createState() => _DatabaseConnectionWidgetState();

}

class _DatabaseConnectionWidgetState extends State <DatabaseConnectionWidget> {


  Future<void> attemptLogin(context) async {
    String? password = await DashPopUplLibrary.getUserInput(context,
                                        title: Text("Password for ${widget.connection.name}"),
                                        hint: "password",
                                        obscure: true
                                      );
    if(password == null) { return; }
    String? error = await widget.connection.connect(password: password);
    if(error != null) {
      print(error);
      return;
    }
    /* --- rebuild with new connection --- */
    setState(() => widget.connection.connected = widget.connection.connected);
    return;
  }

  Future<void> discconect(context) async {
    int? option = await DashPopUplLibrary.getUserConfirmation(context, options: const [Text("Disconnect"), Text("Cancel")]);
    if((option == null) || (option == 1)) { return; }
    await widget.connection.disconnect();
    setState(() => widget.connection.connected = widget.connection.connected);
    return;
  }


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

  Widget buildHeader(context) {
    return Row(children: [
      Icon(Icons.data_array, color: (widget.connection.connected ? DashColorLibrary.bluePrimary : DashColorLibrary.backgroundBlack),),
      Text(widget.connection.name, style: TextStyle(color: Colors.grey),),
      const Spacer(),
      buildActionButton(context)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return buildHeader(context);
  }

}
