import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/comment_models.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:redux/redux.dart';
import 'package:imgsrc/model/gallery_item.dart';

final galleryReducer = combineReducers<List<GalleryItem>>([
  TypedReducer<List<GalleryItem>, GalleryLoadedAction>(_setLoadedGalleryItems),
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

List<GalleryItem> _setLoadedGalleryItems(List<GalleryItem> items, GalleryLoadedAction action) {
  return action.items;
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