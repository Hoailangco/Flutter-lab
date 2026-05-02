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
  // Start with the default ball0 image
  int ballNumber = 0; 
  bool isShaking = false;
  Timer? _timer;

  void shakeBall() {
    if (isShaking) return;

    setState(() => isShaking = true);

    // Rapidly change between ball1 and ball5 to simulate shaking/thinking
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        ballNumber = Random().nextInt(5) + 1;
      });
    });

    // Settle on the final answer after 1.2 seconds
    Future.delayed(const Duration(milliseconds: 1200), () {
      _timer?.cancel();
      setState(() {
        isShaking = false;
        // ballNumber is already set to a random 1-5 from the last timer tick
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: shakeBall,
        // This will load 'images/ball0.png' on first launch
        child: Image.asset('images/ball$ballNumber.png'),
      ),
    );
  }
}