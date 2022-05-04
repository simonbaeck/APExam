class Multipechoice {
  late String id;
  late String opgave;
  late List<String> antwoorden;
  late List<int> oplossingen;
  late String type;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vraag': opgave,
      'antwoorden': antwoorden,
      'oplossingen': oplossingen,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'Multipechoice { id: $id, opgave: $opgave, antwoorden: $antwoorden, oplossingen: $oplossingen, type: $type }';
  }
}
