import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mw/functions/globals.dart';
import 'package:mw/helpers/db_helper.dart';
import 'package:mw/models/member_model.dart';
import 'package:mw/strings/strings.dart';
import 'package:mw/widgets/birthday_list.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DashBoardScreen extends StatefulWidget {

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<List<Member>> totalMembers;
  Future<List<Member>> totalActiveMembers;
  Future<List<Member>> totalPremiumMembers;
  Future<List<Member>> members;
  List<int> totalBarangayActiveMembers;
  List<int> totalBarangayExpiredMembers;
  int _totalMembers;
  int _totalActiveMembers;
  int _totalPremiumMembers;
  int _totalExpiredMembers;
  bool _isBarangayStatisticsCollapsed = true;
  bool isProcessBarangayCountDone = false;
  var dBHelper = DbHelper();

  double activePercentValue;
  double activeMembersToPercent(int active, int total) {
    return (active / total) * 100;
  }

  double expiredPercentValue;
  double expiredMembersToPercent(int expired, int total) {
    return (expired / total) * 100;
  }

  double premiumPercentValue;
  double premiumMembersToPercent(int premium, int total) {
    return (premium / total) * 100;
  }

  double regularPercentValue;
  double regularMembersToPercent(int regular, int total) {
    return (regular / total) * 100;
  }

  int regularMembers;
  int getRegularMembers(int total, int premium) {
    int result = total - premium;
    return result;
  }

  @override
  void initState() {
    processBarangayCount();
    super.initState();
    setState(() {
      totalMembers = dBHelper.getDatabaseData("SELECT * FROM tblmembers WHERE tblmembers.deceased IS NULL");
      totalActiveMembers = dBHelper.getDatabaseData("SELECT CASE WHEN DATE(substr(tblmembers.lastrenewal,7,4)||'-'||substr(tblmembers.lastrenewal,1,2)||'-'||substr(tblmembers.lastrenewal,4,2), '+1 year') <= date('now','start of month','+1 month','-1 day') THEN 'EXPIRED' ELSE 'ACTIVE' END AS Status FROM tblmembers WHERE Status='ACTIVE' AND deceased IS NULL");
      totalPremiumMembers = dBHelper.getDatabaseData("SELECT tblmembers.mid, tblbenefits.insurancestatus, CASE WHEN DATE(substr(tblmembers.lastrenewal,7,4)||'-'||substr(tblmembers.lastrenewal,1,2)||'-'||substr(tblmembers.lastrenewal,4,2), '+1 year') <= date('now','start of month','+1 month','-1 day') THEN 'EXPIRED' ELSE 'ACTIVE' END AS Status FROM tblmembers LEFT JOIN tblbenefits ON tblmembers.mid=tblbenefits.mid WHERE Status='ACTIVE' AND tblbenefits.insurancestatus = 'PREMIUM' AND tblmembers.deceased IS NULL");
      totalMembers.then((value) => _totalMembers = value.length);
      totalActiveMembers.then((value) => _totalActiveMembers = value.length);
      totalPremiumMembers.then((value) => _totalPremiumMembers = value.length);
      members = dBHelper.birthday();
    });
  }

  void processBarangayCount() async {
    totalBarangayActiveMembers = await getActiveBarangayInfo('ACTIVE', barangay);
    totalBarangayExpiredMembers = await getExpiredBarangayInfo('EXPIRED', barangay);
    setState(() {
      isProcessBarangayCountDone = true;
    });
  }

  Future<List<int>> getActiveBarangayInfo(String status, List<String> brgy) async {
    List<int> list = <int>[];
    for(var i = 0; i < brgy.length; i++) {
      await dBHelper.getBarangayData(status, brgy[i]).then((value) {
        list.add(value.length);
      });
    }
    return list;
  }

  Future<List<int>> getExpiredBarangayInfo(String status, List<String> brgy) async {
    List<int> list = <int>[];
    for(var i = 0; i < brgy.length; i++) {
      await dBHelper.getBarangayData(status, brgy[i]).then((value) {
        list.add(value.length);
      });
    }
    return list;
  }

  Widget getBarangayWidgets(List<String> brgy, List<int> active, List<int> expired) {
    List<Widget> list = <Widget>[];
    for(var i = 0; i < brgy.length; i++){
      int total = active[i] + expired[i];
      double activePercent = (active[i] / total) * 100;
      double expiredPercent = (expired[i] / total) * 100;
      list.add(Column(
        children: [
          Table(columnWidths: {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(5),
          },
            children: [
              TableRow(
                children: [
                  Text(brgy[i], overflow: TextOverflow.ellipsis,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearPercentIndicator(
                        padding: EdgeInsets.all(0.0),
                        animation: true,
                        lineHeight: 20.0,
                        animationDuration: 1000,
                        percent: activePercent * .01,
                        center: Text('${active[i]} / ${activePercent.round()}%',
                          style: customTextStyle(
                            color: appBackgroundColorPrimary,
                          ),
                        ),
                        linearStrokeCap: LinearStrokeCap.butt,
                        progressColor: Colors.green,
                      ),
                      SizedBox(height: 2.0,),
                      LinearPercentIndicator(
                        padding: EdgeInsets.all(0.0),
                        animation: true,
                        lineHeight: 20.0,
                        animationDuration: 1000,
                        percent: expiredPercent * .01,
                        center: Text('${expired[i]} / ${expiredPercent.round()}%',
                          style: customTextStyle(
                            color: appBackgroundColorPrimary,
                          ),
                        ),
                        linearStrokeCap: LinearStrokeCap.butt,
                        progressColor: Colors.red,
                      ),
                      SizedBox(height: 10.0,),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Container(
            width: double.infinity,
            color: appColorPrimary,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Barangay Statistics',
                    style: customTextStyle(
                      fontFamily: 'AllerBold',
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                  IconButton(
                      icon: _isBarangayStatisticsCollapsed ? Icon(Icons.arrow_drop_up_sharp) : Icon(Icons.arrow_drop_down_circle),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _isBarangayStatisticsCollapsed = !_isBarangayStatisticsCollapsed;
                          print(_isBarangayStatisticsCollapsed);
                        });
                      }
                  )
                ],
              ),
            ),
          ),
          _isBarangayStatisticsCollapsed ? Container(
            padding: EdgeInsets.all(10.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: appBackgroundColorSecondary,
              border: Border.all(
                color: Colors.grey,
                width: .25,
              ),
            ),
            child: Column(
              children: list,
            ),
          ) : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget getBarangayTableWidget(List<String> brgy, List<int> active, List<int> expired) {
    List<Widget> list = <Widget>[];
    for(var i = 0; i < brgy.length; i++){
      int total = active[i] + expired[i];
      double activePercent = (active[i] / total) * 100;
      double expiredPercent = (expired[i] / total) * 100;
      list.add(Table(
        border: TableBorder(
            verticalInside: BorderSide(
                width: 0.35,
                color: Colors.grey.withOpacity(0.35),
                style: BorderStyle.solid,
            ),
            horizontalInside: BorderSide(
              width: 0.35,
              color: Colors.grey.withOpacity(0.35),
              style: BorderStyle.solid,
            )
        ),
        columnWidths: {
        0: FlexColumnWidth(1.75),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
        children: [
          i == 0 ? TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Text('BARANGAY',
                  style: customTextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontFamily: appFontBold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Text('ACTIVE',
                    style: customTextStyle(
                      fontFamily: appFontBold,
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Text('EXPIRED',
                    style: customTextStyle(
                      fontFamily: appFontBold,
                    )
                ),
              ),
            ],
          ) : TableRow(
            children: [
              SizedBox.shrink(),
              SizedBox.shrink(),
              SizedBox.shrink(),
            ]
          ),
          TableRow(
            decoration: BoxDecoration(
              color: i.isEven ? Colors.grey.withOpacity(0.15) : Colors.transparent,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                child: Text(brgy[i], overflow: TextOverflow.ellipsis,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                child: Text('${active[i]} / ${activePercent.round()}%',),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                child: Text('${expired[i]} / ${expiredPercent.round()}%',),
              ),
            ],
          ),
        ],
      ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Container(
            width: double.infinity,
            color: appColorPrimary,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Barangay Statistics',
                    style: customTextStyle(
                      fontFamily: 'AllerBold',
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                  IconButton(
                      icon: _isBarangayStatisticsCollapsed ? Icon(Icons.arrow_drop_up_sharp) : Icon(Icons.arrow_drop_down_circle),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _isBarangayStatisticsCollapsed = !_isBarangayStatisticsCollapsed;
                          print(_isBarangayStatisticsCollapsed);
                        });
                      }
                  )
                ],
              ),
            ),
          ),
          _isBarangayStatisticsCollapsed ? Container(
            padding: EdgeInsets.all(10.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: appBackgroundColorSecondary,
              border: Border.all(
                color: Colors.grey,
                width: .25,
              ),
            ),
            child: Column(
              children: list,
            ),
          ) : SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(_totalMembers != null) {//_totalMembers != null
      activePercentValue = activeMembersToPercent(_totalActiveMembers, _totalMembers);
      expiredPercentValue = expiredMembersToPercent(_totalMembers - _totalActiveMembers, _totalMembers);
      premiumPercentValue = premiumMembersToPercent(_totalPremiumMembers, _totalMembers);
      regularPercentValue = regularMembersToPercent(_totalMembers - _totalPremiumMembers, _totalMembers);
      regularMembers = getRegularMembers(_totalActiveMembers, _totalPremiumMembers);
      _totalExpiredMembers = _totalMembers - _totalActiveMembers;
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BirthdayList(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                  width: double.infinity,
                  color: appColorPrimary,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Statistics',
                      style: customTextStyle(
                        fontFamily: 'AllerBold',
                        color: Colors.white,
                        fontSize: 21.0,
                      ),
                    ),
                  ),
                ),
            ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //--------------------
                    Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: appBackgroundColorSecondary,
                        border: Border.all(
                          color: Colors.grey,
                          width: .25,
                        ),
                      ),
                      child: CircularPercentIndicator(
                        radius: MediaQuery.of(context).size.width / 2 - 60,
                        lineWidth: MediaQuery.of(context).size.width / 15,
                        animation: true,
                        percent: activePercentValue * .01,
                        center: Text('${activePercentValue.round()}%',
                          style: customTextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        header: Column(
                          children: [
                            Text('Active Members',
                              style: customTextStyle(
                                color: appFontColorSecondary,
                                fontSize: 13.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                          ],
                        ),
                        circularStrokeCap: CircularStrokeCap.butt,
                        progressColor: Colors.green,
                      ),
                    ),
                    //----------------------
                    Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: appBackgroundColorSecondary,
                        border: Border.all(
                          color: Colors.grey,
                          width: .25,
                        ),
                      ),
                      child: CircularPercentIndicator(
                        radius: MediaQuery.of(context).size.width / 2 - 60,
                        lineWidth: MediaQuery.of(context).size.width / 15,
                        animation: true,
                        percent: expiredPercentValue * .01,
                        center: Text('${expiredPercentValue.round()}%',
                          style: customTextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        header: Column(
                          children: [
                            Text('Expired Members',
                              style: customTextStyle(
                                color: appFontColorSecondary,
                                fontSize: 13.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                          ],
                        ),
                        circularStrokeCap: CircularStrokeCap.butt,
                        progressColor: Colors.red,
                      ),
                    ),
                    //----------------------,
                  ],
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: appColorPrimary,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Members',
                            style: customTextStyle(
                              fontFamily: 'AllerBold',
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: appBackgroundColorSecondary,
                          border: Border.all(
                            color: Colors.grey,
                            width: .25,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Active Members'),
                                  Text('$_totalActiveMembers',
                                    style: customTextStyle(
                                      fontFamily: 'AllerBold',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Expired Members'),
                                  Text('$_totalExpiredMembers',
                                    style: customTextStyle(
                                      fontFamily: 'AllerBold',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0,),
                              Divider(),
                              SizedBox(height: 5.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('TOTAL'),
                                  Text('$_totalMembers',
                                    style: customTextStyle(
                                      fontFamily: 'AllerBold',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //---------------------------
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: appColorPrimary,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Active Member Types',
                            style: customTextStyle(
                              fontFamily: 'AllerBold',
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: appBackgroundColorSecondary,
                          border: Border.all(
                            color: Colors.grey,
                            width: .25,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Premium Members'),
                                  Text('$_totalPremiumMembers',
                                    style: customTextStyle(
                                      fontFamily: 'AllerBold',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0),
                              LinearPercentIndicator(
                                padding: EdgeInsets.all(0.0),
                                animation: true,
                                lineHeight: 20.0,
                                animationDuration: 1000,
                                percent: premiumPercentValue * .01,
                                center: Text('${premiumPercentValue.round()}%',
                                  style: customTextStyle(
                                    color: appBackgroundColorPrimary,
                                  ),
                                ),
                                linearStrokeCap: LinearStrokeCap.butt,
                                progressColor: Colors.amber,
                              ),
                              //---------------------------
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Regular Members'),
                                  Text('$regularMembers',
                                    style: customTextStyle(
                                      fontFamily: 'AllerBold',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0),
                              LinearPercentIndicator(
                                padding: EdgeInsets.all(0.0),
                                animation: true,
                                lineHeight: 20.0,
                                animationDuration: 1000,
                                percent: regularPercentValue * .01,
                                center: Text('${regularPercentValue.round()}%',
                                  style: customTextStyle(
                                    color: appBackgroundColorPrimary,
                                  ),
                                ),
                                linearStrokeCap: LinearStrokeCap.butt,
                                progressColor: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(height: 10.0),
                      // Text('*Statistics are based on currently uploaded database to the server.'),
                    ],
                  ),
                ),
                //---------------------------
              ],
            ),
            //```````````````````````````````````````````````````````````````````````
/*            isProcessBarangayCountDone ? getBarangayWidgets(barangay, totalBarangayActiveMembers, totalBarangayExpiredMembers) : Center(
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary)),
                ],
              ),
            ),*/
            isProcessBarangayCountDone ? getBarangayTableWidget(barangay, totalBarangayActiveMembers, totalBarangayExpiredMembers) : Center(
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Center(
      child: Container(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary)),
        height: 50.0,
        width: 50.0,
      ),
    );
  }
}
