import 'package:flutter_riverpod/flutter_riverpod.dart';


class TcpResponseSate {
  bool isLoading;
  AsyncValue<String> id;
  String error;

  TcpResponseSate(this.isLoading, this.id, this.error);
}