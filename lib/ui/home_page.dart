import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:flutter/foundation.dart';
import 'package:imgsrc/ui/comments_list_container.dart';
import 'package:imgsrc/ui/gallery_album_page.dart';
import 'package:imgsrc/ui/gallery_image_full_screen.dart';
import 'package:imgsrc/ui/gallery_image_page.dart';
import 'package:imgsrc/ui/home_page_container.dart';
import 'package:imgsrc/ui/image_file_utils.dart';
import 'package:share_extend/share_extend.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage(this.title, this.viewModel, {Key key}) : super(key: key);

  final String title;
  final HomeViewModel viewModel;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//state driven by UI interaction
  //the below `_current` properties refer to state of the current index of the PageView
  int _pagePosition = 0;
  int currentAlbumPosition = 0;
  int currentAlbumLength = 3; //default length...
  //current visible item if current page is showing a album. The album widget
  //internally loads all images from api
  GalleryItem _currentAlbumVisibleItem;

  var _isLoading = false;

  //view model driven by store.
  HomeViewModel _vm;

  _MyHomePageState();

  void _loadNextPage(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatch(UpdateFilterAction(_vm.filter.copyWith(page: _vm.filter.page + 1)));
  }

  @override
  Widget build(BuildContext context) {
    _vm = widget.viewModel;

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 120, 0),
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                child: Text("eggman87"),
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
                  Text("viral"),
                  Spacer(),
                  Text("top"),
                  Spacer(),
                  Text("time"),
                  Spacer(),
                  Text("rising"),
                  Spacer(),
                ],
              ),
            ],
          )),
      body: _body(),
      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
          onPressed: () => this._onCommentsTapped(context),
          tooltip: 'View Comments',
          child: Icon(Icons.message),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: new Icon(Icons.album), title: Text("Gallery")),
        BottomNavigationBarItem(icon: new Icon(Icons.photo), title: Text("My Saus")),
        BottomNavigationBarItem(icon: new Icon(Icons.person), title: Text("Social Saus"))
      ]),
    );
  }

  //todo refactor to widget to avoid perf hit.
  Widget _body() {
    if (_isLoading || _vm.items.length == 0) {
      return Container(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    _galleryItemTitle(),
                    maxLines: 6,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: _pageView(context),
                    onLongPress: _onLongPress,
                  ),
                ),
              ],
            ),
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
        title += " (${currentAlbumPosition + 1}/$currentAlbumLength)";
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
          return GalleryAlbumPage(currentItem, _onAlbumCountChanged);
        } else {
          return GalleryImagePage(currentItem);
        }
      },
      itemCount: _vm.items.length,
      onPageChanged: (it) => this._onPageChanged(context, it),
    );
  }

  void _onCommentsTapped(BuildContext context) {
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
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.fullscreen), title: new Text('Fullscreen (zoomable)'), onTap: _fullScreen),
                new ListTile(
                  leading: new Icon(Icons.share),
                  title: new Text('Share'),
                  onTap: _shareCurrentItem,
                ),
              ],
            ),
          );
        });
  }

  void _fullScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GalleryImageFullScreen(item: _vm.items[_pagePosition])),
    );
  }

  void _shareCurrentItem() {
    GalleryItem itemCurrentVisible = _vm.items[_pagePosition];
    if (itemCurrentVisible.isAlbum) {
      itemCurrentVisible = _currentAlbumVisibleItem;
    }

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

  void _onAlbumCountChanged(AlbumCount count) {
    setState(() {
      currentAlbumPosition = count.currentPosition;
      currentAlbumLength = count.totalCount;
      _currentAlbumVisibleItem = count.currentVisibleItem;
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
      _setupCurrentVisibleItemIfNecessary(position);
    });

    if (position == _vm.items.length - 1) {
      _loadNextPage(context);
    }
  }

  void _setupCurrentVisibleItemIfNecessary(int position) {
    var newItem = _vm.items[position];

    //albums widget makes api call to load all images, lets start in the known state though.
    if (newItem.isAlbum) {
      currentAlbumPosition = 0;
      currentAlbumLength = newItem.imagesCount;
      _currentAlbumVisibleItem = newItem.images[0];
    }
  }
}
