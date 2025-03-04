import 'package:movies_task/models/view_models/base_view_model.dart';
import 'package:movies_task/services/firebase_service.dart';
import 'package:rxdart/rxdart.dart';

abstract class LoginScreenViewModelInput {
  void setEmail(String email);

  void setPassword(String password);

  void signIn();

  void createAccount();
}

abstract class LoginScreenViewModelOutput {
  Stream get signInOrCreateUserSuccess;

  Stream<String?> get errors;
}

abstract class LoginScreenViewModelType extends BaseViewModel {
  LoginScreenViewModelInput get input;

  LoginScreenViewModelOutput get output;
}

class LoginScreenViewModel
    implements
        LoginScreenViewModelInput,
        LoginScreenViewModelOutput,
        LoginScreenViewModelType {
  LoginScreenViewModel(this._firebaseService) {
    _signInTrigger
        .withLatestFrom2(_email, _password, (_, email, password) async {
          return await _firebaseService.signIn(
            email: email,
            password: password,
          );
        })
        .publish()
        .connect()
        .addTo(_subscription);

    _createAccountTrigger
        .withLatestFrom2(_email, _password, (_, email, password) async {
          return await _firebaseService.createNewUser(
            email: email,
            password: password,
          );
        })
        .publish()
        .connect()
        .addTo(_subscription);

    signInOrCreateUserSuccess = _firebaseService.authStateChanges
        .whereNotNull()
        .shareReplay(maxSize: 1);
  }

  final FirebaseService _firebaseService;
  final _subscription = CompositeSubscription();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _signInTrigger = BehaviorSubject<void>();
  final _createAccountTrigger = BehaviorSubject<void>();

  @override
  LoginScreenViewModelInput get input => this;

  @override
  LoginScreenViewModelOutput get output => this;

  @override
  void createAccount() {
    _createAccountTrigger.add(null);
  }

  @override
  void setEmail(String email) {
    _email.add(email);
  }

  @override
  void setPassword(String password) {
    _password.add(password);
  }

  @override
  void signIn() {
    _signInTrigger.add(null);
  }

  @override
  void dispose() {
    _email.close();
    _password.close();
    _signInTrigger.close();
    _createAccountTrigger.close();
    _subscription.dispose();
  }

  @override
  late final Stream signInOrCreateUserSuccess;

  @override
  Stream<String?> get errors => _firebaseService.firebaseError;
}
