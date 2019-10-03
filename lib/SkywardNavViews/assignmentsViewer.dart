import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:skyscrapeapi/SkywardAPITypes.dart';
import 'package:skyscrapeapi/SkywardAPICore.dart';
import 'package:skymobile/SkyMobileHelperUtilities/globalVariables.dart';
import 'package:skymobile/SkyMobileHelperUtilities/customDialogOptions.dart';

class AssignmentsViewer extends StatefulWidget {
  MaterialColor secondColor;
  String courseName;

  AssignmentsViewer({this.secondColor, this.courseName});
  @override
  _AssignmentsViewerState createState() => new _AssignmentsViewerState(courseName);
}

class _AssignmentsViewerState extends State<AssignmentsViewer> {
  String courseName;

  _AssignmentsViewerState(this.courseName);

  _goToAssignmentInfo(Assignment box) async{
    if(box.assignmentID != null) {
      bool isCancelled = false;
      var dialog = HuntyDialogLoading('Cancel', () {
        isCancelled = true;
      }, title: 'Loading', description: ('Getting your grades..'));

      showDialog(
          context: context,
          builder: (BuildContext context) => dialog).then((val) {
        isCancelled = true;
      });

      var result = await skywardAPI.getAssignmentInfoFromAssignment(box);
      if(result.runtimeType == SkywardAPIErrorCodes){
        Navigator.of(context).pop(dialog);
        String errMsg;
        switch(result){
          case(SkywardAPIErrorCodes.AssignmentInfoParseFailed):
            errMsg = 'Failed to get grades. Contact the developer, something is wrong with the Parser.';
            break;
          case(SkywardAPIErrorCodes.AssignmentInfoScrapeFailed):
            errMsg = 'Failed to scrape grades, this is an unusual error. Try logging out and back in.';
            break;
          case(SkywardAPIErrorCodes.CouldNotRefresh):
            errMsg = 'Failed to log back into your account. Try to log back in.';
            break;
          default:
            errMsg = 'An unknown error has occured. Contact the developer with this information ${result.toString()}';
            break;
        }
        showDialog(context: context,builder: (buildContext) {
          return HuntyDialog(title: 'Uh Oh', description: errMsg, buttonText: 'Ok');
        });
        isCancelled = true;
      }else{
        assignmentInfoBoxes = result;
      }

      if (!isCancelled) {
        Navigator.of(context, rootNavigator: true).popUntil((result) {
          return result.settings.name == '/assignmentsviewer';
        });
        Navigator.pushNamed(context, '/assignmentsinfoviewer');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    List<Widget> body = [];
    for(AssignmentsGridBox box in assignmentsGridBoxes){
      bool isBoxCatHeader = box is CategoryHeader;
      String grade = isBoxCatHeader ? (box as CategoryHeader).getDecimal() : (box as Assignment).getDecimal();
      bool secondContNeeded = (isBoxCatHeader && (box as CategoryHeader).weight != null);

      body.add(Card(
        child: InkWell(
            onTap: (){
              if(box != null && box is Assignment)
                _goToAssignmentInfo(box);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width / 6 * 4.4),
                        padding: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: secondContNeeded ? 0 : 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          isBoxCatHeader ? (box as CategoryHeader).catName : (box as Assignment).assignmentName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: isBoxCatHeader ? secondContNeeded ? Colors.orange[400] : Colors.lightBlueAccent : Colors.white, fontSize: isBoxCatHeader ? 20 : 15),
                          textAlign: TextAlign.start,
                        ),
                      ),
                secondContNeeded ? Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 6 * 4.3),
                        padding: EdgeInsets.only(
                            top: 5, left: 10, right: 10, bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text((box as CategoryHeader).weight,
                            style: TextStyle(color: Colors.orange[400], fontSize: 15),
                            textAlign: TextAlign.start),
                      ) : Container(height: 0,),
                    ],
                  ),
                ) ,
                Container(
                  constraints: BoxConstraints(minHeight: 60),
                  padding: EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    grade == null ? "" : grade,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: getColorFrom(grade)),
                  ),
                ),
              ],
            )),
        color: Colors.white12,
      ));
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(courseName != null ? courseName : 'Assignments',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w700)),
          actions: <Widget>[
            Theme(
                data: Theme.of(context).copyWith(
                  cardColor: Colors.black87,
                ),
                child: PopupMenuButton(

                  itemBuilder: (_) => <PopupMenuItem<String>>[
                    PopupMenuItem<String>(
                        child: const Text('Mock Assignment Editing Mode', style: TextStyle(color: Colors.white),), value: 'mockAssignmentEditingMode'),
                    PopupMenuItem<String>(
                        child: const Text('Grade Predictor', style: TextStyle(color: Colors.white),), value: 'gradePredictor'),
                  ],
                ))
          ],
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: ListView(
            padding: EdgeInsets.all(10),
            children: body,
          ),
        ),
    );
  }
}