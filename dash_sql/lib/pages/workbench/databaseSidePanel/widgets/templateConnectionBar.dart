
import 'package:dash_sql/data/databaseConnection.dart';
import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:dash_sql/libraries/popupLibrary.dart';
import 'package:dash_sql/libraries/widgetLibrary.dart';
import 'package:flutter/material.dart';

class TemplateConnectionWidget extends StatefulWidget {
  final double                    leftOffset  = 30;

  final double                    thisOffset;
  bool                            expanded    = false;
  bool                            loading     = false;
  final DatabaseConnection        connection;
  _TemplateConnectionWidgetState? state;
  TemplateConnectionWidget({
    required this.connection,
    required this.thisOffset,
    super.key
  });
  

  @override
  State<StatefulWidget> createState() => _TemplateConnectionWidgetState();

  void setState(Function fn) {
    if(state != null) { state!.setState(() => fn());}
  }
  void openBody() {
    if(state != null) { state!.openBody();}
  }


  Future<void> openRefresh() async => throw UnimplementedError();
  Widget buildHeader(context) => throw UnimplementedError();
  Widget buildBody(context) => throw UnimplementedError();
}

class _TemplateConnectionWidgetState extends State<TemplateConnectionWidget> {

  @override
  void initState() {
    super.initState();
    widget.state = this;
  }

  /*
    ---------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------
  */
  

  void openBody() async {
    setState(() {
      widget.expanded = true;
      widget.loading  = true;
    });
    await widget.openRefresh();
    setState(() {
      widget.loading = false;
    });
  }


  /*
    ---------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------
  */


  /*
    ---------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------
  */


  Widget _buildBody(context) {
    if(widget.expanded) {
      if(widget.loading) { return DashWidgetLibrary.buildLoader(); }
      return widget.buildBody(context);
    }
    return const SizedBox();
  }

  /*
    ---------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------
  */

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    return Column(
      children: [
        widget.buildHeader(context),
        _buildBody(context)
      ],
    );
  }
}