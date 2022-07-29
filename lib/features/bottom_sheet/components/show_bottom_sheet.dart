import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/bottom_sheet/components/bottom_sheet_item.dart';

void showActionsMenuForComments(
  BuildContext context, {
  required Function reportCallback,
}) =>
    showActionsMenu(context, menuItems: [
      basicMenuItem(
        Icons.flag,
        "Melden",
        "Diesen Kommentar melden",
        () => reportCallback(),
      ),
    ]);

void showActionsMenuForPacks(BuildContext context) =>
    showActionsMenu(context, menuItems: [
      basicMenuItem(
        Icons.flag,
        "Melden",
        "Dieses Pack melden",
        () => {} /*_reportDialog(contentId: contentId, creatorId: creatorId)*/,
      ),
      basicMenuItem(
        Icons.comment_outlined,
        "Kommentieren",
        "Schreibe einen Kommentar",
        () {},
      ),
      basicMenuItem(
        Icons.bookmark_outline,
        "Speichern",
        "Zu gespeicherten Packs hinzufügen",
        () {},
      ),
    ]);

void showActionsMenuForShorts(
  BuildContext context, {
  required bool isBookmarked,
  required Function bookmarkCallback,
  required Function reportCallback,
}) =>
    showActionsMenu(context, menuItems: [
      basicMenuItem(
        Icons.flag,
        "Melden",
        "Diesen Short melden",
        () {
          Navigator.pop(context);
          reportCallback();
        },
      ),
      basicMenuItem(
        Icons.comment_outlined,
        "Kommentieren",
        "Schreibe einen Kommentar",
        () {},
      ),
      isBookmarked
          ? basicMenuItem(
              Icons.bookmark_remove,
              "Entfernen",
              "Von gespeicherten Shorts entfernen",
              () {
                Navigator.pop(context);
                bookmarkCallback();
              },
            )
          : basicMenuItem(
              Icons.bookmark_add_outlined,
              "Speichern",
              "Zu gespeicherten Shorts hinzufügen",
              () {
                Navigator.pop(context);
                bookmarkCallback();
              },
            ),
    ]);

void showActionsMenu(BuildContext context, {required List<Widget> menuItems}) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    context: context,
    builder: (context) {
      return Container(
        height: 300,
        padding: const EdgeInsets.only(top: 20.0, left: 30.0),
        child: Column(
          children: List.from(menuItems),
        ),
      );
    },
    isDismissible: true,
  );
}
