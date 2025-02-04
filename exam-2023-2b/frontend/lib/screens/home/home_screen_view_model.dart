import 'dart:convert';

import 'package:frontend/model/my_entity.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeScreenViewModel {
  final channel = WebSocketChannel.connect(
    Uri.parse("ws://10.0.2.2:2528"),
  );

  Stream<MyEntity> listenForAddedItems() {
    return channel.stream.flatMap((value) {
      if (value is! String) {
        return Stream.error("The received value has the wrong type!");
      }
      var json = Map<String, dynamic>.from(jsonDecode(value));
      return Stream.value(MyEntity.fromJson(json));
    });
  }

  dispose() {
    channel.sink.close();
  }
}