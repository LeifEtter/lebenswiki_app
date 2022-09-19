import 'package:flutter/material.dart';
import 'package:lebenswiki_app/repository/constants/misc_repo.dart';

class ReportDialog extends StatefulWidget {
  final Function reportCallback;

  const ReportDialog({
    Key? key,
    required this.reportCallback,
  }) : super(key: key);

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  String chosenReason = "Spam";
  bool blockUser = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.35,
        top: MediaQuery.of(context).size.height * 0.21,
      ),
      child: AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: const Text("Short Melden"),
        actions: <Widget>[
          TextButton(
            child: const Text("Abbrechen"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Melden"),
            onPressed: () => widget.reportCallback(blockUser, chosenReason),
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
              items: MiscRepo.reportReasons
                  .map<DropdownMenuItem<String>>((String reason) {
                return DropdownMenuItem<String>(
                  value: reason,
                  child: Text(reason),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  chosenReason = value!;
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
                      blockUser = value!;
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
