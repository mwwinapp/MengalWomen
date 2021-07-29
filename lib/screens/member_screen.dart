import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
                            return Column(
                              children: [
                                Container(
                                  //'https://drv.tw/~mwwinapp@gmail.com/gd/Fast.io/mwapp.imfast.io/images/photo/${members[index].mid}.jpg'
                                  child: CachedNetworkImage(
                                    imageUrl: 'https://drv.tw/~mwwinapp@gmail.com/gd/Fast.io/mwapp.imfast.io/images/photo/${members[index].mid}.jpg',
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
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
                                      Table(
                                        children: [
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Text(
                                                  'Member Since:',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${members[index].membershipdate}',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  'Last Renewal:',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${members[index].lastrenewal}',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Text(
                                                  'Validity:',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${members[index].validity}',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: SizedBox.shrink(),
                                              ),
                                              TableCell(
                                                child: SizedBox.shrink(),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Text(
                                                  'Status:',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
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
                                              ),
                                              TableCell(
                                                child: Text(
                                                  'Member Type:',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${members[index].insurancestatus}',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Text(
                                                  'Id #:',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${members[index].mid}',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  'Id:',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${members[index].mwkit}',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      Divider(),
                                      SizedBox(height: 10.0),
                                      Table(
                                        children: [
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Text(
                                                  'Barangay:',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${members[index].barangay}',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: SizedBox.shrink(),
                                              ),
                                              TableCell(
                                                child: SizedBox.shrink(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Table(
                                        children: [
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Text(
                                                  'Birthday:',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${members[index].dob}',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  'Age:',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${members[index].age}',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Table(
                                        children: [
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Text(
                                                  'Contact #:',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${members[index].contactnumber}',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: SizedBox.shrink(),
                                              ),
                                              TableCell(
                                                child: SizedBox.shrink(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Table(
                                        children: [
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Text(
                                                  'Civil Status:',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${members[index].civilstatus}',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: SizedBox.shrink(),
                                              ),
                                              TableCell(
                                                child: SizedBox.shrink(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Table(
                                        children: [
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Text(
                                                  'Occupation:',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${members[index].occupation}',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Aller'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              TableCell(
                                                child: SizedBox.shrink(),
                                              ),
                                              TableCell(
                                                child: SizedBox.shrink(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      Divider(),
                                      SizedBox(height: 10.0),
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
