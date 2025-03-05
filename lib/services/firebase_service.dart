import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseService {
  FirebaseService({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseAuth = firebaseAuth,
       _firebaseFirestore = firebaseFirestore;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  final _firebaseError = PublishSubject<String?>();

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Stream<String?> get firebaseError => _firebaseError;

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _firebaseError.add(e.message);
    }
  }

  Future<void> createNewUser({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _createUserDocument(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      _firebaseError.add(e.message);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      _firebaseError.add(e.message);
    }
  }

  Future<void> _createUserDocument(String uid) async {
    try {
      await _firebaseFirestore.collection('users').doc(uid).set({
        'likedMovies': [],
      }, SetOptions(merge: true));
    } catch (e) {
      _firebaseError.add(e.toString());
    }
  }

  Future<void> likeMovie(String movieId) async {
    final user = currentUser;
    if (user == null) return;

    try {
      await _firebaseFirestore.collection('users').doc(user.uid).update({
        'likedMovies': FieldValue.arrayUnion([movieId]),
      });
    } catch (e) {
      _firebaseError.add(e.toString());
    }
  }

  Future<void> unlikeMovie(String movieId) async {
    final user = currentUser;
    if (user == null) return;

    try {
      await _firebaseFirestore.collection('users').doc(user.uid).update({
        'likedMovies': FieldValue.arrayRemove([movieId]),
      });
    } catch (e) {
      _firebaseError.add(e.toString());
    }
  }

  Stream<List<String>> getLikedMovies() {
    final user = currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firebaseFirestore.collection('users').doc(user.uid).snapshots().map(
      (doc) {
        if (doc.exists) {
          return List<String>.from(doc.data()?['likedMovies'] ?? []);
        }
        return [];
      },
    );
  }
}
