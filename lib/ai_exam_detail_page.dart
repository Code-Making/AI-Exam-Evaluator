import 'package:ai_exam_evaluator/models/student_evaluation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AIExamDetailPage extends StatelessWidget {
  final StudentEvaluation studentEvaluation;

  const AIExamDetailPage({super.key, required this.studentEvaluation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studentEvaluation.studentName,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "ID: ${studentEvaluation.studentId}",
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      color: Colors.grey[200],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${studentEvaluation.marksScored}/${studentEvaluation.totalMarks}",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          child: DataTable(
            columnSpacing: 24,
            horizontalMargin: 0,
            columns: [
              DataColumn(
                label: Text(
                  'Q.No',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                ),
              ),
              DataColumn(
                label: Text(
                  'Answered',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                ),
              ),
              DataColumn(
                label: Text(
                  'Correct',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                ),
              ),
            ],
            rows:
                studentEvaluation.questions.map((q) {
                  final isCorrect = q.answered == q.correct;
                  final isUnattempted = q.answered == 'NA';
                  return DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>((
                      Set<MaterialState> states,
                    ) {
                      if (isUnattempted) return Colors.grey.shade100;
                      return isCorrect
                          ? Colors.green.shade50
                          : Colors.red.shade50;
                    }),
                    cells: [
                      DataCell(
                        Text(
                          q.questionNumber.toString(),
                          style: GoogleFonts.montserrat(),
                        ),
                      ),
                      DataCell(
                        Text(
                          q.answered,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            color:
                                q.answered == q.correct
                                    ? Colors.green
                                    : Colors.redAccent,
                          ),
                        ),
                      ),

                      DataCell(
                        Text(
                          q.correct,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(),
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
