import 'package:flutter/material.dart';

class LocationInputDialog extends StatefulWidget {
  @override
  _LocationInputDialogState createState() => _LocationInputDialogState();
}

class _LocationInputDialogState extends State<LocationInputDialog> {
  TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Enter City Name"),
      content: TextField(
        controller: _cityController,
        decoration: InputDecoration(hintText: "e.g., Mumbai"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _cityController.text),
          child: Text("Set Location"),
        ),
      ],
    );
  }
}
