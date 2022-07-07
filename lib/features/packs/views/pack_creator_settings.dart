import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/common/components/tab_bar.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/pack_model.dart';
import 'package:lebenswiki_app/features/packs/views/pack_creator_overview.dart';
import 'package:lebenswiki_app/features/menu/views/your_creator_packs.dart';
import 'package:lebenswiki_app/features/common/components/nav/top_nav.dart';
import 'package:lebenswiki_app/providers/providers.dart';
import 'package:lebenswiki_app/repository/shadows.dart';

class EditorSettings extends ConsumerStatefulWidget {
  final Pack pack;

  const EditorSettings({
    Key? key,
    required this.pack,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditorSettingsState();
}

class _EditorSettingsState extends ConsumerState<EditorSettings> {
  late Pack pack;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageLinkController = TextEditingController();
  int currentCategory = 0;

  @override
  void initState() {
    pack = widget.pack;
    titleController.text = pack.title;
    descriptionController.text = pack.description;
    imageLinkController.text = pack.titleImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ContentCategory> categories = ref.watch(categoryProvider).categories;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(top: 0),
        children: [
          TopNavCustom(
            pageName: "Informationen",
            backName: "Deine Packs",
            nextName: "Weiter",
            previousCallback: _previousPage,
            nextCallback: _nextPage,
          ),
          DefaultTabController(
            length: categories.length,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Kategorie",
                    style: _labelStyle(),
                  ),
                  const SizedBox(height: 20.0),
                  buildTabBar(
                      categories: categories,
                      callback: (int value) {
                        currentCategory = value;
                      }),
                  const SizedBox(height: 20),
                  Text("Titel", style: _labelStyle()),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: _inputStyle(),
                    child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        hintText: "Titel",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Beschreibung",
                    style: _labelStyle(),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: _inputStyle(),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: descriptionController,
                      minLines: 3,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        hintText: "Schreibe eine kurze Beschreibung",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text("Bild", style: _labelStyle()),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: _inputStyle(),
                    child: TextField(
                      controller: imageLinkController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        hintText: "Link für Bild",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration _inputStyle() {
    return BoxDecoration(
      boxShadow: [
        LebenswikiShadows().fancyShadow,
      ],
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  TextStyle _labelStyle() {
    return const TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.black54,
    );
  }

  //TODO improve routing
  void _nextPage() {
    pack.description = descriptionController.text;
    pack.title = titleController.text;
    pack.titleImage = imageLinkController.text;

    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => Editor(pack: pack))));
  }

  void _previousPage() {
    pack.description = descriptionController.text;
    pack.title = titleController.text;
    pack.titleImage = imageLinkController.text;

    Navigator.push(context, _backRoute());
  }

  Route _backRoute() {
    return PageRouteBuilder(
        pageBuilder: ((context, animation, secondaryAnimation) =>
            const YourCreatorPacks()),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }
}
