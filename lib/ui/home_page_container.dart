import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:imgsrc/ui/home_page.dart';
import 'package:redux/redux.dart';
import 'package:video_player/video_player.dart';

class HomePageContainer extends StatelessWidget {
  final String title;

  HomePageContainer({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeViewModel>(
      onInit: (store) {
        if (store.state.galleryItems.length < 1) {
          store.dispatch(
              UpdateFilterAction(GalleryFilter(GallerySection.hot, GallerySort.viral, GalleryWindow.day, 0)));
        }
      },
      converter: (store) => HomeViewModel.fromStore(store),
      builder: (context, vm) {
        return MyHomePage(title, vm);
      },
    );
  }
}

class HomeViewModel {
  final List<GalleryItem> items;
  final GalleryFilter filter;
  final Map<String, GalleryItem> itemDetails;
  final Map<String, int> albumIndex;
  final Map<String, VideoPlayerController> videoControllers;

  HomeViewModel({@required this.items, @required this.filter, @required this.itemDetails, @required this.albumIndex, @required this.videoControllers});

  static HomeViewModel fromStore(Store<AppState> store) {
    return HomeViewModel(
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
