import 'package:imgsrc/model/comment_models.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/model/gallery_models.dart';

class UpdateFilterAction {
  final GalleryFilter newFilter;

  UpdateFilterAction(this.newFilter);

  @override
  String toString() {
    return 'UpdateFilterAction{newFilter: $newFilter';
  }
}

class GalleryLoadedAction {
  final List<GalleryItem> items;

  GalleryLoadedAction(this.items);

  @override
  String toString() {
    return 'GalleryLoadedAction {items=$items}';
  }
}

class CommentsLoadedAction {
  final String itemId;
  final List<Comment> comments;

  CommentsLoadedAction(this.itemId, this.comments);

  @override
  String toString() {
    return "CommentsLoadedAction {items=$comments}";
  }
}

class LoadCommentsAction {
  final String itemId;

  LoadCommentsAction(this.itemId);

  @override
  String toString() {
    return "LoadCommentsAction {itemId=$itemId}";
  }
}

class ClearCommentsAction {
  final String itemId;

  ClearCommentsAction(this.itemId);

  @override
  String toString() {
    return "ClearCommentsAction {itemId=$itemId}";
  }
}


class ApiError {
  final String message;

  ApiError(this.message);

}