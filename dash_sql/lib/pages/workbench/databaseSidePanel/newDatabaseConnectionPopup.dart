

import 'package:dash_sql/data/databaseConnection.dart';
import 'package:flutter/material.dart';

enum DatabaseType {
  mongoDb,
  mariaDb,
  redshiftDb
}

class NewDatabaseConnectionPopup extends StatefulWidget {

  /* ---------------------------------------------------------------------------- */
  DatabaseType                dbType                    = DatabaseType.mariaDb;
  final TextEditingController connectionNameC           = TextEditingController();
  final TextEditingController connectionCommentsC       = TextEditingController();

  final TextEditingController usernameC                 = TextEditingController();
  final TextEditingController passwordC                 = TextEditingController();
  bool                        savePassword              = false;

  final TextEditingController hostAddressC              = TextEditingController();
  final TextEditingController hostPortC                 = TextEditingController();

  bool                        sslRequired               = false;

  bool                        useSSH                    = false;
  final TextEditingController sshTunnelHostC            = TextEditingController();
  final TextEditingController sshTunnelPortC            = TextEditingController();
  final TextEditingController sshTunnelUsernameC        = TextEditingController();
  final TextEditingController sshTunnelPasswordC        = TextEditingController();
  bool                        sshPasswordAuthentication = false;
  final TextEditingController sshIdFile                 = TextEditingController();

  NewDatabaseConnectionPopup({super.key});

  /* ---------------------------------------------------------------------------- */
  DatabaseConnection? connection;
  bool get            isConfigured => connection!=null;
  /* ---------------------------------------------------------------------------- */

  static Future<bool> createNewDatabaseConnectionUI(context) async {
    NewDatabaseConnectionPopup connectionConfigPanel = NewDatabaseConnectionPopup();
    await showDialog(context: context, builder: (context) {
      return Dialog(
        child: connectionConfigPanel,
      );
    });
    return connectionConfigPanel.isConfigured;
  }
  
  @override
  State<StatefulWidget> createState() => _NewDatabaseConnectionPopup();


}


class _NewDatabaseConnectionPopup extends State<NewDatabaseConnectionPopup> {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () { Navigator.of(context).pop(); }, child: const Text("hi"));
  }


}