import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/model/gallery_models.dart';

class AppState {
  final bool isLoading;
  final GalleryFilter galleryFilter;
  final List<GalleryItem> galleryItems;

  AppState(
      {this.isLoading = false,
      this.galleryItems = const [],
      this.galleryFilter = const GalleryFilter(GallerySection.hot, GallerySort.top, GalleryWindow.day, 0)});

  factory AppState.loading() => AppState(isLoading: true);
}
