import 'package:skymobile/HelperUtilities/json_saver.dart';

class SkyVars {
  static JSONSaver skyVarsJsonSaver =
      JSONSaver(FilesAvailable.consoleOnlyVariables);

  static final Map<String, String> skyVarsDefault = {
    'version': '2',
    'permdev': 'false',
    'iconchangesupport' : 'false',
    'developeraccounts' : 'false'
  };

  static Map<String, String> skyVars = {
    'version': '2',
    'permdev': 'false',
    'iconchangesupport' : 'false',
    'developeraccounts' : 'false'
  };

  static saveVars() async {
    await skyVarsJsonSaver.saveListData(skyVars);
  }

  static getVars() async {
    var retriev = await skyVarsJsonSaver.readListData();
    if (!(retriev is int)) {
      skyVars = Map.from(retriev);
    } else {
      saveVars();
    }
  }

  static bool modifyVar(String a, dynamic b) {
    if (skyVars.containsKey(a)) {
      skyVars[a] = b.toString();
      saveVars();
      return true;
    } else {
      return false;
    }
  }

  static dynamic getVar(String a) {
    String got = skyVars[a];
    if (got == 'true' || got == 'false') {
      return got == 'true';
    } else if (int.tryParse(got) != null) {
      return int.parse(got);
    } else {
      return got;
    }
  }
}
