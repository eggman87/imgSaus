
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/ui/gallery_album_page.dart';
import 'package:redux/redux.dart';

class AlbumPageContainer extends StatelessWidget {
  final GalleryItem item;

  AlbumPageContainer({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AlbumDetailsViewModel>(
      onInit: (store) {
        store.dispatch(LoadAlbumDetailsAction(item));
      },
      converter: (store) => AlbumDetailsViewModel.fromStore(item.id, store),
      builder: (context, vm) {
        return GalleryAlbumPage(vm);
      },
    );
  }
}

class AlbumDetailsViewModel {
  final GalleryItem itemDetails;
  final int albumIndex;

  AlbumDetailsViewModel({@required this.itemDetails, @required this.albumIndex});

  static AlbumDetailsViewModel fromStore(String itemId, Store<AppState> store) {
    return AlbumDetailsViewModel(
      itemDetails: store.state.itemDetails[itemId],
      albumIndex: store.state.albumIndex[itemId] ?? 0
    );
  }
}