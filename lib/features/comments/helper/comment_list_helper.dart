import 'package:lebenswiki_app/features/comments/models/comment_model.dart';

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

  void sortByDate() {
    comments.sort(
        (Comment a, Comment b) => b.creationDate.compareTo(a.creationDate));
  }

  void sortByVote() {
    comments
        .sort((Comment a, Comment b) => b.totalVotes.compareTo(a.totalVotes));
  }
}
