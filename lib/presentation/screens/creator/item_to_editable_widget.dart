import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lebenswiki_app/domain/models/pack/pack_page.model.dart';
import 'package:lebenswiki_app/presentation/constants/lebenswiki_icons.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';
import 'package:lebenswiki_app/presentation/constants/shadows.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class ItemToEditableWidget {
  final BuildContext context;
  final Function save;
  final Function uploadImage;
  final Function reload;
  final Function orderingOn;

  bool isOrdering = false;

  ItemToEditableWidget({
    required this.context,
    required this.save,
    required this.uploadImage,
    required this.reload,
    required this.orderingOn,
  });

  Widget convert({
    required PackPageItem item,
    required Function deleteSelf,
  }) {
    switch (item.type) {
      case ItemType.title:
        if (item.notDeletable != null && item.notDeletable == true) {
          return _titleWidget(item);
        } else {
          return _slidableWrapper(
            child: _titleWidget(item),
            deleteSelf: deleteSelf,
          );
        }

      case ItemType.text:
        return _slidableWrapper(
          child: _textWidget(item),
          deleteSelf: deleteSelf,
        );
      case ItemType.list:
        return _slidableWrapper(
          child: _listWidget(item),
          deleteSelf: deleteSelf,
        );
      case ItemType.quiz:
        return Container();
      case ItemType.image:
        return _slidableWrapper(
          child: _imageWidget(item),
          deleteSelf: deleteSelf,
        );
      case ItemType.question:
        return _slidableWrapper(
            child: _questionWidget(item), deleteSelf: deleteSelf);
    }
  }

  Widget _slidableWrapper(
      {required Widget child, required Function deleteSelf}) {
    return Slidable(
      child: child,
      endActionPane: ActionPane(
        extentRatio: 0.1,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            borderRadius: BorderRadius.circular(5),
            onPressed: (context) => deleteSelf(),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _titleWidget(PackPageItem item) {
    return TextFormField(
      enabled: !isOrdering,
      style: const TextStyle(
        fontSize: 23.0,
      ),
      textCapitalization: TextCapitalization.sentences,
      onEditingComplete: () => save(),
      controller: item.headContent.controller,
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: CustomColors.outlineBlue),
        ),
        contentPadding: const EdgeInsets.only(left: 10),
        hintText: "Titel Hinzufügen",
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.outlineBlue, width: 2),
        ),
      ),
    );
  }

  Widget _textWidget(PackPageItem item) => TextFormField(
        enabled: !isOrdering,
        textCapitalization: TextCapitalization.sentences,
        onEditingComplete: () => save(),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: 1,
        controller: item.headContent.controller,
        style: const TextStyle(fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: CustomColors.outlineBlue),
          ),
          hintText: "Text Hinzufügen",
          hintStyle: const TextStyle(fontWeight: FontWeight.w400),
          contentPadding: const EdgeInsets.only(left: 11, top: 10, bottom: 10),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColors.outlineBlue, width: 2),
          ),
        ),
      );

  Widget _imageWidget(PackPageItem item) => GestureDetector(
        onTap: () => uploadImage(item),
        child: Container(
          padding:
              const EdgeInsets.only(right: 10, top: 10, bottom: 10, left: 10),
          decoration: BoxDecoration(
            border: isOrdering
                ? Border.all(width: 2, color: CustomColors.outlineBlue)
                : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [LebenswikiShadows.fancyShadow],
              color: Colors.white,
              image: item.headContent.value.isNotEmpty
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        item.headContent.value.replaceAll("https", "http"),
                      ))
                  : null,
            ),
            width: double.infinity,
            height: 200,
            child: _buildImageContainer(item),
          ),
        ),
      );

  Widget _buildImageContainer(PackPageItem item) =>
      item.headContent.value.isNotEmpty
          ? Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.6),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: const Text("Bild Ändern"),
              ),
            )
          : const Center(child: Text("Wähle ein Bild"));

  Widget _listWidget(PackPageItem item) {
    return Container(
      decoration: BoxDecoration(
        border: isOrdering
            ? Border.all(width: 2, color: CustomColors.outlineBlue)
            : null,
      ),
      child: Column(
        children: [
          TextFormField(
            enabled: !isOrdering,
            controller: item.headContent.controller,
            textCapitalization: TextCapitalization.sentences,
            onEditingComplete: () => save(),
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: "Titel",
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 10),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: CustomColors.outlineBlue, width: 2),
              ),
            ),
          ),
          ...item.bodyContent.map((PackPageItemContent input) => Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: Icon(Icons.circle,
                        size: 7, color: CustomColors.darkGrey),
                  ),
                  Expanded(
                    child: TextFormField(
                      enabled: !isOrdering,
                      textCapitalization: TextCapitalization.sentences,
                      onEditingComplete: () => save(),
                      controller: input.controller,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        constraints: const BoxConstraints(maxHeight: 30),
                        contentPadding:
                            const EdgeInsets.only(left: 10, bottom: 10),
                        hintText: "Stichpunkt",
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: CustomColors.outlineBlue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    constraints:
                        const BoxConstraints(minHeight: 30, minWidth: 40),
                    padding: EdgeInsets.zero,
                    icon: Icon(LebenswikiIcons.trash,
                        size: 18, color: CustomColors.darkGrey),
                    onPressed: () {
                      item.bodyContent.remove(input);
                      reload();
                    },
                  ),
                  const SizedBox(width: 30),
                ],
              )),
          IconButton(
            icon: const Icon(Icons.add),
            padding: const EdgeInsets.only(bottom: 20),
            onPressed: () {
              TextEditingController newController = TextEditingController();
              newController.text = "";
              item.bodyContent.add(PackPageItemContent(
                  controller: newController, id: uuid.v4()));
              reload();
            },
          )
        ],
      ),
    );
  }

  Widget _questionWidget(PackPageItem item) {
    PackPageItemContent rightAnswer = item.bodyContent
        .where(
          (item) => item.isCorrectAnswer == true,
        )
        .first;
    return Container(
      decoration: BoxDecoration(
        border: isOrdering
            ? Border.all(width: 2, color: CustomColors.outlineBlue)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          TextFormField(
            enabled: !isOrdering,
            controller: item.headContent.controller,
            textCapitalization: TextCapitalization.sentences,
            onEditingComplete: () => save(),
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              labelText: "Frage",
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 10),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: CustomColors.outlineBlue, width: 2),
              ),
            ),
          ),
          TextFormField(
            enabled: !isOrdering,
            controller: rightAnswer.controller,
            textCapitalization: TextCapitalization.sentences,
            onEditingComplete: () => save(),
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              labelText: "Richtige Antwort",
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 10),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: CustomColors.outlineBlue, width: 2),
              ),
            ),
          ),
          ...item.bodyContent.where((x) => x.isCorrectAnswer == null).map(
                (PackPageItemContent bodyItem) => TextFormField(
                  enabled: !isOrdering,
                  controller: bodyItem.controller,
                  textCapitalization: TextCapitalization.sentences,
                  onEditingComplete: () => save(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    labelText: "Falsche Antwort",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 10),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: CustomColors.outlineBlue, width: 2),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
