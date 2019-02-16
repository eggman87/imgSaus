import 'package:flutter/material.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/ui/gallery_image_page.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class GalleryImageFullScreen extends StatelessWidget {
  GalleryImageFullScreen({Key key, this.item, this.parentTitle, this.videoPlayerController, this.onLongPress}) : super(key: key);

  final GalleryItem item;
  final String parentTitle;
  final VideoPlayerController videoPlayerController;
  final Function onLongPress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
            onTap: () => _onSingleTap(context),
            onLongPress: ()=> this.onLongPress(),
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                PhotoView.customChild(
                    child: GalleryImagePage(item, controller: videoPlayerController,),
                    childSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height)),
                SafeArea(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: kToolbarHeight,
                        child: AppBar(
                          title: Text(item.title ?? this.parentTitle ?? ''),
                          backgroundColor: Colors.transparent,
                        )))
              ],
            )));
  }
}

_onSingleTap(BuildContext context) {
  Navigator.pop(context);
}
