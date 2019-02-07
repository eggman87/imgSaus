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


class ApiError {
  final String message;

  ApiError(this.message);

}