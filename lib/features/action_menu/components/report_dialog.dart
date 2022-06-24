import 'package:flutter/material.dart';

class ReportDialog extends StatefulWidget {
  final Function reportCallback;
  final String? chosenReason;
  final contentData;

  const ReportDialog({
    Key? key,
    required this.reportCallback,
    required this.chosenReason,
    required this.contentData,
  }) : super(key: key);

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  List<String> reportReasons = <String>[
    "Illegal unter der NetzDG",
    "Spam",
    "Sexueller Inhalt",
    "Volksverhetzung",
    "Gewalt",
    "Mobbing/Belästigung",
    "Verletzung des Intelektuellen Eigentums",
    "Suizid oder Selbstverletzung",
    "Scam/Betrug",
    "Falsche Informationen",
    "Anderer Grund",
  ];

  String? chosenReason = "Spam";
  bool? blockUser = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: const Text("Short Melden"),
      actions: <Widget>[
        TextButton(
          child: const Text("Abbrechen"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("Melden"),
          onPressed: () {
            widget.reportCallback(chosenReason, blockUser, widget.contentData);
          },
        )
      ],
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: const [Text("Grund:")],
          ),
          DropdownButton<String>(
            isExpanded: true,
            value: chosenReason,
            items: reportReasons.map<DropdownMenuItem<String>>((String reason) {
              return DropdownMenuItem<String>(
                value: reason,
                child: Text(reason),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                chosenReason = value;
              });
            },
          ),
          Row(
            children: [
              const Text("User zukünftig blockieren?"),
              Checkbox(
                value: blockUser,
                onChanged: (value) {
                  setState(() {
                    blockUser = value;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
