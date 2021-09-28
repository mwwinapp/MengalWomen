import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mw/functions/global_variables.dart';
import 'package:mw/helpers/db_helper.dart';
import 'package:mw/models/member_model.dart';

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
        title: Text(
          'Member Details',
          style: TextStyle(fontFamily: 'AllerBold'),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blueAccent,
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
                                CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: usertype == 'admin' ? 'https://drv.tw/~mwwinapp@gmail.com/gd/Fast.io/mwapp.imfast.io/images/photo/${members[index].mid}.jpg' : '',
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
                                ),
                                Padding(
                                  padding:
                                  EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Column(
                                    children: [
                                      //SizedBox(height: 20.0),
                                      Divider(),
                                      Text(
                                        '${members[index].fullname}',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Aller'),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Divider(),
                                      SizedBox(height: 10.0),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Id Number ',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14.0,
                                                fontFamily: 'Aller'),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${members[index].mid}',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight:
                                                FontWeight.bold,
                                                fontFamily: 'Aller'),
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
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14.0,
                                                fontFamily: 'Aller'),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${members[index].mwkit}',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight:
                                                FontWeight.bold,
                                                fontFamily: 'Aller'),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5.0),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.flourescent,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Member Type ',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14.0,
                                                fontFamily: 'Aller'),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${members[index].insurancestatus}',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight:
                                                FontWeight.bold,
                                                fontFamily: 'Aller'),
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
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14.0,
                                                fontFamily: 'Aller'),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${members[index].membershipdate}',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight:
                                                FontWeight.bold,
                                                fontFamily: 'Aller'),
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
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14.0,
                                                fontFamily: 'Aller'),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${members[index].lastrenewal}',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight:
                                                FontWeight.bold,
                                                fontFamily: 'Aller'),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5.0),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.update,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Validity ',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14.0,
                                                fontFamily: 'Aller'),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${members[index].validity}',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight:
                                                FontWeight.bold,
                                                fontFamily: 'Aller'),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            members[index]
                                                .status ==
                                                'ACTIVE' ? Icons.check : Icons.circle,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Status ',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14.0,
                                                fontFamily: 'Aller'),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${members[index].status}',
                                            style: TextStyle(
                                                color: members[index]
                                                    .status ==
                                                    'ACTIVE'
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontSize: 14.0,
                                                fontWeight:
                                                FontWeight.bold,
                                                fontFamily: 'Aller'),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      Divider(),
                                      SizedBox(height: 10.0),
                                      usertype == 'admin' ?
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.place,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    'From ',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14.0,
                                                        fontFamily: 'Aller'),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    '${members[index].barangay}, ECHAGUE, ISABELA',
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Aller'),
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
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14.0,
                                                        fontFamily: 'Aller'),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    members[index].civilstatus != 'MARRIED' ? '${members[index].civilstatus}' : spousename,
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Aller'),
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
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14.0,
                                                        fontFamily: 'Aller'),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    '${members[index].dob}',
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Aller'),
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
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14.0,
                                                        fontFamily: 'Aller'),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    '${members[index].age}',
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Aller'),
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
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14.0,
                                                        fontFamily: 'Aller'),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    members[index].contactnumber != '' ? '${members[index].contactnumber}' : 'N/A',
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Aller'),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
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
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14.0,
                                                        fontFamily: 'Aller'),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    members[index].occupation != '' ? '${members[index].occupation}' : 'N/A',
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontFamily: 'Aller'),
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
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Remarks: ',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14.0,
                                                fontFamily: 'Aller'),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            members[index].remarks != '' ? '${members[index].remarks}' : 'N/A',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight:
                                                FontWeight.bold,
                                                fontFamily: 'Aller'),
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
