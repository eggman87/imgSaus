class GalleryFilter {

  final GallerySection section;
  final GallerySort sort;
  final GalleryWindow window;
  final String tagName;
  final String subRedditName;
  final int page;

  static const IMGUR_FRONT_PAGE = GalleryFilter(GallerySort.viral, GalleryWindow.day, 0, section: GallerySection.hot);

  const GalleryFilter(this.sort, this.window, this.page, {this.section, this.tagName, this.subRedditName});

  GalleryFilter copyWith({GallerySection section, GallerySort sort, GalleryWindow window, int page}) {
    return GalleryFilter(
      sort ?? this.sort,
      window ?? this.window,
      page ?? this.page,
    );
  }

  bool hasSubKey() {
    return this.tagName != null;
  }

  String subKey() {
    if (tagName != null) {
      return 'items';
    } else {
      return '';
    }
  }

  String title() {
    if (this.tagName != null) {
      return this.tagName;
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
    if (tagName != null) {
      sectionString = 't/$tagName';
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