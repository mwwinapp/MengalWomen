import 'package:recase/recase.dart';

String properCase(String text) {
  ReCase _recase = ReCase(text);
  return _recase.titleCase;
}