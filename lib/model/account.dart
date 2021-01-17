import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  Account(
      {this.id,
      this.url,
      this.bio,
      this.reputation,
      this.created,
      this.avatar,
      this.cover,
      this.reputationName});

  final int id;
  final String url;
  final String bio;
  final int reputation;
  final int created;
  final String avatar;
  final String cover;
  @JsonKey(name: "reputation_name")
  final String reputationName;

  static const NAME = "Account";

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
