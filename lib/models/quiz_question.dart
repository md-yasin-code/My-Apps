class QuizQuestion {
  const QuizQuestion({required this.question, required this.options, required this.answer, required this.explanation, required this.level});
  final String question, answer, explanation, level;
  final List<String> options;
}
