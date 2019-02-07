

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
}

