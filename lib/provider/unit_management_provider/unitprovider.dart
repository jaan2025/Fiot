import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/model/user.dart';

import '../../model/response_data.dart';
import '../../model/unitconfig.dart';
import '../../services/apiservices.dart';
import '../../state/adduserstate.dart';




final addUnitNotifier =
StateNotifierProvider<AddUnitProvider, AddUserState>((ref) {
  return AddUnitProvider(ref);
});

class AddUnitProvider extends StateNotifier<AddUserState> {
  Ref ref;

  AddUnitProvider(this.ref)
      : super(AddUserState(false, const AsyncLoading(), 'initial'));

  addUnit(UnitData addUnit) async {
    state = _loading();
    final data = await ref.read(apiProvider)
        .addUnit(unit: addUnit);
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
