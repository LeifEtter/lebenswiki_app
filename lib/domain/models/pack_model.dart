import 'package:lebenswiki_app/domain/models/comment_model.dart';
import 'package:lebenswiki_app/domain/models/pack_content_models.dart';
import 'package:lebenswiki_app/domain/models/category_model.dart';
import 'package:lebenswiki_app/domain/models/enums.dart';
import 'package:lebenswiki_app/domain/models/user_model.dart';
import 'package:lebenswiki_app/repository/constants/image_repo.dart';

class Pack {
  int? id;
  String title;
  String description;
  String titleImage;
  bool published = false;
  User? creator;
  int creatorId;
  List categories = [];
  List<PackPage> pages = [];
  List<User> bookmarks = [];
  List<Map> reactions = [];
  List<Comment> comments = [];
  late DateTime creationDate;

  //New Params
  String? initiative;
  int? readTime;
  int? claps;

  Pack({
    required this.title,
    required this.description,
    required this.pages,
    required this.categories,
    required this.titleImage,
    this.published = false,
    this.creator,
    required this.creatorId,
    this.bookmarks = const [],
    this.reactions = const [],
    this.initiative,
    this.readTime,
    this.claps,
    this.comments = const [],
  }) {
    creationDate = DateTime.now();
  }

  //Properties that aren't extracted from json
  bool bookmarkedByUser = false;
  bool reactedByUser = false;
  Map reactionMap = {};

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
        'initiative': initiative,
        'titleImage': titleImage,
        'categories': categories.isNotEmpty ? [categories.first.id] : [],
        'pages': List<dynamic>.from(
          pages.map((PackPage page) => page.toJson()),
        ),
        'readTime': readTime,
      };

  Pack.fromJson(Map json)
      : id = json["id"],
        title = json["title"],
        reactions =
            json["reactions"] != null ? List<Map>.from(json["reactions"]) : [],
        creator = User.forContent(json["creatorPack"]),
        creatorId = json["creatorId"],
        description = json["description"],
        titleImage = json["titleImage"],
        categories = List<ContentCategory>.from(
            json["categories"].map((cat) => ContentCategory.forContent(cat))),
        published = json["published"],
        bookmarks = json["bookmarks"] != null
            ? List<User>.from(json["bookmarks"].map((user) => User.forId(user)))
            : [],
        creationDate = DateTime.parse(json["creationDate"]),
        initiative = json["initiative"],
        readTime = json["readTime"],
        pages = List<PackPage>.from(
            json["pages"].map((page) => PackPage.fromResponse(page))),
        comments = List<Comment>.from(
            json["comments"].map((comment) => Comment.forPack(comment)));

  void initializeDisplayParams(int currentUserId) {
    _initHasBookmarked(currentUserId);
    _generateReactionMap();
    _setReactions(currentUserId);
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
