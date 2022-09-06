import 'package:lebenswiki_app/features/packs/models/pack_model.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/models/user_model.dart';

class Example {
  static List<Pack> examplePacks = [
    Pack(
      creator: User(
        name: "Fabian Christ",
      ),
      title: "Finanzen in deinen 20's",
      description:
          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod",
      pages: [],
      categories: [ContentCategory(id: 1, categoryName: "Finanzen")],
      titleImage: "",
      creatorId: 0,
      initiative: "Initiative",
      claps: 21,
    ),
    Pack(
      creator: User(
        name: "Peter Kurz",
      ),
      title: "Lebenslauf eine Seite lang",
      description:
          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod",
      pages: [],
      categories: [ContentCategory(id: 2, categoryName: "Beruf")],
      titleImage: "",
      creatorId: 0,
      initiative: "Initiative",
      claps: 15,
    ),
  ];
}
