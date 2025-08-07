import 'dart:io';
import 'package:ai_exam_evaluator/ai_exam_results_page.dart';
import 'package:ai_exam_evaluator/models/student_evaluation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AIExamInputPage extends StatefulWidget {
  const AIExamInputPage({super.key});

  @override
  State<AIExamInputPage> createState() => _AIExamInputPageState();
}

class _AIExamInputPageState extends State<AIExamInputPage> {
  final List<File> _images = [];
  final TextEditingController _promptController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  bool get _isSubmitDisabled =>
      _images.isEmpty || _promptController.text.trim().isEmpty;

  submit(BuildContext cxt) async {
    // Show loading dialog
    FocusManager.instance.primaryFocus?.unfocus();

    showDialog(
      context: cxt,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Text("Processing...", style: GoogleFonts.montserrat()),
              ],
            ),
          ),
        );
      },
    );

    try {
      final dio = Dio();
      final formData = FormData();

      // Add prompt
      formData.fields.add(
        MapEntry('correct_answer_key', _promptController.text.trim()),
      );

      // Add images
      for (var i = 0; i < _images.length; i++) {
        formData.files.add(
          MapEntry(
            'photos',
            await MultipartFile.fromFile(
              _images[i].path,
              filename: 'image_$i.jpg',
              contentType: DioMediaType('image', 'jpeg'),
            ),
          ),
        );
      }

      final response = await dio.post(
        'http://192.168.4.48:5678/webhook-test/2763badc-ef3c-46b5-8905-a402da11f89a',
        data: formData,
      );

      print('---------------response-----------------');
      print(response);
      print('--------------------------------');

      if (!mounted) return;
      Navigator.of(context).pop(); // close loading

      final result = response.data;
      if (result['status'] == true) {
        final data = result['data'];

        final List<StudentEvaluation> evaluations =
            (data as List).map((q) => StudentEvaluation.fromJson(q)).toList();

        // Navigate to result page with data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => AIExamResultsPage(studentEvaluations: evaluations),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: Failed to evaluate answers'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
          ),
        );
      }
    } catch (e) {
      if (cxt.mounted) {
        Navigator.of(cxt).pop(); // close loading
        ScaffoldMessenger.of(cxt).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AI Exam Evaluator",
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child:
            _images.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        "No images selected",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _pickImageFromCamera,
                        label: Text(
                          "Capture Image",
                          style: GoogleFonts.montserrat(),
                        ),
                        icon: Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
                )
                : ListView.builder(
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Image.file(
                        _images[index],
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _pickImageFromCamera,
        backgroundColor: Theme.of(context).primaryColor,
        shape: CircleBorder(),
        child: Icon(Icons.add_a_photo, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          top: 8,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _promptController,
                minLines: 2,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Prompt for correct answer',
                  hintStyle: GoogleFonts.montserrat(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 5),
            ElevatedButton(
              onPressed: () => _isSubmitDisabled ? null : submit(context),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isSubmitDisabled
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                padding: const EdgeInsets.all(15),
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}
