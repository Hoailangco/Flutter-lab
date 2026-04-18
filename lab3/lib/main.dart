import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(const MaterialApp(home: Scaffold(backgroundColor: Colors.red, body: DicePage())));

class DicePage extends StatefulWidget {
  const DicePage({super.key});

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  int leftDiceNumber = 1;
  int rightDiceNumber = 1;
  bool isRolling = false;
  Timer? _timer;

  void rollDice() {
    if (isRolling) return;

    setState(() => isRolling = true);

    // Visual "shuffle" - cycles through images rapidly
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        leftDiceNumber = Random().nextInt(6) + 1;
        rightDiceNumber = Random().nextInt(6) + 1;
      });
    });

    // Stop after 1.5 seconds and settle on the final result
    Future.delayed(const Duration(milliseconds: 1500), () {
      _timer?.cancel();
      setState(() {
        isRolling = false;
        // The numbers are already randomized from the last tick of the timer
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isRolling ? 'Rolling...' : 'Tap to Roll!',
            style: const TextStyle(
              fontSize: 30.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50.0),
          Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: rollDice,
                  // Uses your dice1.png, dice2.png, etc.
                  child: Image.asset('images/dice$leftDiceNumber.png'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: rollDice,
                  child: Image.asset('images/dice$rightDiceNumber.png'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}