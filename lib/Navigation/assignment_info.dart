import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:skymobile/SupportWidgets/biometric_blur_view.dart';
import 'package:skymobile/Settings/theme_color_manager.dart';
import 'package:skyscrapeapi/data_types.dart';
import 'package:skymobile/HelperUtilities/global.dart';

class AssignmentInfoViewer extends StatefulWidget {
  final String courseName;

  AssignmentInfoViewer({this.courseName});
  @override
  _AssignmentInfoViewerState createState() =>
      new _AssignmentInfoViewerState(courseName);
}

class _AssignmentInfoViewerState extends BiometricBlur<AssignmentInfoViewer> {
  String courseName;

  _AssignmentInfoViewerState(this.courseName);

  @override
  Widget generateBody(BuildContext context) {
    if (shouldBlur)
      return Scaffold(
        backgroundColor: themeManager.getColor(TypeOfWidget.background),
      );
    List<Widget> body = [];
    for (AssignmentInfoBox box in assignmentInfoBoxes) {
      String uiMessage = box.getUIMessage();
      body.add(Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: themeManager.getColor(TypeOfWidget.subBackground),
        child: Container(
          alignment: Alignment.centerLeft,
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 6 * 4.4),
          padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
          child: Text(
            uiMessage,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: themeManager.getColor(TypeOfWidget.text), fontSize: 20),
            textAlign: TextAlign.start,
          ),
        ),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: themeManager.getColor(TypeOfWidget.text), size: 30),
        backgroundColor: themeManager.getColor(TypeOfWidget.background),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(courseName != null ? courseName : 'Assignments',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: themeManager.getColor(TypeOfWidget.text),
                  fontSize: 30,
                  fontWeight: FontWeight.w700)),
        ),
      ),
      backgroundColor: themeManager.getColor(TypeOfWidget.background),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: body,
        ),
      ),
    );
  }
}
