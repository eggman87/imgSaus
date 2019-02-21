// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryTag _$GalleryTagFromJson(Map<String, dynamic> json) {
  return GalleryTag(
      json['id'] as String,
      json['name'] as String,
      json['display_name'] as String,
      json['followers'] as int,
      json['total_items'] as int,
      json['background_hash'] as String);
}

Map<String, dynamic> _$GalleryTagToJson(GalleryTag instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'display_name': instance.displayName,
      'followers': instance.followers,
      'total_items': instance.totalItems,
      'background_hash': instance.backgroundHash
    };
