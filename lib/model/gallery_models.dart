

enum GallerySection {
    hot, top, user
}
enum GallerySort {
  viral, top, time, rising
}
enum GalleryWindow {
  day, week, month, year, all
}


//GallerySection section, GallerySort sort, GalleryWindow window, int page
class GalleryFilter {
  final GallerySection section;
  final GallerySort sort;
  final GalleryWindow window;
  final int page;

  const GalleryFilter(this.section, this.sort, this.window, this.page);

  GalleryFilter copyWith({GallerySection section, GallerySort sort, GalleryWindow window, int page}) {
    return GalleryFilter(
      section ?? this.section,
      sort ?? this.sort,
      window ?? this.window,
      page ?? this.page
    );
  }

  @override
  String toString() {
    return '{section=$section, sort=$sort, window=$window, page=$page}';
  }

  static const IMGUR_FRONT_PAGE = GalleryFilter(GallerySection.hot, GallerySort.viral, GalleryWindow.day, 0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GalleryFilter &&
              runtimeType == other.runtimeType &&
              section == other.section &&
              sort == other.sort &&
              window == other.window &&
              page == other.page;

  bool isSameGallery(GalleryFilter other) =>
              section == other.section &&
              sort == other.sort &&
              window == other.window;

  bool isSamePage(GalleryFilter other) =>
          page == other.page;

  @override
  int get hashCode =>
      section.hashCode ^
      sort.hashCode ^
      window.hashCode ^
      page.hashCode;

}