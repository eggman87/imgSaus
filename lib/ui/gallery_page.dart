import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/data/analytics.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:flutter/foundation.dart';
import 'package:imgsrc/ui/comments_list_container.dart';
import 'package:imgsrc/ui/gallery_album_page_container.dart';
import 'package:imgsrc/ui/gallery_image_full_screen.dart';
import 'package:imgsrc/ui/gallery_image_page.dart';
import 'package:imgsrc/ui/gallery_page_container.dart';
import 'package:imgsrc/ui/image_file_utils.dart';
import 'package:share_extend/share_extend.dart';
import 'package:timeago/timeago.dart';

class GalleryPage extends StatefulWidget {
  GalleryPage(this.viewModel, {Key key}) : super(key: key);

  final GalleryViewModel viewModel;

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  //view model driven by store.
  GalleryViewModel _vm;
  int _pagePosition = 0;

  void _loadNextPage(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatch(UpdateFilterAction(_vm.filter.copyWith(page: _vm.filter.page + 1)));
  }

  void _onCommentsTapped(BuildContext context) {
    //subreddit galleries do not have comments
    if (_vm.filter.subRedditName != null) {
      return;
    }
    GalleryItem currentItem = _currentGalleryItem();
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return CommentsSheetContainer(
            galleryItemId: currentItem.id,
            key: Key(currentItem.id),
          );
        });
  }

  void _onLongPress() {
    this._shareCurrentItem(shouldPop: false);
  }

  void _changeFilter() {}

  void _fullScreen({bool shouldPop = false}) {
    if (shouldPop) {
      Navigator.pop(context);
    }

    var itemCurrentVisible = _vm.currentVisibleItem(_pagePosition);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GalleryImageFullScreen(
              item: itemCurrentVisible,
              onLongPress: this._shareCurrentItem,
              parentId: _vm.items[_pagePosition].id,
              parentTitle: _vm.items[_pagePosition].title,
              videoPlayerController: _vm.videoControllers[itemCurrentVisible.id])),
    );
  }

  void _shareCurrentItem({bool shouldPop = false}) {
    if (shouldPop) {
      Navigator.pop(context);
    }

    var itemCurrentVisible = _vm.currentVisibleItem(_pagePosition);

    Analytics.instance().logEvent(name: "shareCurrentItem", parameters: {'url': itemCurrentVisible.imageUrl()});
    if (itemCurrentVisible.isVideo()) {
      ShareExtend.share(
          "from imgSaus: ${itemCurrentVisible.title ?? _vm.items[_pagePosition].title} ${itemCurrentVisible.imageUrl()}",
          "text");
    } else {
      _shareCurrentImage(itemCurrentVisible);
    }
  }

  void _shareCurrentImage(GalleryItem item) {
    var imageFile = ImageFileUtils();
    imageFile.writeImageToFile(item.imageUrl()).then((it) {
      ShareExtend.share(it.path, "image");
    });
  }

  GalleryItem _currentGalleryItem() {
    if (_vm.items.length > 0) {
      return _vm.items[_pagePosition];
    }
    return null;
  }

  void _onPageChanged(BuildContext context, int position) {
    setState(() {
      _pagePosition = position;
    });

    if (position == _vm.items.length - 5) {
      _loadNextPage(context);
    }
  }

  void _onTapLogin() {}

  @override
  Widget build(BuildContext context) {
    _vm = widget.viewModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(_vm.isGalleryLoading ? 'loading' : _vm.filter.title()),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _changeFilter(),
          )
        ],
      ),
      drawer: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 120, 0),
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.background),
                child: GestureDetector(
                  child: Center(child: Text("TAP TO LOGIN")),
                  onTap: _onTapLogin,
                ),
              ),
              Row(
                children: <Widget>[
                  Visibility(
                      visible: _vm.items.length > 0,
                      child: Text("  Currently viewing ${_pagePosition + 1}/${_vm.items.length}"))
                ],
              ),
              ListTile(
                title: Text(
                  "SECTION",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  Text(
                    "hot",
                    style: _selectableStyle(_vm.filter.section == GallerySection.hot),
                  ),
                  Spacer(),
                  Text(
                    "top",
                    style: _selectableStyle(_vm.filter.section == GallerySection.top),
                  ),
                  Spacer(),
                  Text(
                    "User",
                    style: _selectableStyle(_vm.filter.section == GallerySection.user),
                  ),
                  Spacer(),
                ],
              ),
              ListTile(
                title: Text(
                  "SORT",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  Text(
                    "viral",
                    style: _selectableStyle(_vm.filter.sort == GallerySort.viral),
                  ),
                  Spacer(),
                  Text(
                    "top",
                    style: _selectableStyle(_vm.filter.sort == GallerySort.top),
                  ),
                  Spacer(),
                  Text(
                    "time",
                    style: _selectableStyle(_vm.filter.sort == GallerySort.time),
                  ),
                  Spacer(),
                  Text(
                    "rising",
                    style: _selectableStyle(_vm.filter.sort == GallerySort.rising),
                  ),
                  Spacer(),
                ],
              ),
            ],
          )),
      body: _body(),
    );
  }

  //todo refactor to widget to avoid perf hit.
  Widget _body() {
    if (_vm.isGalleryLoading || _vm.items.length == 0) {
      return Container(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      GalleryItem item = _currentGalleryItem();

      return Container(
          color: Colors.black,
          child: Column(
            children: <Widget>[
              Container(
                padding:EdgeInsets.fromLTRB(10, 4, 10, 4),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment(-1, -1),
                      child: Text(
                        _galleryItemTitle(),
                        maxLines: 6,
                        style: TextStyle(fontSize: 17, fontWeight:FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(format(item.dateCreated), style: TextStyle(letterSpacing: 1.1, color: Colors.red),)
                      ],
                    ),
                  ],
                )
              ),

              Expanded(
                child: GestureDetector(
                  child: _pageView(context),
                  onLongPress: _onLongPress,
                  onTap: _fullScreen,
                  onDoubleTap: () => this._onCommentsTapped(context),
                ),
              ),
            ],
          ));
    }
  }

  TextStyle _selectableStyle(bool isSelected) {
    if (isSelected) {
      return TextStyle(color: Colors.green);
    } else {
      return TextStyle(color: Colors.black);
    }
  }

  String _galleryItemTitle() {
    if (_vm.items.length > 0) {
      GalleryItem item = _currentGalleryItem();
      String title = item.title;
      if (item.isAlbumWithMoreThanOneImage()) {
        GalleryItem itemDetails = _vm.itemDetails[item.id];
        if (itemDetails != null) {
          int currentPos = _vm.albumIndex[item.id] ?? 0;
          title += " (${currentPos + 1}/${itemDetails.images.length})";
        }
      }
      return title;
    }
    return "";
  }

  PageView _pageView(BuildContext context) {
    return PageView.builder(
      pageSnapping: true,
      controller: PageController(),
      itemBuilder: (context, position) {
        GalleryItem currentItem = _vm.items[position];
        if (currentItem.isAlbum) {
          return AlbumPageContainer(
            item: currentItem,
            key: PageStorageKey(currentItem.id),
          );
        } else {
          return GalleryImagePage(
            currentItem,
            key: PageStorageKey(currentItem.id),
            controller: _vm.videoControllers[currentItem.id],
          );
        }
      },
      itemCount: _vm.items.length,
      onPageChanged: (it) => this._onPageChanged(context, it),
    );
  }
}
