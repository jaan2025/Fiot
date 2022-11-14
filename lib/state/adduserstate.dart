import 'package:riverpod/riverpod.dart';




class AddUserState {
  bool isLoading;
  AsyncValue<String> id;
  String error;

  AddUserState(this.isLoading,this.id, this.error);


}