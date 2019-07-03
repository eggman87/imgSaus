import 'package:imgsrc/model/model_utils.dart';
import 'package:imgsrc/model/vote.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_models.g.dart';

@JsonSerializable()
class Comment {

  Comment({ this.id, this.comment, this.author, this.authorId, this.ups, this.downs, this.points, this.dateCreated, this.replies, this.parentId, this.vote});

  static const NAME = "Comment";

  final int id;
  final String comment;
  final String author;
  @JsonKey(name: "author_id")
  final int authorId;
  final int ups;
  final int downs;
  final int points;
  @JsonKey(name: "datetime", fromJson: ModelUtils.dateFromJson)
  final DateTime dateCreated;
  @JsonKey(name: "children")
  final List<Comment> replies;
  @JsonKey(name: "parent_id")
  final int parentId;
  final Vote vote;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  Map<String, dynamic>toJson() => _$CommentToJson(this);

  @override
  String toString() {
    return 'Comment{$id}';
  }
}

enum CommentSort {
  best, top, New //weird casing here due to keyword
}