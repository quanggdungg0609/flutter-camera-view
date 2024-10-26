import 'dart:async';

abstract class WebSocketDataSource {
  Stream<String> get message;
  Future<void> connect(String accountID, String uuid);
  Future<void> send(String message);
  Future<void> disconnect();
}

class WebsocketDataSourceImpl extends WebSocketDataSource {
  late final StreamController<String> _messageController;

  @override
  Future<void> connect(String accountID, String uuid) async {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future<void> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Stream<String> get message => _messageController.stream;

  @override
  Future<void> send(String message) {
    // TODO: implement send
    throw UnimplementedError();
  }
}
