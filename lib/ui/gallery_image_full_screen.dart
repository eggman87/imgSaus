import 'package:flutter/material.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/ui/gallery_image_page.dart';
import 'package:photo_view/photo_view.dart';

class GalleryImageFullScreen extends StatelessWidget {
  GalleryImageFullScreen({Key key, this.item, this.parentTitle}) : super(key: key);

  final GalleryItem item;
  final String parentTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(item.title ?? this.parentTitle ?? ''),),
        body: PhotoView.customChild(
            child: GalleryImagePage(item),
            childSize: Size(MediaQuery
                .of(context)
                .size
                .width, MediaQuery
                .of(context)
                .size
                .height))
    );
  }
}
