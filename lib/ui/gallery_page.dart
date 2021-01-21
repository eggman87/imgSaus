import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/data/analytics.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/gallery_item.dart';
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
  Offset _fabPosition = Offset(-1,40);
  final currentPageController = TextEditingController(text: "1");
  int jumpToIndex = -1;
  final pageController = PageController();
  final titleScrollController = ScrollController();


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

  void _changeFilter() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Filter"),
          content: Container(
            height: 120,
            width: 200,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("current page: "),
                    Expanded(child: TextFormField(keyboardType: TextInputType.number, controller: currentPageController), )
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Update"),
              onPressed: () {
                //jump to next page once we have loaded items.
                jumpToIndex = _vm.items.length + 1;
                StoreProvider.of<AppState>(context).dispatch(UpdateFilterAction(_vm.filter.copyWith(page: int.parse(currentPageController.text) - 1)));
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }

  void _fullScreen({bool shouldPop = false}) {
    if (shouldPop) {
      Navigator.pop(context);
    }

    var itemCurrentVisible = _vm.currentVisibleItem(_pagePosition);

    if (_vm.videoControllers[itemCurrentVisible.id] != null) {
      _vm.videoControllers[itemCurrentVisible.id].setVolume(100);
    }

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
      _shareCurrentImage(itemCurrentVisible);
  }

  void _shareCurrentImage(GalleryItem item) {
    var imageFile = ImageFileUtils();
    imageFile.writeImageToFile(item.imageUrl()).then((it) {
      ShareExtend.share(it.path, "file");
    });
  }

  GalleryItem _currentGalleryItem() {
    if (_vm.items.length > 0) {
      return _vm.items[_pagePosition];
    }
    return null;
  }

  void _onPageChanged(BuildContext context, int position) {
    if (position == _vm.items.length - 5) {
      _loadNextPage(context);
    }

    setState(() {
      titleScrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
      _pagePosition = position;
    });

  }

  //todo: maybe we should clear current items when jumping...
  void jumpToPageIfNecessary() {
    if (jumpToIndex > 0 && _vm.items.length > jumpToIndex) {
      setState(() {
        pageController.jumpToPage(jumpToIndex);
        _pagePosition = jumpToIndex;
        jumpToIndex = -1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _vm = widget.viewModel;

    jumpToPageIfNecessary();

    return Scaffold(
      appBar: AppBar(
        title: Text(_vm.isGalleryLoading ? 'loading' : _vm.filter.title() + " ${_vm.filter.page + 1}"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _changeFilter(),
          )
        ],
      ),
      body: _body()
    );
  }

  //todo refactor to widget to avoid perf hit.
  //todo refactor to widget to avoid perf hit.
  Widget _body() {
    if (_vm.isGalleryLoading && _vm.items.length == 0) {
      return Container(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      GalleryItem item = _currentGalleryItem();
      if (item == null) {
        return Container(
          color: Colors.black,
          padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          child: Center(
              child: Text(
            "Error loading gallery. imgur might be down or network connectivity might be limited.",
            style: TextStyle(color: Colors.white), textAlign: TextAlign.center,
          )),
        );
      }

      return Container(
          color: Colors.black,
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment(-1, -1),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: Container(
                            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .12),
                            child: SingleChildScrollView(
                              controller: titleScrollController,
                              child: Column(
                                children: [
                                  Text(
                                    _galleryItemTitle(item),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(height: 4),
                                  Text(_galleryItemDescription(item),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white))
                                ],
                              ))
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            format(item.dateCreated),
                            style: TextStyle(letterSpacing: 1.1, color: Colors.red),
                          ),
//                          Text(
//                            " | ${_pagePosition + 1}/${_vm.items.length}", style: TextStyle(color: Colors.red),
//                          )                          Text(
//                            " | ${_pagePosition + 1}/${_vm.items.length}", style: TextStyle(color: Colors.red),
//                          )
                        ],
                      ),
                    ],
                  )),
              Expanded(
                child: GestureDetector(
                  child: _pageWithCommentsFab(context),
                  onLongPress: _onLongPress,
                  onDoubleTap: _fullScreen,
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

  String _galleryItemTitle(GalleryItem item) {
    if (_vm.items.length > 0) {
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

  String _galleryItemDescription(GalleryItem item) {
    if (_vm.items.length > 0) {
      if (item.isAlbumWithMoreThanOneImage()) {
        GalleryItem itemDetails = _vm.itemDetails[item.id];
        if (itemDetails != null) {
          int currentPos = _vm.albumIndex[item.id] ?? 0;
          final albumImage = itemDetails.images[currentPos];
          if (albumImage != null && albumImage.description != null) {
            return albumImage.description;
          }
        }
      } else {
        if (item.description != null) {
          return item.description;
        }
      }
    }
    return "";
  }

  Widget _pageWithCommentsFab(BuildContext context) {
    if (_fabPosition.dx == -1) {
      //           final x = MediaQuery.of(context).size.width - details.offset.dx - 40;
      //                 final y = MediaQuery.of(context).size.height - details.offset.dy - 56;
      _fabPosition = Offset((MediaQuery.of(context).size.width / 2) - 30, 40);
    }

    return Stack(
      children: <Widget>[
        _pageView(context),
        _fabOrNothing()
      ],
    );
  }

  Widget _fabOrNothing() {
    if (_vm.filter.subRedditName != null) {
      return Container();
    }
    return Positioned(
      right: _fabPosition.dx,
      bottom: _fabPosition.dy,
      child: Draggable(
          feedback: FloatingActionButton(child: Icon(Icons.comment), onPressed: () {}),
          child: FloatingActionButton(child: Icon(Icons.comment), onPressed: () => this._onCommentsTapped(context)),
          childWhenDragging: Container(),
          onDragEnd: (details) {
            //40 and 56 are material constants, need to look for constants.
            final x = MediaQuery.of(context).size.width - details.offset.dx - 40;
            final y = MediaQuery.of(context).size.height - details.offset.dy - 56;

            if (x > 0 && y > 0) {
              setState(() {
                _fabPosition = Offset(x, y);
              });
            }
          }),
    );
  }

  PageView _pageView(BuildContext context) {
    return PageView.builder(
      pageSnapping: true,
      controller: pageController,
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
            shouldShowSoundIndicator: false,
            controller: _vm.videoControllers[currentItem.id],
          );
        }
      },
      itemCount: _vm.items.length,
      onPageChanged: (it) => this._onPageChanged(context, it),
    );
  }
  @override
  void dispose() {
    currentPageController.dispose();
    super.dispose();
  }
}
