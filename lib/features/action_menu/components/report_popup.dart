import 'package:flutter/material.dart';
import 'package:lebenswiki_app/api/report_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/models/pack_model.dart';
import 'package:lebenswiki_app/models/report_model.dart';
import 'package:lebenswiki_app/models/short_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/repos/misc_repo.dart';

void reportCallback(
  BuildContext context, {
  required String reason,
  required bool blockUser,
  required int contentId,
  required int creatorId,
  required Function reload,
}) {
  blockUser ? UserApi().blockUser(id: creatorId, reason: reason) : null;
  ReportApi()
      .reportPack(
          report: Report(
    reason: reason,
    reportedContentId: contentId,
    creationDate: DateTime.now(),
  ))
      .whenComplete(() {
    reload();
    Navigator.pop(context);
    Navigator.pop(context);
  });
}

void showReportDialog(
  BuildContext context,
  Function reload,
  Map reportedContent,
) =>
    showDialog(
        context: context,
        builder: (context) => ReportDialog(reportCallback: (reason, blockUser) {
              reportCallback(context,
                  contentId: reportedContent["id"],
                  creatorId: reportedContent["creatorId"],
                  reason: reason,
                  blockUser: blockUser,
                  reload: reload);
            }));

class ReportDialog extends StatefulWidget {
  final Function(String, bool) reportCallback;

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
            onPressed: () => widget.reportCallback(chosenReason, blockUser),
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
