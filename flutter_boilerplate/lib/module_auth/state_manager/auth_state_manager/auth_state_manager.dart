import 'package:inject/inject.dart';
import 'package:rxdart/rxdart.dart';

import '../../ui/states/auth_states/auth_state.dart';
import '../../ui/states/auth_states/auth_state_init.dart';
import '../../ui/states/auth_states/auth_state_error.dart';
import '../../ui/states/auth_states/auth_state_success.dart';
import '../../ui/states/auth_states/auth_state_code_sent.dart';
import '../../enums/auth_status.dart';
import '../../enums/user_type.dart';
import '../../service/auth_service/auth_service.dart';

@provide
class AuthStateManager {
  // Inject
  final AuthService _authService;

  /// A state transporter, I'm thinking of moving this to a super class
  final PublishSubject<AuthState> _stateSubject = PublishSubject();

  Stream<AuthState> get stateStream => _stateSubject.stream;

  /// Start listening to auth events
  AuthStateManager(this._authService) {
    _authService.authListener.listen((event) {
      switch (event) {
        case AuthStatus.NOT_LOGGED_IN:
        // TODO: Handle this case.
          _stateSubject.add(AuthStateInit(this));
          break;
        case AuthStatus.UNVERIFIED:
        // TODO: Handle this case.
          _stateSubject.add(AuthStateError(this, 'Unverified Account'));
          break;
        case AuthStatus.AUTHORIZED:
        // TODO: Handle this case.
          _stateSubject.add(AuthStateSuccess(this, UserRole.ROLE_OWNER));
          break;
        case AuthStatus.CODE_SENT:
          // TODO: Handle this case.
          _stateSubject.add(AuthStateCodeSent(this));
          break;
        case AuthStatus.CODE_TIMEOUT:
          // TODO: Handle this case.
          _stateSubject.add(AuthStateError(this, 'Code Timeout!'));
          break;
      }
    }).onError((error) {
      print('got Error');
      _stateSubject.add(AuthStateError(this, error));
    });
  }

  void signInWithPhone(String phone, UserRole role) {
    _authService.verifyWithPhone(phone, role);
  }

  void signInWithGoogle(UserRole role) {
    _authService.verifyWithGoogle(role);
  }

  void signInWithApple(UserRole role) {
    _authService.verifyWithApple(role);
  }

  void signInWithEmailAndPassword(
      String email, String password, UserRole role) {
    _authService.signInWithEmailAndPassword(email, password, role);
  }

  void registerWithEmailAndPassword(
    String email,
    String password,
    String name,
    UserRole role,
  ) {
    _authService.registerWithEmailAndPassword(email, password, name, role);
  }

  void retryPhone() {
    _stateSubject.add(AuthStateInit(this));
  }

  void confirmSmsCode(String code, UserRole role) {
    _authService.confirmWithCode(code, role);
  }
}
