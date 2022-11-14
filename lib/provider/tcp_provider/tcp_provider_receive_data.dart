import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/tcp_state.dart';


final tcpReceiveDataNotifier =
    StateNotifierProvider.autoDispose<TcpReceiveDataProvider, TcpResponseSate>(
        (ref) {
  return TcpReceiveDataProvider(ref);
});

class TcpReceiveDataProvider extends StateNotifier<TcpResponseSate> {
  final Ref ref;

  TcpReceiveDataProvider(this.ref)
      : super(TcpResponseSate(false, const AsyncLoading(), ''));

  void getResponseData(String receivedData) {
    state = _dataState(receivedData);
    if (receivedData.isNotEmpty) {
    }
  }

  TcpResponseSate _dataState(String entity) {
    return TcpResponseSate(false, AsyncData(entity), '');
  }

  TcpResponseSate _loading() {
    return TcpResponseSate(true, state.id, '');
  }

  TcpResponseSate _errorState(int statusCode, String errMsg) {
    return TcpResponseSate(
        false, state.id, 'response code $statusCode  msg $errMsg');
  }
}
