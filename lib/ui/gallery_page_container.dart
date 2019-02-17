import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:imgsrc/ui/gallery_page.dart';
import 'package:redux/redux.dart';
import 'package:video_player/video_player.dart';

class GalleryPageContainer extends StatelessWidget {

  GalleryPageContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GalleryViewModel>(
      onInit: (store) {
        if (store.state.galleryItems.length < 1) {
          store.dispatch(
              UpdateFilterAction(GalleryFilter(GallerySection.hot, GallerySort.viral, GalleryWindow.day, 0)));
        }
      },
      converter: (store) => GalleryViewModel.fromStore(store),
      builder: (context, vm) {
        return GalleryPage(vm);
      },
    );
  }
}

class GalleryViewModel {
  final List<GalleryItem> items;
  final GalleryFilter filter;
  final Map<String, GalleryItem> itemDetails;
  final Map<String, int> albumIndex;
  final Map<String, VideoPlayerController> videoControllers;

  GalleryViewModel({@required this.items, @required this.filter, @required this.itemDetails, @required this.albumIndex, @required this.videoControllers});

  static GalleryViewModel fromStore(Store<AppState> store) {
    return GalleryViewModel(
      items: store.state.galleryItems,
      filter: store.state.galleryFilter,
      itemDetails: store.state.itemDetails,
      albumIndex: store.state.albumIndex,
      videoControllers: store.state.videoControllers
    );
  }

  GalleryItem currentVisibleItem(int itemIndex) {
    GalleryItem itemCurrentVisible = items[itemIndex];
    if (itemCurrentVisible.isAlbum) {
      int albumPosition = albumIndex[itemCurrentVisible.id] ?? 0;
      itemCurrentVisible = itemDetails[itemCurrentVisible.id].images[albumPosition];
    }
    return itemCurrentVisible;
  }
}
