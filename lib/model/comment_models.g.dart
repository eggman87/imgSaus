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
      dateCreated: json['datetime'] == null
          ? null
          : ModelUtils.dateFromJson(json['datetime'] as int),
      replies: (json['children'] as List)
          ?.map((e) =>
              e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      parentId: json['parent_id'] as int,
      vote: _$enumDecodeNullable(_$VoteEnumMap, json['vote']));
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'author': instance.author,
      'author_id': instance.authorId,
      'ups': instance.ups,
      'downs': instance.downs,
      'points': instance.points,
      'datetime': instance.dateCreated?.toIso8601String(),
      'children': instance.replies,
      'parent_id': instance.parentId,
      'vote': _$VoteEnumMap[instance.vote]
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$VoteEnumMap = <Vote, dynamic>{Vote.UP: 'UP', Vote.DOWN: 'DOWN'};
