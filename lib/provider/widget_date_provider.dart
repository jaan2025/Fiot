import 'package:flutter_riverpod/flutter_riverpod.dart';

final widgetDateNotifier = StateNotifierProvider<WidgetDateProvider, int>((ref) {
  return WidgetDateProvider(ref);
});

class  WidgetDateProvider extends StateNotifier<int> {
  final Ref ref;

  WidgetDateProvider(this.ref) : super(0);

  void currentIndex(int index) {
    state = index;
  }
}
