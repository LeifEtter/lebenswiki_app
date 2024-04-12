import 'package:json_annotation/json_annotation.dart';

enum PageType {
  @JsonValue("PageType.info")
  info,
  @JsonValue("PageType.quiz")
  quiz,
}
