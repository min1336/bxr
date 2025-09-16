import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  Stream<User?> get user => _auth.authStateChanges();

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> submitAuthForm({
    required String email,
    required String password,
    required String nickname,
    required bool isLogin,
    required BuildContext context,
  }) async {
    UserCredential userCredential;
    _setLoading(true);

    try {
      if (isLogin) {
        // 로그인
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // 회원가입
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // 회원가입 성공 시, Firestore에 사용자 정보 저장
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'nickname': nickname,
          'email': email,
          'height': 0, // 기본값
          'reach': 0, // 기본값
          'wins': 0,
          'losses': 0,
          'knockouts': 0,
          'createdAt': Timestamp.now(),
        });
      }
    } on FirebaseAuthException catch (err) {
      String message = '에러가 발생했습니다.';
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } catch (err) {
      print(err);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}