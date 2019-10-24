import 'package:flutter/material.dart';
import 'package:skymobile/HelperUtilities/globalVariables.dart';
import 'package:skymobile/HelperUtilities/settingsWidgetGenerator.dart';
import 'package:skymobile/HelperUtilities/themeColorManager.dart';
import 'supportUtils.dart';

class GPACalculatorSettings extends StatefulWidget {
  GPACalculatorSettings({Key key}) : super(key: key);

  @override
  _GPACalculatorSettingsState createState() => _GPACalculatorSettingsState();
}

class _GPACalculatorSettingsState extends State<GPACalculatorSettings> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Container(
          child: Text(
            'Tick or change the settings depending on your district or college. Read descriptions carefully verify that the settings are correct.',
            style: TextStyle(color: themeManager.getColor(TypeOfWidget.text), fontSize: 20),
          ),padding: EdgeInsets.only(left: 20, right: 20, top: 10))
    ];
    for (String k in extraGPASettings.keys) {
      if(extraGPASettings[k]['option'] is Map){
        widgets.add(SettingsWidgetGenerator.generateListSettingsWidget(k, extraGPASettings[k], run: () {
          setState(() {
            saveExtraGPASettings();
          });
        }));
      } else {
        widgets.add(SettingsWidgetGenerator.generateSingleSettingsWidget(
            k, extraGPASettings[k], run: () {
              saveExtraGPASettings();
        }));
      }
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: themeManager.getColor(TypeOfWidget.text), size: 30),
          backgroundColor: themeManager.getColor(TypeOfWidget.background),
          title: Align(alignment: Alignment.centerLeft, child: Text('4.0 Scale Settings',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: themeManager.getColor(TypeOfWidget.text),
                  fontSize: 30,
                  fontWeight: FontWeight.w700)),
        ),),
        backgroundColor: Colors.black,
        body: Center(
          child: ListView(children: widgets),
        ));
  }
  //Widget _generateSettingsClickable(String setting, )
}
