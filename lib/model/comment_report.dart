import 'package:json_annotation/json_annotation.dart';

part 'comment_report.g.dart';

@JsonSerializable()
class CommentReport {
  int reason;

  CommentReport(this.reason);
}