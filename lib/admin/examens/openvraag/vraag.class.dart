class Vraag {
  late String id;
  late String opgave;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vraag': opgave,
    };
  }
}
