import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/account.dart';
import 'package:imgsrc/model/comment_models.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:imgsrc/model/gallery_tag.dart';
import 'package:redux/redux.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:video_player/video_player.dart';

final isLoadingGalleryReducer = combineReducers<bool>([
  TypedReducer<bool, IsLoadingAction>(_setIsLoading),
]);

final galleryReducer = combineReducers<List<GalleryItem>>([
  TypedReducer<List<GalleryItem>, GalleryLoadedAction>(_setLoadedGalleryItems),
]);

final galleryTagsReducer = combineReducers<List<GalleryTag>>([
  TypedReducer<List<GalleryTag>, GalleryTagsLoadedAction>(_setGalleryTags),
]);

final commentsReducer = combineReducers<Map<String, List<Comment>>>([
  TypedReducer<Map<String, List<Comment>>, CommentsLoadedAction>(_setLoadedComments),
  TypedReducer<Map<String, List<Comment>>, ClearCommentsAction>(_clearLoadedComments),
]);

final activeFilterReducer = combineReducers<GalleryFilter>([
  TypedReducer<GalleryFilter, UpdateFilterAction>(_activeFilterReducer)
]);

final itemDetailsReducer = combineReducers<Map<String, GalleryItem>>([
  TypedReducer<Map<String, GalleryItem>, LoadAlbumImagesAction>(_setPreloadItemDetails),
  TypedReducer<Map<String, GalleryItem>, ItemDetailsLoadedAction>(_setLoadedItemDetails),
]);

final albumIndexReducer = combineReducers<Map<String, int>>([
  TypedReducer<Map<String, int>, UpdateAlbumIndexAction>(_setAlbumIndex)
]);

final videoControllerReducer = combineReducers<Map<String, VideoPlayerController>>([
  TypedReducer<Map<String, VideoPlayerController>, SetVideoControllerAction>(_setVideoController),
  TypedReducer<Map<String, VideoPlayerController>, ClearVideoControllerAction>(_clearVideoController),
]);

final accountReducer = combineReducers<Account>([
  TypedReducer<Account, AccountLoadedAction>(_setLoadedAccount)
]);

bool _setIsLoading(bool isLoading, IsLoadingAction action) {
  if (isLoading != action.isLoading) {
    return action.isLoading;
  }
  return isLoading;
}

Account _setLoadedAccount(Account account, AccountLoadedAction action) {
  //todo: possibly clear stuff if account changes.
  return action.account;
}

List<GalleryItem> _setLoadedGalleryItems(List<GalleryItem> items, GalleryLoadedAction action) {
  if (action.filter.page == 0) {
    return action.items;
  } else {
    return List.from(items)..addAll(action.items);
  }
}

List<GalleryTag> _setGalleryTags(List<GalleryTag> tags, GalleryTagsLoadedAction action) {
  return action.tags;
}

GalleryFilter _activeFilterReducer(GalleryFilter activeFilter, UpdateFilterAction action) {
  return action.newFilter;
}

Map<String, List<Comment>> _setLoadedComments(Map<String, List<Comment>> existingComments, CommentsLoadedAction action) {
  return Map.from(existingComments)..addAll({action.itemId : action.comments});
}

Map<String, List<Comment>> _clearLoadedComments(Map<String, List<Comment>> existingComments, ClearCommentsAction action) {
  existingComments.remove(action.itemId);
  return existingComments;
}

Map<String, GalleryItem> _setLoadedItemDetails(Map<String, GalleryItem> existingDetails, ItemDetailsLoadedAction action) {
  existingDetails = Map.from(existingDetails)..addAll({action.itemId : action.item});
  return existingDetails;
}

///Sets item details before hitting middleware to load from api (images are present on the list item).
Map<String, GalleryItem> _setPreloadItemDetails(Map<String, GalleryItem> existingDetails, LoadAlbumImagesAction action) {
  return Map.from(existingDetails)..addAll({action.item.id : action.item});
}

Map<String, int> _setAlbumIndex(Map<String, int> existingIndex, UpdateAlbumIndexAction action) {
  return Map.from(existingIndex)..addAll({action.itemId: action.newPosition});
}

Map<String, VideoPlayerController> _setVideoController(Map<String, VideoPlayerController> existingControllers, SetVideoControllerAction action) {
  return Map.from(existingControllers)..addAll({action.itemId : action.controller});
}

Map<String, VideoPlayerController> _clearVideoController(Map<String, VideoPlayerController> existingControllers, ClearVideoControllerAction action) {
  existingControllers.remove(action.itemId);
  return existingControllers;
}
