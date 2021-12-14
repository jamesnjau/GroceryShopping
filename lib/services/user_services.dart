//for all firebase related services for user

// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  String collection = "Users";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Create new user
  Future<void> createUserData(Map<String, dynamic> values) async {
    String id = values["id"];
    await _firestore.collection(collection).doc(id).set(values);
  }

  //Update new user
  Future<void> updateUserData(Map<String, dynamic> values) async {
    String id = values["id"];
    await _firestore.collection(collection).doc(id).update(values);
  }

  //Get user data by User id
  Future<DocumentSnapshot> getUserById(String id) async {
    var result = await _firestore.collection(collection).doc(id).get();
    return result;
  }
}
