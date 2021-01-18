import 'package:imgsrc/model/account_image.dart';
import 'package:imgsrc/model/comment_models.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:imgsrc/model/gallery_tag.dart';
import 'package:video_player/video_player.dart';

import 'account.dart';

class AppState {
  final bool isLoadingGallery;
  final Account currentAccount;
  final LoadedAccountImages accountImages;
  final GalleryFilter galleryFilter;
  final List<GalleryItem> galleryItems;
  final Map<String, List<Comment>> itemComments;
  final Map<String, GalleryItem> itemDetails;
  final Map<String, int> albumIndex;

  //need to share these between widgets to keep current video playback when switching between fullscreen/view
  final Map<String, VideoPlayerController> videoControllers;
  final List<GalleryTag> galleryTags;

  AppState(
      {
        this.isLoadingGallery = false,
        this.currentAccount,
        this.accountImages = const LoadedAccountImages([], 0, false),
        this.itemDetails = const {},
        this.galleryItems = const [],
        this.galleryFilter = const GalleryFilter(GallerySort.top, GalleryWindow.day, 0, section: GallerySection.hot),
        this.itemComments = const {},
        this.albumIndex = const {},
        this.videoControllers = const {},
        this.galleryTags = const []
      });

  factory AppState.loading() => AppState(isLoadingGallery: true);

  @override
  String toString() {
    return '{isLoading=$isLoadingGallery, '
        'currentAccount=$currentAccount,'
        'accountImages=${accountImages.images.length}'
        'galleryItemCount=${galleryItems.length}, '
        'filter=$galleryFilter, '
        'itemCommentCount=${itemComments.length}, '
        'itemDetails=${itemDetails.length} ';
  }
}
