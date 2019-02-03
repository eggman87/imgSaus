import 'package:json_annotation/json_annotation.dart';

part 'gallery_item.g.dart';

@JsonSerializable()
class GalleryItem {

  GalleryItem({this.id, this.title, this.type, this.animated, this.isAlbum, this.link, this.images, this.mp4});

  final String id;
  final String title;
  final String type;
  final bool animated;
  //this field is misleading, a album can have 1 image only
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

    //isAlbum can be null for sub images which is not actually a galleryitem model (might create new model soon).
    if (isAlbum != null && isAlbum) {
      return this.images[0].link;
    } else {
      return link;
    }
  }

  bool isAlbumWithMoreThanOneImage() {
    return isAlbum != null && isAlbum && images.length > 1;
  }
}