import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mw/functions/globals.dart';
import 'package:mw/helpers/db_helper.dart';
import 'package:mw/models/member_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberScreen extends StatefulWidget {
  final String mid;

  const MemberScreen({Key key, this.mid}) : super(key: key);

  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  Future<List<Member>> members;
  var dBHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    members = dBHelper.searchmId(widget.mid);
    print(widget.mid);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Member Info',
          style: customTextStyle(fontFamily: appFontBold, color: Colors.white, fontSize: 18),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Theme.of(context).primaryColor,
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: FutureBuilder(
                  future: members,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Member> members = snapshot.data;
                      print(members.length);
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          if (snapshot.hasData) {
                            String spousename;
                            spousename = members[index].spousename != null && members[index].spousename != '' ? 'MARRIED to ${members[index].spousename}' : 'MARRIED';
                            return Column(
                              children: [
                                SizedBox(height: 10.0),
                                usertype == 'admin' ? CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: 'https://drv.tw/~mwwinapp@gmail.com/gd/Fast.io/mwapp.imfast.io/images/photo/${members[index].mid}.jpg',
                                  imageBuilder: (context, imageProvider) => Container(
                                    width: 200.0,
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.person, color: Colors.grey, size: 200.0,),
                                ) : Icon(Icons.person, color: Colors.grey, size: 200.0,),
                                SizedBox(height: 10.0),
                                Padding(
                                  padding:
                                  EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10.0),
                                      Text(
                                        '${members[index].fullname}',
                                        style: customTextStyle(
                                            fontSize: 20.0,
                                            fontFamily: appFontBold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.brightness_1,
                                            size: 10.0,
                                            color: members[index].status == 'ACTIVE' ? Colors.green : Colors.red,
                                          ),
                                          Text(
                                            '  ${members[index].status} MEMBER',
                                            style: customTextStyle(
                                                color: appFontColorSecondary,
                                                fontSize: 12.0,
                                                fontFamily: appFont),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      Divider(),
                                      //1----------------------------------------------------------------------------------------------------------
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'Member Type',
                                            style: customTextStyle(
                                                color: appFontColorSecondary,
                                                fontSize: 14.0,
                                                fontFamily: appFont),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Validity',
                                            style: customTextStyle(
                                                color: appFontColorSecondary,
                                                fontSize: 14.0,
                                                fontFamily: appFont),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            '${members[index].insurancestatus}',
                                            style: customTextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: appFont),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '  ${members[index].validity}',
                                            style: customTextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: appFont),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      //2----------------------------------------------------------------------------------------------------------
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Id Number ',
                                            style: customTextStyle(
                                                color: appFontColorSecondary,
                                                fontSize: 14.0,
                                                fontFamily: appFont),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${members[index].mid}',
                                            style: customTextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: appFont),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5.0),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person_outline,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Id ',
                                            style: customTextStyle(
                                                color: appFontColorSecondary,
                                                fontSize: 14.0,
                                                fontFamily: appFont),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${members[index].mwkit}',
                                            style: customTextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: appFont),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5.0),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.date_range,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Joined ',
                                            style: customTextStyle(
                                                color: appFontColorSecondary,
                                                fontSize: 14.0,
                                                fontFamily: appFont),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${members[index].membershipdate}',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: appFont),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5.0),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Last Renewed ',
                                            style: customTextStyle(
                                                color: appFontColorSecondary,
                                                fontSize: 14.0,
                                                fontFamily: appFont),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${members[index].lastrenewal}',
                                            style: customTextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: appFont),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      usertype == 'admin' ?
                                          Column(
                                            children: [
                                              Container(
                                                color: Colors.blue,
                                                height: 40.0,
                                                child: Center(
                                                  child: Text(
                                                    'Personal Info',
                                                    style: customTextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: appFont),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.0),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.place,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    'From ',
                                                    style: customTextStyle(
                                                        color: appFontColorSecondary,
                                                        fontSize: 14.0,
                                                        fontFamily: appFont),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    '${members[index].barangay}, ECHAGUE, ISABELA',
                                                    style: customTextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: appFont),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5.0),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.favorite,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    'Civil Status ',
                                                    style: customTextStyle(
                                                        color: appFontColorSecondary,
                                                        fontSize: 14.0,
                                                        fontFamily: appFont),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    members[index].civilstatus != 'MARRIED' ? '${members[index].civilstatus}' : spousename,
                                                    style: customTextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: appFont),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.cake,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    'Born ',
                                                    style: customTextStyle(
                                                        color: appFontColorSecondary,
                                                        fontSize: 14.0,
                                                        fontFamily: appFont),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    '${members[index].dob}',
                                                    style: customTextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: appFont),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5.0),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.cake_outlined,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    'Age ',
                                                    style: customTextStyle(
                                                        color: appFontColorSecondary,
                                                        fontSize: 14.0,
                                                        fontFamily: appFont),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    '${members[index].age}',
                                                    style: customTextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: appFont),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5.0),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.phone,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    'Contact No. ',
                                                    style: customTextStyle(
                                                        color: appFontColorSecondary,
                                                        fontSize: 14.0,
                                                        fontFamily: appFont),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                  Text(members[index].contactnumber != '' ? '${members[index].contactnumber}' : 'N/A',
                                                    style: customTextStyle(
                                                        fontFamily: appFontBold,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  SizedBox(width: 5.0),
                                                  members[index].contactnumber != '' ? CircleAvatar(
                                                    backgroundColor: Colors.green,
                                                    child: IconButton(
                                                      color: Colors.white,
                                                      iconSize: 18.0,
                                                      icon: Icon(Icons.call_rounded),
                                                      onPressed: () {
                                                        launch('tel:${members[index].contactnumber}');
                                                      },
                                                    ),
                                                  ) : SizedBox.shrink(),
                                                  SizedBox(width: 5.0),
                                                  members[index].contactnumber != '' ? CircleAvatar(
                                                    backgroundColor: Colors.yellow[800],
                                                    child: IconButton(
                                                      color: Colors.white,
                                                      iconSize: 18.0,
                                                      icon: Icon(Icons.sms_outlined),
                                                      onPressed: () {
                                                        launch('sms:${members[index].contactnumber}');
                                                      },
                                                    ),
                                                  ) : SizedBox.shrink(),
                                                ],
                                              ),
                                              SizedBox(height: 5.0),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.work,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    'Occupation. ',
                                                    style: customTextStyle(
                                                        color: appFontColorSecondary,
                                                        fontSize: 14.0,
                                                        fontFamily: appFont),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    members[index].occupation != '' ? '${members[index].occupation}' : 'N/A',
                                                    style: customTextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: appFont),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5.0),
                                              SizedBox(height: 10.0),
                                              Divider(),
                                              SizedBox(height: 10.0), /*
                                      Text(
                                        'Signature:',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: 'Aller'),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      //'https://drv.tw/~mwwinapp@gmail.com/gd/Fast.io/mwapp.imfast.io/images/signature/${members[index].mid}.png'

                                      CachedNetworkImage(
                                        imageUrl: 'https://drv.tw/~mwwinapp@gmail.com/gd/Fast.io/mwapp.imfast.io/images/signature/${members[index].mid}.png',
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                       */
                                            ],
                                          ) : SizedBox.shrink(),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Remarks: ',
                                            style: customTextStyle(
                                                color: appFontColorSecondary,
                                                fontSize: 14.0,
                                                fontFamily: appFont),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            members[index].remarks != '' ? '${members[index].remarks}' : 'N/A',
                                            style: customTextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: appFont),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          }
                          return Text('No results found.');
                        },
                      );
                    }

                    return SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
