import 'package:lebenswiki_app/features/packs/models/pack_content_models.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/user_model.dart';
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
  List<User> bookmarks = [];
  List<Map> reactions = [];
  late DateTime creationDate;

  Pack({
    required this.title,
    required this.description,
    required this.pages,
    required this.categories,
    required this.titleImage,
    this.published = false,
    required this.creatorId,
    this.bookmarks = const [],
    this.reactions = const [],
  }) {
    creationDate = DateTime.now();
  }

  //Properties that aren't extracted from json
  bool bookmarkedByUser = false;
  bool reactedByUser = false;
  Map reactionMap = {};

  //TODO change image to local
  Pack.initial({
    this.creatorId = 0,
    this.title = "Titel",
    this.description = "Beschreibung",
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
        ),
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

  void initializeDisplayParams(int currentUserId) {
    _initHasBookmarked(currentUserId);
    _generateReactionMap();
  }

  void _initHasBookmarked(int currentUserId) {
    bookmarkedByUser = false;
    for (User user in bookmarks) {
      if (user.id == currentUserId) {
        bookmarkedByUser = true;
      }
    }
  }

  void _generateReactionMap() {
    Map result = {};
    for (var value in Reactions.values) {
      result[value.name] = 0;
    }
    reactionMap = result;
  }

  void _setReactions(int currentUserId) {
    for (Map reactionData in reactions) {
      if (reactionData.containsValue(currentUserId)) reactedByUser = true;
      String reactionName = reactionData["reaction"];
      reactionMap[reactionName.toLowerCase()] += 1;
    }
  }

  void react(int currentUserId, String reaction) {
    if (reactedByUser) {
      reactions.removeWhere((Map reaction) => reaction["id"] == currentUserId);
    }
    reactions.add({"id": currentUserId, "reaction": reaction});
    _generateReactionMap();
    _setReactions(currentUserId);
  }

  void toggleBookmarked(User user) {
    bookmarkedByUser
        ? bookmarks
            .removeWhere((User iteratedUser) => iteratedUser.id == user.id)
        : bookmarks.add(user);
    _initHasBookmarked(user.id);
  }
}
