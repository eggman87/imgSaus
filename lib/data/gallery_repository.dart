import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:imgsrc/model/account.dart';
import 'package:imgsrc/model/comment_models.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:http/http.dart' as http;
import 'package:imgsrc/model/gallery_tag.dart';
import 'package:imgsrc/model/account_image.dart';

import 'auth.dart';


class GalleryRepository {
  const GalleryRepository();

  static const BASE_URL = "https://api.imgur.com/3";
  static Map<String, String> headers = {"Authorization": "Client-ID ${DotEnv().env['IMGUR_CLIENT_ID']}"};

  Future<ParsedResponse<List<GalleryItem>>> getItems(GalleryFilter filter) async {
    String url = BASE_URL + filter.toApiUrl();
    print("making request to $url");
    http.Response response = await http.get(url, headers: headers);

    if (!ParsedResponse.isOkCode(response.statusCode)) {
      return ParsedResponse(response.statusCode, null);
    }

    List<dynamic> items = await compute(parseList, Parsable<GalleryItem>(response.body, GalleryItem.NAME, subKey: filter.subKey()));
    return ParsedResponse(response.statusCode, items.cast());
  }

  Future<ParsedResponse<List<Comment>>> getComments(String galleryId, CommentSort sort) async {
    String commentSort = sort.toString().split('.').last;
    String url = '$BASE_URL/gallery/$galleryId/comments/$commentSort';
    http.Response response = await http.get(url, headers: headers);

    if (!ParsedResponse.isOkCode(response.statusCode)) {
      return ParsedResponse(response.statusCode, null);
    }

    List<dynamic> items = await compute(parseList, Parsable<Comment>(response.body, Comment.NAME));
    return ParsedResponse(response.statusCode, items.cast());
  }

  Future<ParsedResponse<GalleryItem>> getAlbumDetails(String galleryItemId) async {
    String url = "$BASE_URL/gallery/album/$galleryItemId";
    http.Response response = await http.get(url, headers: headers);

    if (!ParsedResponse.isOkCode(response.statusCode)) {
      return ParsedResponse(response.statusCode, null);
    }

    dynamic item = await compute(parseItem, Parsable<GalleryItem>(response.body, GalleryItem.NAME));
    return ParsedResponse(response.statusCode, item);
  }

  Future<ParsedResponse<List<GalleryTag>>> getTags() async {
    http.Response response = await http.get('$BASE_URL/tags', headers: headers);

    if (!ParsedResponse.isOkCode(response.statusCode)) {
      return ParsedResponse(response.statusCode, null);
    }

    List<dynamic> tags = await compute(parseList, Parsable<GalleryTag>(response.body, GalleryTag.NAME, subKey: GalleryTag.TAGS_SUB_KEY));
    return ParsedResponse(response.statusCode, tags.cast());
  }

  Future<ParsedResponse<Account>> getAccount() async {
    String url = "$BASE_URL/account/me";

    http.Response response = await Authentication.oauth2Helper.get(url, headers: headers);

    if (!ParsedResponse.isOkCode(response.statusCode)) {
      return ParsedResponse(response.statusCode, null);
    }

    dynamic item = await compute(parseItem, Parsable<Account>(response.body, Account.NAME));
    return ParsedResponse(response.statusCode, item);
  }

  Future<ParsedResponse<List<AccountImage>>> getAccountImages(int page) async {
    String url = "$BASE_URL/account/me/images/$page";

    http.Response response = await Authentication.oauth2Helper.get(url, headers: headers);

    if (!ParsedResponse.isOkCode(response.statusCode)) {
      return ParsedResponse(response.statusCode, null);
    }

    List<dynamic> accountImages = await compute(parseList, Parsable<AccountImage>(response.body, AccountImage.NAME));
    return ParsedResponse(response.statusCode, accountImages.cast());
  }
}

class ParsedResponse<T> {
  ParsedResponse(this.statusCode, this.body);

  final int statusCode;
  final T body;

  bool isOk() {
    return isOkCode(statusCode);
  }

  static isOkCode(int code) {
    return code >= 200 && code < 300;
  }
}

List<T> parseList<T>(Parsable<T> parsable) {
  List<dynamic> list;
  if (parsable.subKey != null) {
    list = jsonDecode(parsable.response)['data'][parsable.subKey];
  } else {
    list = jsonDecode(parsable.response)['data'];
  }

  print("[parse] ${list.length} of ${parsable.className} from the api");
  if (list.length > 0) {
    print("[parse]firstItem: ${list[0]}");
  }
  List<T> items = new List();

  for (dynamic itemJson in list) {
    items.add(jsonToItem(parsable.className, itemJson));
  }
  return items;
}

T parseItem<T>(Parsable<T> parsable) {
  dynamic item = jsonDecode(parsable.response)['data'];
  print('[parse] ${parsable.className} details: $item');
  return jsonToItem(parsable.className, item);
}

class Parsable<T> {
  final String response;
  final String className;
  final String subKey;

  Parsable(this.response, this.className, { this.subKey });
}

///
/// Slightly better than a function for each parser. We cannot pass a closure to a isolate.
///
dynamic jsonToItem(String className, dynamic itemJson) {
  if (className == GalleryItem.NAME) {
    return GalleryItem.fromJson(itemJson);
  } else if (className == Comment.NAME) {
    return Comment.fromJson(itemJson);
  } else if (className == GalleryTag.NAME) {
    return GalleryTag.fromJson(itemJson);
  } else if (className == Account.NAME) {
    return Account.fromJson(itemJson);
  } else if (className == AccountImage.NAME) {
    return AccountImage.fromJson(itemJson);
  }
}