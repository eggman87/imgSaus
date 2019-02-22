import 'package:imgsrc/model/gallery_tag.dart';

class GalleryFilter {

  final GallerySection section;
  final GallerySort sort;
  final GalleryWindow window;
  final GalleryTag tag;
  final String subRedditName;
  final int page;

  static const IMGUR_FRONT_PAGE = GalleryFilter(GallerySort.viral, GalleryWindow.day, 0, section: GallerySection.hot);
  static const IMGUR_TOP_MONTH = GalleryFilter(GallerySort.viral, GalleryWindow.month, 0, section: GallerySection.top);
  static const IMGUR_USER_SUB_NEW = GalleryFilter(GallerySort.time, GalleryWindow.day, 0, section: GallerySection.user);
  static const IMGUR_USER_SUB_VIRAL = GalleryFilter(GallerySort.viral, GalleryWindow.day, 0, section: GallerySection.user);

  const GalleryFilter(this.sort, this.window, this.page, {this.section, this.tag, this.subRedditName});

  GalleryFilter copyWith({GallerySection section, GallerySort sort, GalleryWindow window, int page}) {
    return GalleryFilter(
      sort ?? this.sort,
      window ?? this.window,
      page ?? this.page,
    );
  }

  bool hasSubKey() {
    return this.tag != null;
  }

  String subKey() {
    if (tag != null) {
      return 'items';
    } else {
      return '';
    }
  }

  String title() {
    if (this.tag != null) {
      return this.tag.displayName;
    } else if (section != null) {
      return "Front Page";
    } else {
      return "";
    }
  }

  @override
  String toString() {
    return '{section=$section, sort=$sort, window=$window, page=$page}';
  }

  String toApiUrl() {
    String sectionString;
    if (tag != null) {
      sectionString = 't/${tag.name}';
    } else if (subRedditName != null) {
      sectionString = 'r/$subRedditName';
    } else {
      sectionString = section.toString().split('.').last;
    }

    String sortString = sort.toString().split('.').last;
    String windowString = window.toString().split('.').last;

    return "https://api.imgur.com/3/gallery/$sectionString/$sortString/$windowString/$page?count=100";
  }
}

enum GallerySection {
  hot, top, user
}
enum GallerySort {
  viral, top, time, rising
}
enum GalleryWindow {
  day, week, month, year, all
}