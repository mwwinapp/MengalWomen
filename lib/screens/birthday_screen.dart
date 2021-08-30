import 'package:flutter/material.dart';
import 'package:mw/functions/global_variables.dart';
import 'package:mw/helpers/db_helper.dart';
import 'package:mw/models/member_model.dart';

class BirthdayScreen extends StatefulWidget {

  @override
  _BirthdayScreenState createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  Future<List<Member>> members;

  var dBHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    setState(() {
      members = dBHelper.birthday();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🎂  Today\'s birthdays', style: TextStyle(fontFamily: 'AllerBold'),),
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
      body: FutureBuilder(
        future: members,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Member> members = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: members.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5.0),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              child:
                              Icon(Icons.person),
                              backgroundColor: Colors
                                  .grey
                                  .withOpacity(0.25),
                              foregroundColor:
                              Colors.white,
                            ),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${members[index].fullname}',
                                  style: TextStyle(
                                      fontFamily:  'AllerBold',
                                    fontSize: 18.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  usertype == 'admin' ? '${members[index].barangay}' : '',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                      fontFamily:
                                      'AllerBold'),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
    );

  }
}
