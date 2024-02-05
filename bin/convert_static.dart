import 'dart:io';
import 'package:nostr/nostr.dart';

void main() async {
  // Or,
  // Keychain.generate();
  var keys = Keychain(
    // privkey
    "5ee1c8000ab28edd64d74a7d951ac2dd559814887b1b9e1ac7c5f89e96125c12",
  );
  assert(keys.public ==
      "981cc2078af05b62ee1f98cff325aac755bf5c5836a265c254447b5933c6223b");
  Event event = Event.from(
      kind: 1,
      tags: [],
      content: "Hello, world!",
      privkey: keys.private,
      // TODO(max): Remove this and use current time
      createdAt: 0);
  assert(event.pubkey == keys.public);
  assert(event.isValid() == true);
  print(event.serialize());

  // // Connecting to a nostr relay using websocket
  // WebSocket webSocket = await WebSocket.connect(
  //     'wss://relay.damus.io',
  // );

  // // Send an event to the WebSocket server
  // webSocket.add(event.serialize());

  // // Listen for events from the WebSocket server
  // await Future.delayed(Duration(seconds: 1));
  // webSocket.listen((event) {
  //   print('Received event: $event');
  // });

  // // Close the WebSocket connection
  // await webSocket.close();
}
