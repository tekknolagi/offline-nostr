import 'dart:io';

void main() async {
  HttpServer server = await HttpServer.bind('localhost', 5600);
  server.transform(WebSocketTransformer()).listen(onWebSocketData);
}

void onWebSocketData(WebSocket client){
  var subscription;
  subscription = client.listen((data) async {
    print('Echo: $data');
    client.add('Echo: $data');
  });
}
