
import 'dart:async';
import 'dart:convert';

import 'package:imgsrc/model/comment_models.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:http/http.dart' as http;

class GalleryRepository {

  static const Map<String, String> headers = {"Authorization":"Client-ID b86d301956fea91"};

  Future<ParsedResponse<List<GalleryItem>>> getItems(GallerySection section, GallerySort sort, GalleryWindow window, int page) async {
    String sectionString = section.toString().split('.').last;
    String sortString = sort.toString().split('.').last;
    String windowString = window.toString().split('.').last;

    String url = "https://api.imgur.com/3/gallery/$sectionString/$sortString/$windowString/$page?count=100";
    print("making request to $url");
    http.Response response = await http.get(url, headers: headers);

    if (!ParsedResponse.isOkCode(response.statusCode)) {
      return ParsedResponse(response.statusCode, null);
    }

    List<dynamic> list = jsonDecode(response.body)['data'];
    print("loaded ${list.length} gallery items from the api");
    List<GalleryItem> items = new List();

    for (dynamic itemJson in list) {
      items.add(GalleryItem.fromJson(itemJson));
    }

    return ParsedResponse(response.statusCode, items);
  }

  Future<ParsedResponse<List<Comment>>> getComments(String galleryId, CommentSort sort) async {
    String commentSort = sort.toString().split('.').last;
    String url = "https://api.imgur.com/3/gallery/$galleryId/comments/$commentSort";
    http.Response response = await http.get(url, headers: headers);

    if (!ParsedResponse.isOkCode(response.statusCode)) {
      return ParsedResponse(response.statusCode, null);
    }

    List<dynamic> list = jsonDecode(response.body)['data'];
    List<Comment> items = new List();

    for (dynamic commentJson in list) {
      items.add(Comment.fromJson(commentJson));
    }

    return ParsedResponse(response.statusCode, items);
  }



  Future<ParsedResponse<GalleryItem>> getAlbumDetails(String galleryItemId) async {
    String url = "https://api.imgur.com/3/gallery/album/$galleryItemId";
    http.Response response = await http.get(url, headers: headers);

    if (!ParsedResponse.isOkCode(response.statusCode)) {
      return ParsedResponse(response.statusCode, null);
    }

    dynamic rawItem = jsonDecode(response.body)['data'];
    GalleryItem item = GalleryItem.fromJson(rawItem);

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

