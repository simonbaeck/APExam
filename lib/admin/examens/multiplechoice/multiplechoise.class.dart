class Multipechoice {
  late String id;
  late String opgave;
  late List<String> antwoorden;
  late String oplossing;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vraag': opgave,
      'antwoorden': antwoorden,
      'oplossingen': oplossing,
    };
  }
}
