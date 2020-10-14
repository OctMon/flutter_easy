import 'package:fish_redux/fish_redux.dart';

enum LoginAction {
  onLoginPressed,
  updateAgreementCheck,
}

class LoginActionCreator {
  static Action onLoginPressed() {
    return const Action(LoginAction.onLoginPressed);
  }

  static Action updateAgreementCheck(bool check) {
    return Action(LoginAction.updateAgreementCheck, payload: check);
  }
}
