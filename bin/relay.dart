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
  static Event fromJSON(dynamic json) {
    assert(json is Map);
    return Event("hi", Int64(123), EventKind.metadata);
  }
}

class EventMessage {
}

class Filter {
  static Filter fromJSON(dynamic json) {
    return Filter();
  }
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

class ClientMessage {
  static ClientMessage fromJSON(dynamic json) {
    assert(json is List);
    assert(json.length >= 1);
    if (json[0] == "EVENT") {
      assert(json.length == 2);
      return EventClientMessage(Event.fromJSON(json[1]));
    }
    if (json[0] == "REQ") {
      assert(json.length >= 3);
      return ReqClientMessage(json[1], json.sublist(2).map<Filter>(Filter.fromJSON).toList());
    }
    if (json[0] == "CLOSE") {
      assert(json.length == 2);
      return CloseClientMessage(json[1]);
    }
    throw 'unknown message type';
  }
}

class EventClientMessage extends ClientMessage {
  final Event event;

  EventClientMessage(this.event);
}

class ReqClientMessage extends ClientMessage {
  final String subscription_id;
  final List<Filter> filters;

  ReqClientMessage(this.subscription_id, this.filters);
}

class CloseClientMessage extends ClientMessage {
  final String subscription_id;

  CloseClientMessage(this.subscription_id);
}

void onWebSocketData(WebSocket client){
  var subscription;
  subscription = client.listen((data_str) {
    final data = json.decode(data_str);
    final message = ClientMessage.fromJSON(data);
    print('Echo: $data');
    print('Echo: $message');
    client.add('Echo: $data');
  });
}
