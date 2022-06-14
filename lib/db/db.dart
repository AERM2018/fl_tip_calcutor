import 'package:shared_preferences/shared_preferences.dart';

class DB {
  saveTipSetting(double tipPercentage) async {
    final prefers = await SharedPreferences.getInstance();
    prefers.setDouble('tip_percentage', tipPercentage);
  }

  getTipSetting() async {
    final prefers = await SharedPreferences.getInstance();
    return prefers.getDouble('tip_percentage');
  }
}
