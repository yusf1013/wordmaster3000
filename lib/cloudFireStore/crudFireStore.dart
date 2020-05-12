import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseUserMethods {

  Future<void> addWords(List<String> word){
      Firestore.instance.collection("wordlist").document("1").updateData({
        'words' : FieldValue.arrayUnion(word)
      });
  }

  Future<void> getUsersAllWordlist(){

  }

  Future<void> getParticularUserWordlist(){

  }

  Future<void> getAllPublicWordlist(){

  }


}