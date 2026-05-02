import 'package:flutter/material.dart';
import 'question.dart';

void main() => runApp(const Quizzler());

class Quizzler extends StatelessWidget {
  const Quizzler({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 42, 42, 42),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Widget> scoreKeeper = [];
  int questionNumber = 0;
  int totalScore = 0;
  bool isFinished = false;

  List<Question> questionBank = [
    Question(
      'If 2+2 = 4, then the speed of light is 299,792,458 meters per second.',
      true,
    ),
    Question('Cats were actually the ruler of the universe.', false),
    Question('Human body contains 206 bones.', true),
    Question(
      'One of the cats said they were the ruler of the universe so it\'s probably true.',
      false,
    ),
    Question('Us human used to lived on the moon.', false),
    Question('Human communicate with cats.', true),
    Question(
      'But why the cats, what\'s about the dogs. They\'re good boy right?',
      true,
    ),
    Question('Are these questions even questioning?', false),
    Question('Is this the end?', true),
  ];

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = questionBank[questionNumber].questionAnswer;

    setState(() {
      if (userPickedAnswer == correctAnswer) {
        scoreKeeper.add(const Icon(Icons.check, color: Colors.green));
        totalScore++;
      } else {
        scoreKeeper.add(const Icon(Icons.close, color: Colors.red));
      }

      if (questionNumber < questionBank.length - 1) {
        questionNumber++;
      } else {
        isFinished = true; // Quiz is over!
      }
    });
  }

  void resetQuiz() {
    setState(() {
      questionNumber = 0;
      scoreKeeper = [];
      totalScore = 0;
      isFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isFinished ? buildResultUI() : buildQuizUI();
  }

  // UI for when the quiz is active
  Widget buildQuizUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Center(
            child: Text(
              questionBank[questionNumber].questionText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25.0, color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                'True',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              onPressed: () => checkAnswer(true),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'False',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              onPressed: () => checkAnswer(false),
            ),
          ),
        ),
        Row(children: scoreKeeper),
      ],
    );
  }

  Widget buildResultUI() {
    return Column(
      // This line pushes everything to the center of the vertical space
      mainAxisAlignment: MainAxisAlignment.center,
      // This ensures the column takes up the full width so children can center horizontally
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Quiz Finished!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 35,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Your Score: $totalScore / ${questionBank.length}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, color: Colors.white70),
        ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: ElevatedButton(
            onPressed: resetQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text(
              'RESTART',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
