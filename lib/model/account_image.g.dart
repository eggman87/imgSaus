// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountImage _$AccountImageFromJson(Map<String, dynamic> json) {
  return AccountImage(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      views: json['views'] as int,
      link: json['link'] as String);
}

Map<String, dynamic> _$AccountImageToJson(AccountImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'width': instance.width,
      'height': instance.height,
      'views': instance.views,
      'link': instance.link
    };
