

class ModelUtils {
  static DateTime dateFromJson(int ms) {
    var time =  new DateTime.fromMillisecondsSinceEpoch(ms * 1000);
    return time;
  }
}