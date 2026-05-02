abstract class GameNode {
  String text;
  GameNode(this.text);
}

class Story extends GameNode {
  String choice1;
  String choice2;
  int nextIndex1;
  int nextIndex2;
  String? tagToGrant;
  String? requiredTag; // Tag needed to change the choice behavior
  String? altChoice2;   // The text for choice 2 if tag is present
  int? altNextIndex2;  // The destination for choice 2 if tag is present

  Story({
    required String text,
    required this.choice1,
    required this.choice2,
    required this.nextIndex1,
    required this.nextIndex2,
    this.tagToGrant,
    this.requiredTag,
    this.altChoice2,
    this.altNextIndex2,
  }) : super(text);
}

class Ending extends GameNode {
  Ending({required String text}) : super(text);
}