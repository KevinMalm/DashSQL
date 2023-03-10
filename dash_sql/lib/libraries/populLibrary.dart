



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashPopUplLibrary {


  static Future<String?> getUserInput(context, {Widget? title, String hint = "", bool obscure = false}) async {
    String?               result;
    TextEditingController controller = TextEditingController();

    await showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: title,
        content: TextFormField(
          onFieldSubmitted: (s) {
            result = controller.text;
            Navigator.of(context).pop();
          },
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: hint,
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: (){
              result = null;
              Navigator.of(context).pop();
            },
            child: const Text("Cancel")
          ),
            ElevatedButton(
              onPressed: (){
              result = controller.text;
              Navigator.of(context).pop();
            },
            child: const Text("Continue")
          ),
        ],
      );
    });


    return result;
  }



  static Future<int?> getUserConfirmation(context, {Widget? title, required List<Widget> options}) async {
    int? result;

    await showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: title,
        actions: List<Widget>.generate(options.length, (index) {
          return ElevatedButton(
            onPressed:  (){
              result = index;
              Navigator.of(context).pop();
            },
            child: options[index]
          );
        }),
      );
    });


    return result;
  }
}