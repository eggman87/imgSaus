import 'package:json_annotation/json_annotation.dart';

part 'gallery_item.g.dart';

@JsonSerializable()
class GalleryItem {

  GalleryItem({this.id, this.title, this.type, this.animated});

  final String id;
  final String title;
  final String type;
  final bool animated;


  factory GalleryItem.fromJson(Map<String, dynamic> json) => _$GalleryItemFromJson(json);

  Map<String, dynamic>toJson() => _$GalleryItemToJson(this);
}