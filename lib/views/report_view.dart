import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/input/input_styling.dart';

class ReportView extends StatefulWidget {
  final Map packData;

  const ReportView({
    Key? key,
    required this.packData,
  }) : super(key: key);

  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  String? chosenReason = "Illegal unter der NetzDG";
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
  bool? blockUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            CloseButton(),
          ],
        ),
        const Text("Report Short"),
        DropdownButton<String>(
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
    ));
  }
}
