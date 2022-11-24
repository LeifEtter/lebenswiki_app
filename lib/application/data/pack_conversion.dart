import 'package:flutter/material.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';
import 'package:lebenswiki_app/domain/models/pack_content_models.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';
import 'package:lebenswiki_app/repository/constants/shadows.dart';

class PackComponentStyling {
  static titleContainerDecoration() => const BoxDecoration();
  static titleTextStyle() => const TextStyle();

  static textContainerDecoration() => const BoxDecoration();
  static textTextStyle() => const TextStyle();

  static listTitleContainerDecoration() => const BoxDecoration();
  static listTitleTextStyle() => const TextStyle();
}

class PackConversion {
  static toEditableItem(
    BuildContext context, {
    required PackPageItem item,
    required int index,
    required Function save,
    required Function addListItem,
    required Function reload,
    required Function(BuildContext, PackPageItem) uploadCallback,
  }) {
    switch (item.type) {
      case ItemType.list:
        return Column(
          children: [
            Container(
              decoration: PackComponentStyling.listTitleContainerDecoration(),
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                onEditingComplete: () => save(),
                controller: item.headContent.controller,
                /*decoration: PackEditorStyling.standardDecoration(
                      "Listen Titel eingeben")*/
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                children: List.generate(item.bodyContent.length, (index) {
                  //Set Current input item
                  PackPageItemInput currentInput = item.bodyContent[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            onEditingComplete: () => save(),
                            controller: currentInput.controller,
                            /*decoration: PackEditorStyling.standardDecoration(
                                "Listen Element eingeben"),*/
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red.shade200,
                          onPressed: () {
                            item.bodyContent.removeAt(index);
                            reload();
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => addListItem(),
            ),
          ],
        );

      case ItemType.title:
        return TextFormField(
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
      case ItemType.image:
        return GestureDetector(
          onTap: () => uploadCallback(context, item),
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
              child: _buildImageContainer(context, item),
            ),
          ),
        );
      case ItemType.text:
        return TextFormField(
          textCapitalization: TextCapitalization.sentences,
          onEditingComplete: () => save(),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 3,
          controller: item.headContent.controller,
          //decoration: PackEditorStyling.standardDecoration("Text eingeben"),
        );
      default:
        return Container();
    }
  }

  static _buildImageContainer(context, PackPageItem item) =>
      item.headContent.value.isNotEmpty
          ? Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.6),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  "Bild Ändern",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            )
          : Center(
              child: Text(
              "Wähle ein Bild",
              style: Theme.of(context).textTheme.labelSmall,
            ));

  static Widget toViewableItem(PackPageItem item) {
    switch (item.type) {
      case ItemType.list:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.headContent.value,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7, top: 4),
              child: Column(
                children: item.bodyContent
                    .map(
                        (PackPageItemInput input) => buildListItem(input.value))
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      case ItemType.title:
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Text(
            item.headContent.value,
            style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case ItemType.image:
        return Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Image.network(
            item.headContent.value,
            fit: BoxFit.contain,
            height: 250,
          ),
        );
      case ItemType.text:
        return Text(
          item.headContent.value,
          style: const TextStyle(fontSize: 18),
        );
      default:
        return const Text("Widget couldn't be identified");
    }
  }

  static Widget buildListItem(value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "•",
          style: TextStyle(
            fontSize: 25.0,
            height: 0.9,
          ),
        ),
        const SizedBox(width: 2.0),
        Expanded(
          child: Text(
            value,
          ),
        ),
      ],
    );
  }
}

class ConversionStyling {}
