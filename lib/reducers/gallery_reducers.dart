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

List<GalleryItem> _setLoadedGalleryItems(List<GalleryItem> items, GalleryLoadedAction action) {
  return action.items;
}

GalleryFilter _activeFilterReducer(GalleryFilter activeFilter, UpdateFilterAction action) {
  return action.newFilter;
}

Map<String, List<Comment>> _setLoadedComments(Map<String, List<Comment>> existingComments, CommentsLoadedAction action) {
  existingComments = Map.from(existingComments)..addAll({action.itemId : action.comments});
  return existingComments;
}

Map<String, List<Comment>> _clearLoadedComments(Map<String, List<Comment>> existingComments, ClearCommentsAction action) {
  existingComments.remove(action.itemId);
  return existingComments;
}