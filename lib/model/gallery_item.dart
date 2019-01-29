import 'package:json_annotation/json_annotation.dart';

part 'gallery_item.g.dart';

@JsonSerializable()
class GalleryItem {

  GalleryItem({this.id, this.title, this.type, this.animated, this.isAlbum, this.link, this.images, this.mp4});

  final String id;
  final String title;
  final String type;
  final bool animated;
  @JsonKey(name: "is_album")
  final bool isAlbum;
  final String link;
  final List<GalleryItem> images;
  final String mp4;


  factory GalleryItem.fromJson(Map<String, dynamic> json) => _$GalleryItemFromJson(json);

  Map<String, dynamic>toJson() => _$GalleryItemToJson(this);

  String pageUrl() {
    if (mp4 != null) {
      return mp4;
    }

    if (isAlbum) {
      return this.images[0].link;
    } else {
      return link;
    }
  }
}