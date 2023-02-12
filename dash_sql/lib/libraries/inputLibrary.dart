




import 'package:dash_sql/libraries/dashColorLibrary.dart';
import 'package:flutter/material.dart';

class DashInputLibrary {



  static Widget buildButton(context, {
    required Function(dynamic) callback,
    required Widget child,
    double? width,
    double? height,
    dynamic callbackArgs
  }) {
    return SizedBox(
      height: height, width: width,
      child: ElevatedButton(
        onPressed: () => callback(callbackArgs),
        style:  ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(DashColorLibrary.accentDark)
        ),
        child:  child,
      ),
    );
  }

}