import 'package:json_annotation/json_annotation.dart';

part 'account_image.g.dart';

@JsonSerializable()
class AccountImage {

  AccountImage({
    this.id,
    this.title,
    this.type,
    this.width,
    this.height,
    this.views,
    this.link
  });

  final int id;
  final String title;
  final String type;
  final int width;
  final int height;
  final int views;
  final String link;

  static const NAME = "AccountImage";

  factory AccountImage.fromJson(Map<String, dynamic> json) =>
      _$AccountImageFromJson(json);

  Map<String, dynamic> toJson() => _$AccountImageToJson(this);
}