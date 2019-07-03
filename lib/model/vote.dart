import 'package:json_annotation/json_annotation.dart';


enum Vote {
  @JsonKey(name: "Up")
  UP,
  @JsonKey(name: "Down")
  DOWN
}