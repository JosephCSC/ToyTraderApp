import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toy_trader/firebase_services/DatabaseService.dart';
import 'package:toy_trader/models/ProfileInfo.dart';
import '../models/Toy.dart';

class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DatabaseService dbService = DatabaseService();


  ProfileInfo? _userFromFirebaseUser(User? user){
    return user != null ? ProfileInfo(
        uid: user.uid,
        screenName: '',
        ageRange: '',
        interests: '',
        toys: <Toy>[],
        profileImageUrl: '',
        userRating: 0,
        totalRates: 0,
        blockedUsers: <String>[]
    ) : null;
  }

  Stream<ProfileInfo?> get user {
    return firebaseAuth.authStateChanges().map((User? user) => _userFromFirebaseUser(user));
  }
  //register with email/pw
  Future registerWithEmailAndPw(String email, String pw, ProfileInfo? profileInfo, File fileImg) async {
    try{
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: pw);
      User? user = result.user;
      profileInfo!.uid = user!.uid;
      await dbService.setProfileInfo(profileInfo, fileImg);

      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signIn( String email, String pw) async {
    try{
      UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: pw);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try{
      return await firebaseAuth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future getInfo() async {
    return firebaseAuth.currentUser;
  }

  Future getCurrentUserId() async {
    try {
      final user = firebaseAuth.currentUser;
      return user?.uid;
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }


}
