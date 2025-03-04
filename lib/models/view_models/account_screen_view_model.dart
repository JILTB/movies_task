import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies_task/models/view_models/base_view_model.dart';
import 'package:movies_task/services/firebase_service.dart';
import 'package:movies_task/stream_extensions.dart';
import 'package:rxdart/transformers.dart';

abstract class AccountScreenViewModelInput {
  void signOut();
}

abstract class AccountScreenViewModelOutput {
  Stream get signOutOrCreateUserSuccess;

  Stream<User> get user;

  Stream<String?> get errors;
}

abstract class AccountScreenViewModelType extends BaseViewModel {
  AccountScreenViewModelInput get input;

  AccountScreenViewModelOutput get output;
}

class AccountScreenViewModel
    implements
        AccountScreenViewModelInput,
        AccountScreenViewModelOutput,
        AccountScreenViewModelType {
  AccountScreenViewModel(this._firebaseService) {
    signOutOrCreateUserSuccess = _firebaseService.authStateChanges.whereNull();
  }

  final FirebaseService _firebaseService;

  @override
  AccountScreenViewModelInput get input => this;

  @override
  AccountScreenViewModelOutput get output => this;

  @override
  void dispose() {}

  @override
  void signOut() {
    _firebaseService.signOut();
  }

  @override
  late final Stream signOutOrCreateUserSuccess;

  @override
  Stream<User> get user =>
      Stream.value(_firebaseService.currentUser).whereNotNull();

  @override
  Stream<String?> get errors => _firebaseService.firebaseError;
}
