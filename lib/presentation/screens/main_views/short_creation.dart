import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';
import 'package:lebenswiki_app/domain/models/short_model.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/input/drop_down_menu.dart';
import 'package:lebenswiki_app/presentation/widgets/input/simplified_form_field.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/presentation/widgets/navigation/top_nav.dart';
import 'package:lebenswiki_app/repository/backend/short_api.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';
import 'package:lebenswiki_app/repository/constants/shadows.dart';

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

  String chosenCategory = "Neu";
  late List<ContentCategory> categories;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    categories = ref.read(categoryProvider).categories;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(top: 50),
        children: [
          TopNavIOS.withNextButton(
            title: "Erstelle ein Short",
            nextTitle: "Speichern",
            nextFunction: () => createShort(),
          ),
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
                      chosenValue: chosenCategory,
                      onPress: (newCategory) => setState(() {
                        chosenCategory = newCategory;
                      }),
                      items: List<String>.from(categories
                          .map((ContentCategory cat) => cat.categoryName)
                          .toList()),
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

  void createShort() async {
    if (_titleController.text.isEmpty) {
      errorTitle = "Titel darf nicht leer sein";
    }
    if (_bodyController.text.isEmpty) {
      errorBody = "Inhalt darf nicht leer sein";
    }
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      setState(() {});
      return;
    }

    await ShortApi()
        .createShort(
            short: Short(
                id: 0,
                creationDate: DateTime.now(),
                creator: User(name: "Null"),
                title: _titleController.text,
                content: _bodyController.text,
                categories: [
          categories
              .where(
                  (ContentCategory cat) => cat.categoryName == chosenCategory)
              .first
        ]))
        .fold((left) {
      CustomFlushbar.error(message: left.error).show(context);
    }, (right) async {
      Navigator.pop(context);
      CustomFlushbar.success(message: right).show(context);
    });
  }
}
