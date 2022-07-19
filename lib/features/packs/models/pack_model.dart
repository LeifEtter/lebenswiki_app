import 'package:lebenswiki_app/features/packs/models/pack_content_models.dart';
import 'package:lebenswiki_app/repository/image_repo.dart';

class Pack {
  int? id;
  String title;
  String description;
  String titleImage;
  bool published = false;
  //User? creator;
  int creatorId;
  List categories = [];
  List<PackPage> pages = [];
  late DateTime creationDate;

  Pack({
    required this.title,
    required this.description,
    required this.pages,
    required this.categories,
    required this.titleImage,
    this.published = false,
    required this.creatorId,
  }) {
    creationDate = DateTime.now();
  }

  Pack.initial({
    this.creatorId = 0,
    this.title = "",
    this.description = "",
    this.titleImage = ImageRepo.packPlaceholderImage,
    this.published = false,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'titleImage': titleImage,
        'published': published,
        'categories': categories,
        'pages': List<dynamic>.from(
          pages.map((PackPage page) => page.toJson()),
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
        creationDate = DateTime.parse(json["creationDate"]),
        pages = List<PackPage>.from(
            json["pages"].map((page) => PackPage.fromResponse(page)));
}
