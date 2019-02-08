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
    return 'GalleryLoadedAction {countLoaded=${items.length}}';
  }
}

class CommentsLoadedAction {
  final String itemId;
  final List<Comment> comments;

  CommentsLoadedAction(this.itemId, this.comments);

  @override
  String toString() {
    return "CommentsLoadedAction {itemId=$itemId, countLoaded=${comments.length}}";
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

class LoadAlbumDetailsAction {
  final GalleryItem item;

  LoadAlbumDetailsAction(this.item);

  @override
  String toString() {
    return 'LoadAlbumDetailsAction {itemId=${item.id}}';
  }
}

class ItemDetailsLoadedAction {
  final String itemId;
  final GalleryItem item;

  ItemDetailsLoadedAction(this.itemId, this.item);

  @override
  String toString() {
    return 'ItemDetailsLoadedAction {itemId=$itemId, imageCount=${this.item.images.length}}';
  }
}

class UpdateAlbumIndexAction {
  final String itemId;
  final int newPosition;

  UpdateAlbumIndexAction(this.itemId, this.newPosition);

  @override
  String toString() {
    return 'UpdateAlbumIndexAction {itemId=$itemId, newPosition=$newPosition}';
  }
}

class ApiError {
  final String message;

  ApiError(this.message);

}