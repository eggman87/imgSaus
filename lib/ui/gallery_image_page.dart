import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/ui/gallery_image_view.dart';
import 'package:redux/redux.dart';
import 'package:video_player/video_player.dart';

class GalleryImagePage extends StatefulWidget {
  GalleryImagePage(
    this.item, {
    Key key,
    VideoPlayerController controller
  }) : this.controller = controller, super(key: key);

  final GalleryItem item;
  VideoPlayerController controller;

  @override
  _GalleryImagePageState createState() => _GalleryImagePageState();
}

class _GalleryImagePageState extends State<GalleryImagePage> {
  VideoPlayerController _controller;
  Store<AppState> _store;

  @override
  void dispose() {
    //this means we are the owner of this controller and we must destroy it, otherwise someone else owns it.
    if (widget.controller == null) {
      if (_controller != null) {
        _controller.dispose();
        _controller = null;
      }
      if (_store != null) {
        _store.dispatch(ClearVideoControllerAction(widget.item.id));
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.item.imageUrl();

    if (_controller != null) {
      _controller.dispose();
    }


    if (GalleryItem.isLinkVideo(imageUrl)) {
      if (widget.controller != null) {
        _controller = widget.controller;
      } else {
        _controller = VideoPlayerController.network(imageUrl);
        _store = StoreProvider.of<AppState>(context);
        _store.dispatch(SetVideoControllerAction(widget.item.id, _controller));
        _controller.setLooping(true);
        _controller.setVolume(0);

        _controller.initialize().then((_) {
          _controller.play();
        });
      }

      var player = VideoPlayer(_controller);
      return Hero(tag: "gallery_video", child: player);
    } else {
      return GalleryImageView(imageUrl: imageUrl);
    }
  }
}
