import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/model/otp.dart';
import '../../services/apiservices.dart';
import '../../state/adduserstate.dart';




final otpNotifier =
StateNotifierProvider<OTPProvider, AddUserState>((ref) {
  return OTPProvider(ref);
});

class OTPProvider extends StateNotifier<AddUserState> {
  Ref ref;

  OTPProvider(this.ref)
      : super(AddUserState(false, const AsyncLoading(), 'initial'));

  otpVerify(OTPVerify otpVerify) async {
    state = _loading();
    final data = await ref.read(apiProvider)
        .verifyOTP(otpVerify: otpVerify);
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
    return AddUserState(true, state.id, '');
  }

  AddUserState _errorState(String errMsg) {
    return AddUserState(false, state.id, errMsg);
  }

}
