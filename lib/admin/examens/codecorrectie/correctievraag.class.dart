class CorrectieVraag {
  late String id;
  late String opgave;
  late String oplossing;

  Map<String, dynamic> toMap() {
    return {'id': id, 'vraag': opgave, 'oplossing': oplossing};
  }
}
