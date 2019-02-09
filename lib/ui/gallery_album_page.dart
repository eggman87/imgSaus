import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/ui/gallery_album_page_container.dart';
import 'package:imgsrc/ui/gallery_image_view.dart';
import 'package:imgsrc/ui/vertical_swipe_detector.dart';
import 'package:video_player/video_player.dart';

class GalleryAlbumPage extends StatefulWidget {
  GalleryAlbumPage(this.viewModel, {Key key}) : super(key: key);

  final AlbumDetailsViewModel viewModel;

  @override
  _GalleryAlbumPageState createState() => _GalleryAlbumPageState();
}

class _GalleryAlbumPageState extends State<GalleryAlbumPage> {
  //note: if the album is large enough, we might have to manually dispose as user swipes through...
  Map<int, VideoPlayerController> _controllers = new Map();

  //view model driven by store.
  AlbumDetailsViewModel _vm;

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }

    _controllers.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _vm = widget.viewModel;

    if (_vm.itemDetails == null) {
      return Container();
    }
    var images = _vm.itemDetails.images;
    var albumPos = _vm.albumIndex;

    String imageUrl = images[albumPos].imageUrl();
    Widget widgetToWrap;
    if (GalleryItem.isLinkVideo(imageUrl)) {
      VideoPlayerController controller = _controllers[albumPos];
      VideoPlayer player;

      if (controller == null) {
        controller = VideoPlayerController.network(imageUrl);
        player = VideoPlayer(controller);
        _controllers[albumPos] = controller;
        controller.setLooping(true);
        controller.setVolume(0);

        controller.initialize().then((_) {
          setState(() {
            controller.play();
          });
        });
      } else {
        player = new VideoPlayer(controller);
      }
      widgetToWrap = player;
    } else {
      //look into why we have to use keys here.
      widgetToWrap = new GalleryImageView(imageUrl: imageUrl, key: Key(imageUrl),);
    }
    return VerticalSwipeDetector(child: widgetToWrap, onSwipeUp: _onSwipeUp, onSwipeDown: _onSwipeDown);
  }

  void _onSwipeUp() {
    if (_vm.albumIndex < _vm.itemDetails.images.length - 1) {
      setState(() {
        StoreProvider.of<AppState>(context)
            .dispatch(UpdateAlbumIndexAction(widget.viewModel.itemDetails.id, _vm.albumIndex + 1));
      });
    }
  }

  void _onSwipeDown() {
    if (_vm.albumIndex > 0) {
      setState(() {
        StoreProvider.of<AppState>(context)
            .dispatch(UpdateAlbumIndexAction(widget.viewModel.itemDetails.id, _vm.albumIndex - 1));
      });
    }
  }
}
