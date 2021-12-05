import 'package:shared_preferences/shared_preferences.dart';

class PrefsUtils {
  PrefsUtils._();

  static late SharedPreferences preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static Future setSelectedList( List<String> value) {
    return preferences.setStringList('selected', value);
  }

  static List<String> getSelectedList() {
    return preferences.getStringList('selected') ?? ['USD', 'EUR', 'RUB' ];
  }

  static Future setSortList( List<String> value) {
    return preferences.setStringList('sort', value);
  }

  static List<String> getSortList() {
    return preferences.getStringList('sort') ?? [];
  }
}
