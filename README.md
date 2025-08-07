# AI Exam Evaluator

A Flutter app to evaluate multiple-choice exam answer sheets using AI. Built with Flutter and integrated with an n8n workflow backend.

---

## 🧠 Features

- Capture answer sheet images using camera
- Enter correct answer key as prompt
- Upload images + prompt to AI backend via n8n
- Automatically extract:
  - Student Name
  - Student ID
  - Answers
- Compare answers with the correct key
- Show marks scored per student
- View detailed question-wise results

---

## 📱 Screens

1. **Input Page** – Pick images and enter correct answer key
2. **Results Page** – List of students with scores
3. **Detail Page** – Table of answered vs correct answers

---

## 🌐 Backend (n8n AI Integration)

This app uses **[n8n](https://n8n.io/)** as the backend for AI-based image processing.

- **API Endpoint**:  
  `http://localhost:5678/webhook-test/2763badc-ef3c-46b5-8905-a402da11f89a`

- **Request Type**: `POST`  
  **Content-Type**: `multipart/form-data`

- **FormData Fields**:
  - `correct_answer_key`: The prompt string entered by user
  - `photos`: List of captured image files

- **Expected Response**:
```json
{
  "status": true,
  "data": [
    {
      "studentName": "Bala",
      "studentId": "237514",
      "questions": [
        {
          "questionNumber": 1,
          "answered": "A",
          "correct": "A"
        }
      ]
    }
  ]
}
