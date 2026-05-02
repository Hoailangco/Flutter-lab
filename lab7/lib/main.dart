import 'package:flutter/material.dart';
import 'story_brain.dart';

void main() => runApp(const Destini());

class Destini extends StatelessWidget {
  const Destini({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const StoryPage(),
    );
  }
}

// Global instance of StoryBrain
StoryBrain storyBrain = StoryBrain();

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 15.0),
        constraints: const BoxConstraints.expand(),
        // Note: Ensure you have background.png in your images folder
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Story Text Area
              Expanded(
                flex: 12,
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      storyBrain.getStory(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'Georgia', // Gives it a "story" feel
                      ),
                    ),
                  ),
                ),
              ),
              
              // Choice 1 / Restart Button
              Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      storyBrain.nextStory(1);
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: storyBrain.isAtEnding() ? Colors.green : Colors.red,
                  ),
                  child: Text(
                    storyBrain.getChoice1(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
              ),
              
              const SizedBox(height: 20.0),
              
              // Choice 2 / Undo Button
              Expanded(
                flex: 2,
                child: Visibility(
                  // Only hide if it's an ending AND we can't undo (safety check)
                  visible: !storyBrain.isAtEnding() || storyBrain.canUndo(),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        if (storyBrain.isAtEnding()) {
                          storyBrain.undo();
                        } else {
                          storyBrain.nextStory(2);
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: storyBrain.isAtEnding() ? Colors.blueGrey : Colors.blue,
                    ),
                    child: Text(
                      storyBrain.isAtEnding() ? 'Undo Choice' : storyBrain.getChoice2(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}