import 'package:lebenswiki_app/domain/models/comment_model.dart';

class CommentListHelper {
  List<Comment> comments = [];
  bool isSortedByDate = false;
  bool isSortedByVotes = false;

  CommentListHelper({
    required this.comments,
    required int currentUserId,
    required List<int> blockedList,
  }) {
    filterCommentsForBlocked(blockedList);
    initDisplayParams(currentUserId);
    sortByDate();
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
    isSortedByDate = true;
    isSortedByVotes = false;
  }

  void sortByVote() {
    comments
        .sort((Comment a, Comment b) => b.totalVotes.compareTo(a.totalVotes));
    isSortedByDate = false;
    isSortedByVotes = true;
  }
}
