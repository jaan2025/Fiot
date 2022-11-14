import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/helper/helper.dart';
import 'package:generic_iot_sensor/model/user.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/response_data.dart';
import '../../../services/apiservices.dart';
import '../../../state/adduserstate.dart';




final getEdgeDeviceNotifier =
StateNotifierProvider<GetEdgeDeviceProvider, AddUserState>((ref) {
  return GetEdgeDeviceProvider(ref);
});

class GetEdgeDeviceProvider extends StateNotifier<AddUserState> {
  Ref ref;

  GetEdgeDeviceProvider(this.ref)
      : super(AddUserState(false, const AsyncLoading(), 'initial'));

  getEdgeDevicenfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(Helper.userId);
    state = _loading();
    final data = await ref.read(apiProvider)
        .getEdgeDeviceList();
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
