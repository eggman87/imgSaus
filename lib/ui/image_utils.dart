class ImageUtils {

  static final imageExtensions = [
    ".jpg",
    ".png",
    ".gif",
    ".jpeg",
    ".svg",
    ".webp"
  ];

  static final imageMovieExtensions =  [
    ".gifv",
    ".mp4",
  ];


  static bool isUrlImage(String imageUrl) {
    String url = imageUrl.toLowerCase();

    for (var ext in imageExtensions) {
      if (url.contains(ext)) {
        //todo: need a better solution here.
        if (ext == ".gif" && url.contains(".gifv")) {
          continue;
        }
        return true;
      }
    }
    return false;
  }

  static bool isUrlImageOrMovie(String imageUrl) {
    String url = imageUrl.toLowerCase();

    final extensions = List<String>.from(imageExtensions);
    extensions.addAll(imageMovieExtensions);

    for (var ext in extensions) {
      if (url.contains(ext)) {
        return true;
      }
    }
    return false;
  }

  static List<String> getImageUrlsFromString(String stringToInspect) {
    final urls = List<String>();
    for (String match in urlFinder.allMatches(stringToInspect).map((m) => m.group(0))) {
      if (isUrlImage(match)) {
        urls.add(match);
      }
    }
    return urls;
  }

  static final urlFinder = RegExp(
      r"(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-&?=%.]+",
      caseSensitive: false, multiLine: true
  );
}