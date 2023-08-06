import 'package:shared_preferences/shared_preferences.dart';

class LocaleStorage {
  SharedPreferences? _prefs;
  final Future<SharedPreferences> Function() _getInstance;

  LocaleStorage([this._getInstance = SharedPreferences.getInstance]) {
    _getInstance().then((value) => _prefs = value);
  }

  void setRestaurantAsFav({required String restaurantId}) {
    if (_prefs?.containsKey("favList") ?? false) {
      var list = _prefs?.getStringList("favList");
      list?.add(restaurantId);
      _prefs?.setStringList("favList", list ?? []);
    } else {
      _prefs?.setStringList("favList", [restaurantId]);
    }
  }

  void removeRestaurantAsFav({required String restaurantId}) {
    if (_prefs?.containsKey("favList") ?? false) {
      var list = _prefs?.getStringList("favList");
      list?.remove(restaurantId);
      _prefs?.setStringList("favList", list ?? []);
    }
  }

  List<String> getFavRestaurants() {
    return _prefs?.getStringList("favList") ?? [];
  }
}
