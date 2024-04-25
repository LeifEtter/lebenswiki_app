import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lebenswiki_app/domain/models/category.model.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/short.model.dart';
import 'package:lebenswiki_app/presentation/providers/category_provider.dart';
import 'package:lebenswiki_app/presentation/widgets/input/drop_down_menu.dart';
import 'package:lebenswiki_app/presentation/widgets/input/simplified_form_field.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
// import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav.dart';
import 'package:lebenswiki_app/data/short_api.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';
import 'package:lebenswiki_app/presentation/constants/shadows.dart';

class ShortCreationView extends ConsumerStatefulWidget {
  const ShortCreationView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShortCreationViewState();
}

class _ShortCreationViewState extends ConsumerState<ShortCreationView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  String? errorTitle;
  String? errorBody;

  late List<DropDownItem> dropdownItems;
  late DropDownItem chosenItem;

  @override
  void initState() {
    dropdownItems = ref
        .read(categoryProvider)
        .categories
        .skip(0)
        .toList()
        .map<DropDownItem>((Category cat) => DropDownItem(
              id: cat.id,
              name: cat.name,
            ))
        .toList();
    chosenItem = dropdownItems[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(top: 50),
        children: [
          TopNavIOS.withNextButton(
              title: "Erstelle ein Short",
              nextTitle: "Speichern",
              nextFunction: () async => createShort().fold(
                    (left) =>
                        CustomFlushbar.error(message: left.error).show(context),
                    (right) {
                      context.go("/created/shorts");
                      CustomFlushbar.success(message: "Short Erstellt")
                          .show(context);
                    },
                  )),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Kategorie Wählen",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomDropDownMenu(
                      shadows: [LebenswikiShadows.fancyShadow],
                      chosenValue: chosenItem,
                      onPress: (DropDownItem item) =>
                          setState(() => chosenItem = item),
                      items: dropdownItems,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SimplifiedFormField(
                  borderRadius: 15,
                  color: CustomColors.lightGrey,
                  controller: _titleController,
                  errorText: errorTitle,
                  labelText: "Titel*",
                  onChanged: (_) {
                    if (errorTitle != null) {
                      setState(() {
                        errorTitle = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                SimplifiedFormField.multiline(
                  minLines: 3,
                  maxLines: 5,
                  borderRadius: 15,
                  color: CustomColors.lightGrey,
                  controller: _bodyController,
                  errorText: errorBody,
                  labelText: "Inhalt*",
                  onChanged: (_) {
                    if (errorBody != null) {
                      setState(() {
                        errorBody = null;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Either<CustomError, String>> createShort() async {
    if (chosenItem.id == 0) {
      return const Left(
          CustomError(error: "Bitte wähle eine passende Kategorie"));
    }
    if (_titleController.text.isEmpty) {
      errorTitle = "Titel darf nicht leer sein";
    }
    if (_bodyController.text.isEmpty) {
      errorBody = "Inhalt darf nicht leer sein";
    }
    if (_titleController.text.isEmpty ||
        _bodyController.text.isEmpty ||
        chosenItem.id == 0) {
      setState(() {});
      return const Left(CustomError(error: "Bitte fülle alle Felder aus"));
    }

    Short short = Short(
      title: _titleController.text,
      content: _bodyController.text,
      categories: [Category(id: chosenItem.id, name: chosenItem.name)],
    );

    Either<CustomError, String> shortResult =
        await ShortApi().createShort(short);

    if (shortResult.isLeft && context.mounted == true) {
      log(shortResult.left.error);
      return Left(CustomError(
        error: shortResult.left.error,
      ));
    } else {
      return const Right("Short erfolgreich gespeichert");
    }
  }
}
