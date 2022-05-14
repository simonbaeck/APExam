class Multipechoice {
  late String id;
  late String opgave;
  late List<String> antwoorden;
  late String oplossing;
  late String type;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vraag': opgave,
      'antwoorden': antwoorden,
      'type': type,
      'oplossing': oplossing,
    };
  }

  @override
  String toString() {
    return 'Multipechoice { id: $id, opgave: $opgave, antwoorden: $antwoorden, oplossing: $oplossing, type: $type }';
  }
}
