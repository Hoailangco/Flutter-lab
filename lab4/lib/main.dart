import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(
      const MaterialApp(
        home: BallPage(),
      ),
    );

class BallPage extends StatelessWidget {
  const BallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text('Ask Me Anything'),
        foregroundColor: Colors.white,
      ),
      body: const Ball(),
    );
  }
}

class Ball extends StatefulWidget {
  const Ball({super.key});

  @override
  State<Ball> createState() => _BallState();
}

class _BallState extends State<Ball> {
  int ballNumber = 1;
  bool isShaking = false;
  Timer? _timer;

  void shakeBall() {
    if (isShaking) return;

    setState(() => isShaking = true);

    // Rapidly change the image to simulate shaking
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        ballNumber = Random().nextInt(6) + 1;
      });
    });

    // Settle on an answer after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      _timer?.cancel();
      setState(() {
        isShaking = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: shakeBall,
        child: Image.asset('images/ball$ballNumber.png'),
      ),
    );
  }
}