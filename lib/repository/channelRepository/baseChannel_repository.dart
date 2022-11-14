

import '../../model/user_devicess/channelModel.dart';

abstract class BaseChannel{
  Future<Channel?> getChannel () async {}
}