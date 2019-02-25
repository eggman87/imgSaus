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
  static const IMGUR_USER_SUB_VIRAL = GalleryFilter(GallerySort.rising, GalleryWindow.day, 0, section: GallerySection.user);

  static const SUB_REDDITS = ["pics","gifs", "foodporn","reactiongifs", "funny", "oldschoolcool", "gaming", "holdmybeer",
  "aww", "outside", "historyporn", "videos", "mildlyinteresting", "animalsbeingjerks", "earthporn", "carporn", "perfecttiming",
  "roomporn", "tumblr", "techsupportgore", "itookapicture", "cringepics", "cringe" ];


  const GalleryFilter(this.sort, this.window, this.page, {this.section, this.tag, this.subRedditName});

  GalleryFilter copyWith({GallerySection section, GallerySort sort, GalleryWindow window, int page}) {
    return GalleryFilter(
      sort ?? this.sort,
      window ?? this.window,
      page ?? this.page,
    );
  }

  String subKey() {
    if (tag != null) {
      return GalleryTag.GALLERY_SUB_KEY;
    } else {
      return null;
    }
  }

  String title() {
    if (this.tag != null) {
      return this.tag.displayName;
    } else if (this.subRedditName != null) {
      return this.subRedditName;
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

    return "/gallery/$sectionString/$sortString/$windowString/$page?count=100";
  }

  static GalleryFilter fromSubredditName(String name) {
    return GalleryFilter(GallerySort.time, GalleryWindow.week, 0, subRedditName: name);
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