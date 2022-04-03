class Student {
  String id;
  final String firstname;
  final String lastname;
  final String snumber;

  Student(this.id, this.firstname, this.lastname, this.snumber);

  @override
  String toString() {
    return '{\n'
           '\tid: $id,\n'
           '\tfirstname: $firstname,\n'
           '\tlastname: $lastname,\n'
           '\tsnumber: $snumber,'
           '\n}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'snumber': snumber,
    };
  }
}