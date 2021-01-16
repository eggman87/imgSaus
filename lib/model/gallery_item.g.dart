// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryItem _$GalleryItemFromJson(Map<String, dynamic> json) {
  return GalleryItem(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      animated: json['animated'] as bool,
      isAlbum: json['is_album'] as bool,
      link: json['link'] as String,
      images: (json['images'] as List)
          ?.map((e) => e == null
              ? null
              : GalleryItem.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      mp4: json['mp4'] as String,
      imagesCount: json['images_count'] as int,
      width: (json['width'] as num)?.toDouble(),
      height: (json['height'] as num)?.toDouble(),
      dateCreated: json['datetime'] == null
          ? null
          : ModelUtils.dateFromJson(json['datetime'] as int),
      hasSound: json['has_sound'] as bool);
}

Map<String, dynamic> _$GalleryItemToJson(GalleryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'animated': instance.animated,
      'is_album': instance.isAlbum,
      'link': instance.link,
      'images': instance.images,
      'mp4': instance.mp4,
      'images_count': instance.imagesCount,
      'width': instance.width,
      'height': instance.height,
      'datetime': instance.dateCreated?.toIso8601String(),
      'has_sound': instance.hasSound
    };
