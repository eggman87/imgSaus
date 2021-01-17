// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) {
  return Account(
      id: json['id'] as int,
      url: json['url'] as String,
      bio: json['bio'] as String,
      reputation: json['reputation'] as int,
      created: json['created'] as int,
      avatar: json['avatar'] as String,
      cover: json['cover'] as String,
      reputationName: json['reputation_name'] as String);
}

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'bio': instance.bio,
      'reputation': instance.reputation,
      'created': instance.created,
      'avatar': instance.avatar,
      'cover': instance.cover,
      'reputation_name': instance.reputationName
    };
