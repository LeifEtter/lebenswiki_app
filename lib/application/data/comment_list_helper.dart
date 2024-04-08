import 'package:lebenswiki_app/domain/models/comment.model.dart';

class CommentListHelper {
  List<Comment> comments = [];
  bool isSortedByDate = false;
  bool isSortedByVotes = false;

  CommentListHelper({
    required this.comments,
    required int currentUserId,
    required List<int> blockedList,
  }) {
    sortByDate();
  }

  void sortByDate() {
    comments.sort(
        (Comment a, Comment b) => b.creationDate.compareTo(a.creationDate));
    isSortedByDate = true;
    isSortedByVotes = false;
  }

  void sortByVote() {
    comments.sort((Comment a, Comment b) => b.voteCount.compareTo(a.voteCount));
    isSortedByDate = false;
    isSortedByVotes = true;
  }
}
