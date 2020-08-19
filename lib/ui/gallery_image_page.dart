import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/ui/gallery_image_view.dart';
import 'package:redux/redux.dart';
import 'package:video_player/video_player.dart';

class GalleryImagePage extends StatefulWidget {
  GalleryImagePage(this.item, {Key key, VideoPlayerController controller, bool initialSoundOn = false })
      : this.controller = controller, this.initialSoundOn = initialSoundOn,
        super(key: key);

  final GalleryItem item;
  VideoPlayerController controller;
  final bool initialSoundOn;

  @override
  _GalleryImagePageState createState() => _GalleryImagePageState();
}

class _GalleryImagePageState extends State<GalleryImagePage> {
  VideoPlayerController _controller;
  Store<AppState> _store;
  bool _soundOn = false;

  //did we create the controller? if so we are responsible for destroying it.
  bool _isVideoControllerOwner = false;

  @override
  void dispose() {
    if (_isVideoControllerOwner) {
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

  void toggleSound() {
    //there is no way to read volume so we have to keep that state
    if (_soundOn ) {
      _soundOn = false;
    } else {
      _soundOn = true;
    }

    updateSoundBasedOnState();
  }

  void updateSoundBasedOnState() {
    if (_soundOn ) {
      _controller.setVolume(100);
    } else {
      _controller.setVolume(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.item.imageUrl();

    if (GalleryItem.isLinkVideo(imageUrl)) {
      _soundOn = widget.initialSoundOn;
      if (widget.controller != null) {
        _controller = widget.controller;
        updateSoundBasedOnState();
      } else {
        _controller = VideoPlayerController.network(imageUrl);
        _isVideoControllerOwner = true;
        _store = StoreProvider.of<AppState>(context);
        _store.dispatch(SetVideoControllerAction(widget.item.id, _controller));
        _controller.setLooping(true);
        updateSoundBasedOnState();
        _controller.initialize().then((_) {
          setState(() {}); //necessary to trigger rebuild of controller aspect ratio.
          _controller.play();
        });
      }

      var player = VideoPlayer(_controller);
      return _controller.value.initialized
          ? Center(
              child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: GestureDetector(
                  onTap: this.toggleSound,
                  child: Hero(tag: "gallery_video", child: player)),
            ))
          : Container();
    } else {
      return GalleryImageView(imageUrl: imageUrl);
    }
  }
}
