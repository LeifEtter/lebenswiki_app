class QuizQuestion {
  final String question;
  final String correctAnswer;
  late List<String> _allAnswers;

  QuizQuestion(
      {required this.question,
      required this.correctAnswer,
      required List<String> wrongAnswers}) {
    (_allAnswers = wrongAnswers).add(correctAnswer);
    answers.shuffle();
  }

  List<String> get answers => _allAnswers;

  bool isAnswerCorrect(answer) => answer == correctAnswer;
}
