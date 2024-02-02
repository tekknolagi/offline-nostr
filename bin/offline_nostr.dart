import 'package:args/args.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:io';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: dart offline_nostr.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) async {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    // Process the parsed arguments.
    if (results.wasParsed('help')) {
      printUsage(argParser);
      return;
    }
    if (results.wasParsed('version')) {
      print('offline_nostr version: $version');
      return;
    }
    if (results.wasParsed('verbose')) {
      verbose = true;
    }

    // Act on the arguments provided.
    print('Positional arguments: ${results.rest}');
    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }

  final wsUrl = Uri.parse('wss://relay.nostrss.re');
  final channel = WebSocketChannel.connect(wsUrl);
  await channel.ready;
  int limit = 10;
  channel.sink.add('["REQ","sub1",{"limit":${limit}}]');
  channel.sink.add('["EVENT",{"id": "abc"}]');
  int count = 0;
  var subscription;
  subscription = channel.stream.listen((message) {
    print(message);
    count++;
    if (count == limit) {
      channel.sink.close(WebSocketStatus.normalClosure);
      // TODO(max): Figure out why cancelling the subscription is fast but the
      // application just sits around doing nothing for a couple seconds before
      // quitting. Right now we can exit immediately by closing the sink, but
      // we get an exception.
      // await subscription.cancel();
    }
  });
}
