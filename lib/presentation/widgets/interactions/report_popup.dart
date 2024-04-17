import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lebenswiki_app/presentation/constants/misc_repo.dart';

class ReportDialog extends StatefulWidget {
  final Function reportCallback;
  final String resourceName;

  const ReportDialog({
    super.key,
    required this.resourceName,
    required this.reportCallback,
  });

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  String chosenReason = "Spam";
  bool blockUser = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          // bottom: MediaQuery.of(context).size.height * 0.35,
          // top: MediaQuery.of(context).size.height * 0.10,
          ),
      child: AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: Text("${widget.resourceName} Melden"),
        actions: <Widget>[
          TextButton(
            child: const Text("Abbrechen"),
            onPressed: () => context.pop(),
          ),
          TextButton(
              child: const Text("Melden"),
              onPressed: () {
                context.pop();
                widget.reportCallback(blockUser, chosenReason);
              })
        ],
        content: Container(
          height: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Row(
                children: [Text("Grund:")],
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
      ),
    );
  }
}
