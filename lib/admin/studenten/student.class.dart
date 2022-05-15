import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  late String id;
  late String firstName;
  late String lastName;
  late String sNumber;
  late bool examActive = false;
  late GeoPoint studentLocation = const GeoPoint(51.23007955208338, 4.416187171855199);
  late bool extraTime = false;

  // Student(this.id, this.firstname, this.lastname, this.snumber);

  @override
  String toString() {
    return '{\n'
           '\tid: $id,\n'
           '\tfirstName: $firstName,\n'
           '\tlastName: $lastName,\n'
           '\tsNumber: $sNumber,\n'
           '\texamActive: $examActive,\n'
           '\tstudentLocation: $studentLocation'
           '\textraTime: $extraTime'
           '\n}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'sNumber': sNumber,
      'examActive': examActive,
      'studentLocation': studentLocation,
      'extraTime': extraTime
    };
  }
}