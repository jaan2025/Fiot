import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/model/locationrequest.dart';

import '../../model/response_data.dart';
import '../../services/apiservices.dart';
import '../../state/adduserstate.dart';




final updateLocationNotifier =
StateNotifierProvider<UpdateLocationProvider, AddUserState>((ref) {
  return UpdateLocationProvider(ref);
});

class UpdateLocationProvider extends StateNotifier<AddUserState> {
  Ref ref;

  UpdateLocationProvider(this.ref)
      : super(AddUserState(false, const AsyncLoading(), 'initial'));

  updateLocation(LocationData updateLocation) async {
    state = _loading();
    final data = await ref.read(apiProvider)
        .updateLocation(location: updateLocation);
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
