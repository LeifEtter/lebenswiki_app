import 'package:lebenswiki_app/features/comments/models/comment_model.dart';

//TODO Add sort by date and sort by vote count
class CommentListHelper {
  List<Comment> comments = [];

  CommentListHelper({
    required this.comments,
    required int currentUserId,
    required List<int> blockedList,
  }) {
    filterCommentsForBlocked(blockedList);
    initDisplayParams(currentUserId);
  }

  void initDisplayParams(int currentUserId) {
    for (Comment comment in comments) {
      comment.initializeDisplayParams(currentUserId);
    }
  }

  void filterCommentsForBlocked(List<int> blockedList) {
    comments.removeWhere(
        (Comment comment) => blockedList.contains(comment.creator.id));
  }

  //void sortByDate
}
