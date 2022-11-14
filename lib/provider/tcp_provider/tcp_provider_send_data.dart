import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/tcpclient.dart';


final tcpSendDataNotifier = StateNotifierProvider<TcpSendDataProvider, TcpState>((ref) {
  return TcpSendDataProvider(ref);
});

bool canContinueTest = true;

class TcpSendDataProvider extends StateNotifier<TcpState> {
  final Ref ref;

  TcpSendDataProvider(this.ref) : super(TcpState(TcpStatus.initial, ''));

  sendPacket(String pck, String testNo) {
    ref.read(tcpProvider).sendPackets(pck);
    /*Future.delayed(const Duration(milliseconds: 500), () {
      ref.read(lastTestSentProvider.notifier).state = testNo;
      ref.read(lastPacketSentProvider.notifier).state = pck;
    });*/

  }

}

enum TcpStatus { initial, loading, success, failure }

class TcpState {
  TcpStatus? status;
  String? data;

  TcpState(this.status, this.data);
}
