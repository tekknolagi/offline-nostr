import 'dart:collection';
import 'dart:io';

void main() {
  final queue = Queue<String>();
  for (int i = 0; i < 20; i++) {
    sleep(Duration(milliseconds:50));
    // Or await Future.delayed(Duration(seconds: 1));
    String s = "update $i";
    for (final String item in queue) {
      stdout.write("\x1b[1A\x1b[2K");
    }
    if (queue.length == 3) {
      queue.removeFirst();
    }
    queue.addLast(s);
    for (final String item in queue) {
      stdout.write("$item\n");
    }
  }
}
