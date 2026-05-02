import 'dart:math';

import 'story.dart';

class StoryBrain {
  int _storyNumber = 0;
  final List<int> _history = [];
  final Set<String> _tags = {};

  final List<GameNode> _nodes = [
    // index 0
    Story(
        text: 'You were hiking on a hill... you saw a house that was never mentioned by the guide.',
        choice1: 'Nah, I\'ll go home',
        choice2: 'Check it out.',
        nextIndex1: 1,
        nextIndex2: 2),
    // index 1. Ending 1: Went home.
    Ending(text: 'You went home... but still keep thinking about that house. The end.'),
    // index 2: Check out the house
    Story(
        text: 'The door was open... blood writing said "DON\'T LOOK". You hear noises from the left room.',
        choice1: 'Go to the room on the left.',
        choice2: 'Go to the room on the right.',
        nextIndex1: 3,
        nextIndex2: 4),
    // index 3: Check out room on the left
    Story(
        text: 'Nothing but a note: "At the end of the crossroad, do not turn left". Eerie noises from the right.',
        choice1: 'Check out the noise',
        choice2: 'Skip it and go upstairs.',
        nextIndex1: 4, // Checking noise takes you to the right room logic
        nextIndex2: 9,
        tagToGrant: 'left_room_checked'),
    // index 4: Check out room on the right
    Story(
        text: 'You went to the right room but found nothing. You felt something behind your back.',
        choice1: 'Turn around and look at it',
        choice2: 'Stay still and close your eyes.',
        nextIndex1: 5,
        nextIndex2: 6),
    // index 5: Bad ending: Looked at it
    Ending(text: 'YOU LOOKED AT IT YOU LOOKED AT IT YOU LOOKED AT IT'),
    // index 6: Stayed still
    Story(
        text: 'You stayed still... the presence left. You turned around with nothing to be seen.',
        choice1: 'Go upstairs',
        choice2: 'Go to the room on the left', 
        nextIndex1: 9,
        nextIndex2: 7,
        requiredTag: 'left_room_checked',
        altChoice2: 'Go upstairs', // Replacement text
        altNextIndex2: 9), // Replacement destination
    // index 7: Went to the left room after checking the right room
    Story(
        text: 'You went to the room on the left and found a note which say: "At the end of the crossroad, do not turn left". Nowhere left but upstairs to go.',
        choice1: 'Go upstairs',
        choice2: 'Try to get out of the house.',
        nextIndex1: 9,
        nextIndex2: 8),
    // index 8: Trying to get out of the house
    Story(
        text: 'The door is locked. No windows. Too hard to kick down.',
        choice1: 'Go upstairs',
        choice2: 'Go upstairs',
        nextIndex1: 9,
        nextIndex2: 9),
    // index 9: Went upstairs
    Story(
        text: 'You went upstairs, there was a bedroom visible, a locked room, and a window',
        choice1: 'Check out the bedroom',
        choice2: 'Open the window and jump out',
        nextIndex1: 13,
        nextIndex2: 10,
        requiredTag: 'window_checked',
        altChoice2: 'Check out the bedroom', // Replacement text
        altNextIndex2: 13),
    // index 10: Jumped out the window
    Story(
        text: 'Somehow the window wasn\'t locked... you jumped out and got out of the house.',
        choice1: 'Keep running',
        choice2: 'Keep running',
        nextIndex1: 11,
        nextIndex2: 11),
    // index 11: Keep running
    Story(
        text: 'Just after 100 steps, you hit some kind of invisible wall... or more like a dome surrounding the area, you can not escape. Then, you felt something, behind you.',
        choice1: 'Turn around and look at it',
        choice2: 'Stay still and close your eyes.',
        nextIndex1: 5,
        nextIndex2: 12),
    // index 12: Stayed still
    Story(
        text: 'You stayed still... the presence left. You turned around with nothing to be seen. Seems like you can only try to find a way to escape withing the house',
        choice1: 'Go back to the house',
        choice2: 'Go back to the house',
        nextIndex1: 9,
        nextIndex2: 9,
        tagToGrant: 'window_checked'),
    // index 13: Check out the bedroom
    Story(
        text: 'You checked out all around the bedroom but found nothing. Then, you felt something, right outside of the room',
        choice1: 'Go and look at it',
        choice2: 'Hide under the bed and close your eyes',
        nextIndex1: 5,
        nextIndex2: 14),
    // index 14: Hide under the bed
    Story(
        text: 'You hid under the bed... the presence left. Then as you were trying to get out, your hand hit something. It was a key',
        choice1: 'Grab the key and check out the locked room',
        choice2: 'Stay under the bed and hide for a while',
        nextIndex1: 15,
        nextIndex2: 16),
    // index 15: Check out the locked room
    Story(
        text: 'You used the key to open the locked room. Inside, there was a table with a book on it about some kind of ritual. You understand nothing',
        choice1: 'Continue reading the book',
        choice2: 'search the room for more clues',
        nextIndex1: 17,
        nextIndex2: 18),
    // index 16: Stay under the bed
    Story(
        text: 'You stayed under the bed for a while... maybe you were just overthinking about the situation, and decided to get out.',
        choice1: 'Go check out the locked room',
        choice2: 'Go check out the locked room',
        nextIndex1: 15,
        nextIndex2: 15),
    // index 17: Continue reading the book
    Story(
        text: 'You continued reading the book, it talked about some sealing ritual that trap thing inside a dome. Now you know why you are stuck, but how did you even got in.',
        choice1: 'Search the room for more clues',
        choice2: 'Search the room for more clues',
        nextIndex1: 18,
        nextIndex2: 18),
    // index 18: Search the room for more clues
    Story(
        text: 'You searched the room for more clues and found nothing. Just as you were about to give up, you accidentally hit a button on the wall. Something opened up downstairs.',
        choice1: 'Go downstairs and check it out',
        choice2: 'Go downstairs and check it out',
        nextIndex1: 19,
        nextIndex2: 19),
    // index 19: Check out the new opening downstairs
    Story(
        text: 'You went downstairs and found a hidden basement. There was a ritual circle on the ground, that seemed to be the source of the dome, a barricaded doorway and a note.',
        choice1: 'Check the note',
        choice2: 'Check the barricaded doorway',
        nextIndex1: 20,
        nextIndex2: 21),
    // index 20: Check the note
    Story(
        text: '"I\'ve seen it, now I know everything, but I can do nothing. Im sorry, but thankful that you\'re here. The seal can only detect presence to stay active, and they can hid it, unless someone were to come. In this place without time, once the dome is activated, it will never go down. But, I left a crack for you, at the end of the crossroad, go, and hope may they will never escape."',
        choice1: 'Check the barricaded doorway',
        choice2: 'Check the barricaded doorway',
        nextIndex1: 21,
        nextIndex2: 21,
        tagToGrant: 'note_checked'),
    // index 21: Check the barricaded doorway
    Story(
        text: 'The door is barricaded with some planks, but it seems like it can be broken down.',
        choice1: 'Break the barricade and go through the doorway',
        choice2: 'Check the note',
        nextIndex1: 22,
        nextIndex2: 20,
        requiredTag: 'note_checked',
        altChoice2: 'Break the barricade and go through the doorway', // Replacement text
        altNextIndex2: 22),
    // index 22: Break the barricade and go through the doorway
    Story(
        text: 'You broke the barricade and went through the doorway. You found yourself in a crossroad, the path foward is collapsed, but there are two paths on the left and right.',
        choice1: 'Go left',
        choice2: 'Go right',
        nextIndex1: 23,
        nextIndex2: 24),
    // index 23: Ending: At the end of the crossroad, do not turn left
    Ending(text: 'It was wating there, for you, to look at it. Now you\'ve known everything, the past, the future, but you wished you didn\'t. As you gauge both of your eyes out, hoping to forget what you saw, but in the end, you looked at it.'),
    // index 24: Go right
    Story(
        text: 'You could feel it, something is behind you, but now that you saw a light at the end of the path, you felt like you can escape, but something felt wrong.',
        choice1: 'Keep running',
        choice2: 'Keep running AND CLOSE YOUR EYES',
        nextIndex1: 23,
        nextIndex2: 25),
    // index 25: Ending: Keep running and close your eyes
    Ending(text: 'You could feel it, not behind you anymore, but in front of you. You kept running and running, hitting the wall, tripping, and get up, until your body colapsed, until you... couldn\'t feel it anymore. And when you open your eyes, you are at where you started, looking at the top of the hill, with no house to be seen, nothing... to look at. The end.'),
  ];

