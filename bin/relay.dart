import 'dart:io';
import 'dart:ffi';
import 'package:fixnum/fixnum.dart';
import 'dart:convert';

enum EventKind {
  unknown(-1),
  metadata(0),
  textnote(1);

  const EventKind(this.value);
  final int value;

  static EventKind fromInt(int kind) {
    return EventKind.values.firstWhere((x) => x.value == kind);
  }
}

class Event {
  String pubkey;
  Int64 created_at;
  EventKind kind;

  Event(this.pubkey, this.created_at, this.kind);
}

class EventMessage {
}

class Filter {
}

class Store {
  void init() {
  }
  void close() {
  }
  Event? query_events(Filter filter) {
  }
  void delete_event(Event event) {
  }
  void save_event(Event event) {
  }
}

void main() async {
  HttpServer server = await HttpServer.bind('localhost', 5600);
  server.transform(WebSocketTransformer()).listen(onWebSocketData);
  print("Listening...");
  print(Event("123", Int64(DateTime.now().millisecondsSinceEpoch),
        EventKind.metadata));
}

void onWebSocketData(WebSocket client){
  var subscription;
  subscription = client.listen((data_str) {
    final data = json.decode(data_str);
    print('Echo: $data');
    client.add('Echo: $data');
  });
}
