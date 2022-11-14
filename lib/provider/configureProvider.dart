import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentStepProvider = StateProvider<int>((ref) => 0);

// update configure
final updateConfigureNotifierProvider =
StateNotifierProvider<UpdateConfigureNotifier, TestResultState>((ref) {
  return UpdateConfigureNotifier(ref);
});

class UpdateConfigureNotifier extends StateNotifier<TestResultState> {
  final Ref ref;

  UpdateConfigureNotifier(this.ref)
      : super(TestResultState(TestResultStatus.initial, ''));

  updateConfigure(String packet) async {


    print("updateConfigure");
   /* var data = await ref.read(apiProvider).saveTestResult(packet);
    if(data != null) {
      state = data;
      return true;
    } else {
      state = errorState();
      return false;
    }*/


  }




  loadingState() {
    return TestResultState(TestResultStatus.loading, '');
  }

  errorState() {
    return TestResultState(TestResultStatus.failure, '');
  }
}

class TestResultState {
  TestResultStatus? status;
  dynamic data;

  TestResultState(this.status, this.data);
}

// TestResultState
enum TestResultStatus { initial, loading, success, failure }
