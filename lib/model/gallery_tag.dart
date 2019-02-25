import 'package:json_annotation/json_annotation.dart';

part 'gallery_tag.g.dart';

@JsonSerializable()
class GalleryTag {

  static const NAME = "GALLERY_TAG";
  //subkey in api response
  static const TAGS_SUB_KEY = "tags";
  static const GALLERY_SUB_KEY = "items";

  final String id;
  final String name;
  @JsonKey(name: 'display_name')
  final String displayName;
  final int followers;
  @JsonKey(name: 'total_items')
  final int totalItems;
  @JsonKey(name: 'background_hash')
  final String backgroundHash;

  GalleryTag(this.id, this.name, this.displayName, this.followers, this.totalItems, this.backgroundHash);

  factory GalleryTag.fromJson(Map<String, dynamic> json) =>
      _$GalleryTagFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryTagToJson(this);
}
