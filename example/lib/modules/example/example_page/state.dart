import 'package:fish_redux/fish_redux.dart';

class ExampleState implements Cloneable<ExampleState> {

  @override
  ExampleState clone() {
    return ExampleState();
  }
}

ExampleState initState(Map<String, dynamic> args) {
  return ExampleState();
}
