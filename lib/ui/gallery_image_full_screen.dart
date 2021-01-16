import 'package:flutter/material.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/ui/comments_list_container.dart';
import 'package:imgsrc/ui/gallery_image_page.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class GalleryImageFullScreen extends StatelessWidget {
  GalleryImageFullScreen(
      {Key key, this.item, this.parentId, this.parentTitle, this.videoPlayerController, this.onLongPress})
      : super(key: key);

  final GalleryItem item;
  final String parentId;
  final String parentTitle;
  final VideoPlayerController videoPlayerController;
  final Function onLongPress;

  @override
  Widget build(BuildContext context) {
     return WillPopScope(onWillPop: _onWillPop, child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
            onDoubleTap: () => _openComments(context),
            onTap: () => _onSingleTap(context),
            onLongPress: () => this.onLongPress(),
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                PhotoView.customChild(
                    child: GalleryImagePage(
                      item,
                      controller: videoPlayerController,
                      initialSoundOn: true,
                    ),
                    childSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height)),
                Positioned(child: IconButton(
                  icon: Icon(Icons.close_fullscreen),
                  color: Colors.white,
                  onPressed: ()=> {_onSingleTap(context) },
                ), right: 8, bottom: 8, width: 62, height: 62,),
                SafeArea(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: kToolbarHeight,
                        child: AppBar(
                          title: Text(item.title ?? this.parentTitle ?? ''),
                          backgroundColor: Colors.transparent,
                          actions: <Widget>[
                            IconButton(
                              icon: Icon(Icons.message),
                              onPressed: () => _openComments(context),
                            )
                          ],
                        )))
              ],
            ))));
  }

  Future<bool> _onWillPop() async {
    if (videoPlayerController != null) {
      videoPlayerController.setVolume(0);
    }
    return true;
  }

  _onSingleTap(BuildContext context) {
    if (videoPlayerController != null) {
      videoPlayerController.setVolume(0);
    }
    Navigator.pop(context);
  }

  _openComments(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return CommentsSheetContainer(
            galleryItemId: parentId,
            key: Key(parentId),
          );
        });
  }
}
