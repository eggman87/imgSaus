import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:redux/redux.dart';
import 'package:imgsrc/model/gallery_item.dart';

final galleryReducer = combineReducers<List<GalleryItem>>([
  TypedReducer<List<GalleryItem>, GalleryLoadedAction>(_setLoadedGalleryItems),
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