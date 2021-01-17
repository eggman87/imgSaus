import 'package:imgsrc/model/account.dart';
import 'package:imgsrc/model/account_image.dart';
import 'package:imgsrc/model/comment_models.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:imgsrc/model/gallery_tag.dart';
import 'package:video_player/video_player.dart';

class UpdateFilterAction {
  final GalleryFilter newFilter;

  UpdateFilterAction(this.newFilter);

  @override
  String toString() {
    return 'UpdateFilterAction{newFilter: $newFilter';
  }
}

class GalleryLoadedAction {
  final GalleryFilter filter;
  final List<GalleryItem> items;

  GalleryLoadedAction(this.items, this.filter);

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

class LoadAlbumImagesAction {
  final GalleryItem item;

  LoadAlbumImagesAction(this.item);

  @override
  String toString() {
    return 'LoadAlbumImagesAction {itemId=${item.id}}';
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

class LoadGalleryTagsAction {

  @override
  String toString() {
    return 'LoadGalleryTagsAction {}';
  }
}

class GalleryTagsLoadedAction {

  final List<GalleryTag> tags;

  GalleryTagsLoadedAction(this.tags);

  @override
  String toString() {
    return 'GalleryTagsLoadedAction {tagsCount=${tags.length}';
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

class SetVideoControllerAction {
  final String itemId;
  final VideoPlayerController controller;

  SetVideoControllerAction(this.itemId, this.controller);
}

class ClearVideoControllerAction {
  final String itemId;

  ClearVideoControllerAction(this.itemId);
}

class GetAccountAction {

}

class AccountLoadedAction {
  final Account account;

  AccountLoadedAction(this.account);
}

class LoadAccountImagesAction {
  final int page;

  LoadAccountImagesAction(this.page);
}

class AccountImagesLoadedAction {
  final int page;
  final List<AccountImage> images;

  AccountImagesLoadedAction(this.page, this.images);
}

class IsLoadingAction {
  final bool isLoading;

  IsLoadingAction(this.isLoading);
}

class ApiError {
  final String message;

  ApiError(this.message);

}