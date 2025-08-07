class StudentEvaluation {
  final String studentName;
  final String studentId;
  final List<QuestionEvaluation> questions;

  StudentEvaluation({
    required this.studentName,
    required this.studentId,
    required this.questions,
  });

  int get marksScored =>
      questions.where((q) => q.answered == q.correct).length;

  int get totalMarks => questions.length;

  factory StudentEvaluation.fromJson(Map<String, dynamic> json) {
    return StudentEvaluation(
      studentName: json['studentName'],
      studentId: json['studentId'],
      questions: (json['questions'] as List<dynamic>)
          .map((q) => QuestionEvaluation.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentName': studentName,
      'studentId': studentId,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

class QuestionEvaluation {
  final int questionNumber;
  final String answered;
  final String correct;

  QuestionEvaluation({
    required this.questionNumber,
    required this.answered,
    required this.correct,
  });

  factory QuestionEvaluation.fromJson(Map<String, dynamic> json) {
    return QuestionEvaluation(
      questionNumber: json['questionNumber'],
      answered: json['answered'],
      correct: json['correct'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionNumber': questionNumber,
      'answered': answered,
      'correct': correct,
    };
  }
}
