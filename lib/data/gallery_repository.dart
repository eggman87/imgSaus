import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:imgsrc/model/comment_models.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:http/http.dart' as http;


class GalleryRepository {
  const GalleryRepository();

  static const Map<String, String> headers = {"Authorization": "Client-ID b86d301956fea91"};

  Future<ParsedResponse<List<GalleryItem>>> getItems(
      GallerySection section, GallerySort sort, GalleryWindow window, int page) async {
    String sectionString = section.toString().split('.').last;
    String sortString = sort.toString().split('.').last;
    String windowString = window.toString().split('.').last;

    String url = "https://api.imgur.com/3/gallery/$sectionString/$sortString/$windowString/$page?count=100";
    print("making request to $url");
    http.Response response = await http.get(url, headers: headers);

    if (!ParsedResponse.isOkCode(response.statusCode)) {
      return ParsedResponse(response.statusCode, null);
    }

    List<dynamic> items = await compute(parseList, Parsable<GalleryItem>(response.body, "GalleryItem"));
    return ParsedResponse(response.statusCode, items.cast());
  }

  Future<ParsedResponse<List<Comment>>> getComments(String galleryId, CommentSort sort) async {
    String commentSort = sort.toString().split('.').last;
    String url = "https://api.imgur.com/3/gallery/$galleryId/comments/$commentSort";
    http.Response response = await http.get(url, headers: headers);

    if (!ParsedResponse.isOkCode(response.statusCode)) {
      return ParsedResponse(response.statusCode, null);
    }

    List<dynamic> items = await compute(parseList, Parsable<Comment>(response.body, "Comment"));
    return ParsedResponse(response.statusCode, items.cast());
  }

  Future<ParsedResponse<GalleryItem>> getAlbumDetails(String galleryItemId) async {
    String url = "https://api.imgur.com/3/gallery/album/$galleryItemId";
    http.Response response = await http.get(url, headers: headers);

    if (!ParsedResponse.isOkCode(response.statusCode)) {
      return ParsedResponse(response.statusCode, null);
    }

    dynamic item = await compute(parseItem, Parsable<GalleryItem>(response.body, "GalleryItem"));
    return ParsedResponse(response.statusCode, item);
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
  List<dynamic> list = jsonDecode(parsable.response)['data'];
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

  Parsable(this.response, this.className);
}

///
/// Slightly better than a function for each parser. We cannot pass a closure to a isolate.
///
dynamic jsonToItem(String className, dynamic itemJson) {
  if (className == "GalleryItem") {
    return GalleryItem.fromJson(itemJson);
  } else if (className == "Comment") {
    return Comment.fromJson(itemJson);
  }
}