import 'dart:async';

Future<Null> pause(int d) {
  return Future.delayed(Duration(milliseconds: d));
}