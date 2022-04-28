class Vraag {
  late String id;
  late String opgave;

  //Vragen({this.nummer, this.vraag, this.antwoord, this.oplossing})

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vraag': opgave,
    };
  }
}