  // Helper to get text for Choice 2 based on tags
  String getChoice2() {
    var node = _nodes[_storyNumber];
    if (node is Story) {
      if (node.requiredTag != null && _tags.contains(node.requiredTag)) {
        return node.altChoice2 ?? node.choice2;
      }
      return node.choice2;
    }
    return '';
  }

  String getStory() => _nodes[_storyNumber].text;
  String getChoice1() => _nodes[_storyNumber] is Story ? (_nodes[_storyNumber] as Story).choice1 : 'Restart';

  void nextStory(int choiceNumber) {
    var currentNode = _nodes[_storyNumber];
    if (currentNode is Story) {
      _history.add(_storyNumber);
      if (currentNode.tagToGrant != null) _tags.add(currentNode.tagToGrant!);

      if (choiceNumber == 1) {
        _storyNumber = currentNode.nextIndex1;
      } else {
        // Handle the alternate path logic
        if (currentNode.requiredTag != null && _tags.contains(currentNode.requiredTag)) {
          _storyNumber = currentNode.altNextIndex2 ?? currentNode.nextIndex2;
        } else {
          _storyNumber = currentNode.nextIndex2;
        }
      }
    } else {
      restart();
    }
  }

  bool isAtEnding() => _nodes[_storyNumber] is Ending;

  void restart() {
    _storyNumber = 0;
    _history.clear();
    _tags.clear();
  }

  void undo() {
    if (_history.isNotEmpty) _storyNumber = _history.removeLast();
  }

  bool canUndo() {
  // Returns true if there is at least one "breadcrumb" in our history trail
  return _history.isNotEmpty;
}
}