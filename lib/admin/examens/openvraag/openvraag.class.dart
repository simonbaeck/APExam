class Vraag {
  late String id;
  late String opgave;
  late String type;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vraag': opgave,
      'type': type,
    };
  }
}
