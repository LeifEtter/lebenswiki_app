import 'package:lebenswiki_app/models/pack_content_models.dart';

class Pack {
  int id;
  String title;
  String description;
  String titleImage;
  bool published;
  //User? creator;
  int creatorId;
  final List categories;
  final List<CreatorPage> pages;

  Pack({
    this.id = 0,
    //required this.creator,
    required this.title,
    required this.description,
    required this.pages,
    required this.categories,
    required this.titleImage,
    this.published = false,
    required this.creatorId,
  });

  Pack.initial({
    this.id = 0,
    this.creatorId = 0,
    this.title = "",
    this.description = "",
    this.pages = const [],
    this.categories = const [],
    this.titleImage = "",
    this.published = false,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'titleImage': titleImage,
        'published': published,
        'categories': categories,
        'pages': List<dynamic>.from(
          pages.map((CreatorPage page) => page.toJson()),
        )
      };

  Pack.fromJson(Map json)
      : id = json["id"],
        title = json["title"],
        creatorId = json["creatorId"],
        description = json["description"],
        titleImage = json["titleImage"],
        categories = json["categories"],
        published = json["published"],
        pages = List<CreatorPage>.from(
            json["pages"].map((page) => CreatorPage.fromResponse(page)));
}
