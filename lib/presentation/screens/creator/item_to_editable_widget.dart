import 'package:flutter/material.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';
import 'package:lebenswiki_app/domain/models/pack_content_models.dart';
import 'package:lebenswiki_app/lebenswiki_icons.dart';
import 'package:lebenswiki_app/presentation/widgets/common/border.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';
import 'package:lebenswiki_app/repository/constants/shadows.dart';

class ItemToEditableWidget {
  final Function save;
  final Function uploadImage;
  final Function reload;

  ItemToEditableWidget({
    required this.save,
    required this.uploadImage,
    required this.reload,
  });

  Widget convert({
    required PackPageItem item,
  }) {
    switch (item.type) {
      case ItemType.title:
        return _titleWidget(item);
      case ItemType.text:
        return _textWidget(item);
      case ItemType.list:
        return _listWidget(item);
      case ItemType.quiz:
        return Container();
      case ItemType.image:
        return _imageWidget(item);
    }
  }

  Widget _titleWidget(PackPageItem item) => TextFormField(
        style: const TextStyle(
          fontSize: 20.0,
        ),
        textCapitalization: TextCapitalization.sentences,
        onEditingComplete: () => save(),
        controller: item.headContent.controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 10),
          hintText: "Titel Hinzufügen",
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColors.outlineBlue, width: 2),
          ),
        ),
      );

  Widget _textWidget(PackPageItem item) => TextFormField(
        textCapitalization: TextCapitalization.sentences,
        onEditingComplete: () => save(),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: 3,
        controller: item.headContent.controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 10),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColors.outlineBlue, width: 2),
          ),
        ),
      );

  Widget _imageWidget(PackPageItem item) => GestureDetector(
        onTap: () => uploadImage(item),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [LebenswikiShadows.fancyShadow],
              color: Colors.white,
              image: item.headContent.value.isNotEmpty
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        item.headContent.value,
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
    return Column(
      children: [
        TextFormField(
          controller: item.headContent.controller,
          textCapitalization: TextCapitalization.sentences,
          onEditingComplete: () => save(),
          decoration: InputDecoration(
            hintText: "Titel",
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(left: 10),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: CustomColors.outlineBlue, width: 2),
            ),
          ),
        ),
        ...item.bodyContent.map((PackPageItemInput input) => Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child:
                      Icon(Icons.circle, size: 7, color: CustomColors.darkGrey),
                ),
                Expanded(
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    onEditingComplete: () => save(),
                    controller: input.controller,
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
          padding: const EdgeInsets.only(top: 10),
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.add),
          onPressed: () {
            TextEditingController newController = TextEditingController();
            newController.text = "";
            item.bodyContent.add(PackPageItemInput(controller: newController));
            reload();
          },
        )
      ],
    );
  }
}
