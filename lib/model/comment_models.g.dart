// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
      id: json['id'] as int,
      comment: json['comment'] as String,
      author: json['author'] as String,
      authorId: json['author_id'] as int,
      ups: json['ups'] as int,
      downs: json['downs'] as int,
      points: json['points'] as int,
      vote: json['vote'] as String,
      dateCreated: json['datetime'] == null
          ? null
          : ModelUtils.dateFromJson(json['datetime'] as int));
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'author': instance.author,
      'author_id': instance.authorId,
      'ups': instance.ups,
      'downs': instance.downs,
      'points': instance.points,
      'vote': instance.vote,
      'datetime': instance.dateCreated?.toIso8601String()
    };
