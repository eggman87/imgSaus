import 'package:flutter/material.dart';
import 'package:imgsrc/comments_bottom_sheet.dart';
import 'package:imgsrc/gallery_album_page.dart';
import 'package:imgsrc/gallery_image_page.dart';
import 'package:imgsrc/gallery_repository.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/model/gallery_models.dart';
import 'package:flutter/foundation.dart';
import 'package:share_extend/share_extend.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //current state of gallery items.
  var _currentSection = GallerySection.hot;
  var _currentSort = GallerySort.viral;
  var _currentWindow = GalleryWindow.day;
  int _currentPage = 1;

  //the below `_current` properties refer to state of the current index of the PageView
  int _pagePosition = 0;
  List<GalleryItem> _galleryItems = new List<GalleryItem>();

  int currentAlbumPosition = 0;
  int currentAlbumLength = 3; //default length...

  //current visible item if current page is showing a album. The album widget
  //internally loads all images from api
  GalleryItem _currentAlbumVisibleItem;

  var _isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadGalleryItems();
  }

  void _loadGalleryItems() {
    setState(() {
      _isLoading = true;
    });
    var repository = new GalleryRepository();
    repository.getItems(_currentSection, _currentSort, _currentWindow, _currentPage).then((it) {
      setState(() {
        _isLoading = false;
        if (it.isOk()) {
          _galleryItems.addAll(it.body);
          _setupCurrentVisibleItemIfNecessary();
        }
      });
    });
  }

  void _loadNextPage() {
    _currentPage++;
    _loadGalleryItems();
  }

  @override
  Widget build(BuildContext context) {
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
                      visible: _galleryItems.length > 0,
                      child: Text("  Currently viewing ${_pagePosition + 1}/${_galleryItems.length}"))
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
                    style: _selectableStyle(_currentSection == GallerySection.hot),
                  ),
                  Spacer(),
                  Text(
                    "top",
                    style: _selectableStyle(_currentSection == GallerySection.top),
                  ),
                  Spacer(),
                  Text(
                    "User",
                    style: _selectableStyle(_currentSection == GallerySection.user),
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
      body:_body(),
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
    if (_isLoading) {
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
                    child: _pageView(),
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
    if (_galleryItems.length > 0) {
      GalleryItem item = _currentGalleryItem();
      String title = item.title;
      if (item.isAlbumWithMoreThanOneImage()) {
        title += " (${currentAlbumPosition + 1}/$currentAlbumLength)";
      }
      return title;
    }
    return "";
  }

  PageView _pageView() {
    return PageView.builder(
      pageSnapping: true,
      controller: PageController( ),
      itemBuilder: (context, position) {
        GalleryItem currentItem = _galleryItems[position];
        if (currentItem.isAlbum) {
          return GalleryAlbumPage(currentItem, _onAlbumCountChanged);
        } else {
          return GalleryImagePage(currentItem);
        }
      },
      itemCount: _galleryItems.length,
      onPageChanged: _onPageChanged,
    );
  }

  void _onCommentsTapped(BuildContext context) {
    GalleryItem currentItem = _currentGalleryItem();
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return CommentsSheet(
            galleryItemId: currentItem.id,
            key: Key(currentItem.id),
          );
        });
  }

  void _onLongPress() {
    _shareCurrentItem();
  }

  void _shareCurrentItem() {
    GalleryItem itemCurrentVisible = _galleryItems[_pagePosition];
    if (itemCurrentVisible.isAlbum) {
      itemCurrentVisible = _currentAlbumVisibleItem;
    }

    if (itemCurrentVisible.isVideo()) {
      ShareExtend.share("from imgSaus: ${itemCurrentVisible.title ?? _galleryItems[_pagePosition].title}: ${itemCurrentVisible.imageUrl()}", "text");
    }
  }

  void _onAlbumCountChanged(AlbumCount count) {
    setState(() {
      currentAlbumPosition = count.currentPosition;
      currentAlbumLength = count.totalCount;
      _currentAlbumVisibleItem = count.currentVisibleItem;
    });
  }

  GalleryItem _currentGalleryItem() {
    if (_galleryItems.length > 0) {
      return _galleryItems[_pagePosition];
    }
    return null;
  }

  void _onPageChanged(int position) {
    setState(() {
      _pagePosition = position;
      currentAlbumLength = _galleryItems[position].images.length;
      currentAlbumPosition = 0;
      _setupCurrentVisibleItemIfNecessary();
    });
    if (position == _galleryItems.length) {
      _loadNextPage();
    }
  }

  void _setupCurrentVisibleItemIfNecessary() {
    var newItem = _galleryItems[_pagePosition];

    //manually set this since we know it will be first up...
    if (newItem.isAlbum) {
      _currentAlbumVisibleItem = newItem.images[0];
    }
  }
}
