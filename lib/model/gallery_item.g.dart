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
          ?.toList());
}

Map<String, dynamic> _$GalleryItemToJson(GalleryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'animated': instance.animated,
      'is_album': instance.isAlbum,
      'link': instance.link,
      'images': instance.images
    };
