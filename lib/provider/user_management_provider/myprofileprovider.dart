import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/response_data.dart';
import '../../services/apiservices.dart';
import '../../state/adduserstate.dart';




final updateUserNotifier =
StateNotifierProvider<AddUserProvider, AddUserState>((ref) {
  return AddUserProvider(ref);
});

class AddUserProvider extends StateNotifier<AddUserState> {
  Ref ref;

  AddUserProvider(this.ref)
      : super(AddUserState(false, const AsyncLoading(), 'initial'));

  updateUser(ResponseData registerUser) async {
    state = _loading();
    final data = await ref.read(apiProvider)
        .updateUser(user: registerUser);
    if (data != null) {
      state = _dataState(data.toString());
    } else if (data == null) {
      state = _errorState('Timeout');
    }
    return state;
  }

  AddUserState _dataState(String entity) {
    return AddUserState(false, AsyncData(entity), '');
  }

  AddUserState _loading() {
    print(state);
    //print(state.id);
    return AddUserState(true, state.id, '');
  }

  AddUserState _errorState(String errMsg) {
    return AddUserState(false, state.id, errMsg);
  }

}
