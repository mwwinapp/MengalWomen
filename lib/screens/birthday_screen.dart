import 'package:flutter/material.dart';
import 'package:mw/functions/global_variables.dart';
import 'package:mw/helpers/db_helper.dart';
import 'package:mw/models/member_model.dart';
import 'package:mw/screens/member_screen.dart';

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
                    ListTile(
                      dense: true,
                      title: Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.blue,
                            size: 17.0,
                          ),
                          Text(
                            '${members[index].fullname}',
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Aller'),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      subtitle: usertype == 'admin' ? Row(
                          children: [
                            Icon(
                              Icons.place,
                              color: Colors.grey,
                              size: 12.0,
                            ),
                            Text(
                              '${members[index].barangay}',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                  fontFamily: 'Aller'),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(width: 2.0),
                            Icon(
                              Icons.update,
                              color: Colors.grey,
                              size: 12.0,
                            ),
                            Text(
                              '${members[index].validity}',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                  fontFamily: 'Aller'),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]
                      ) : Row(
                          children: [
                            Icon(
                              Icons.update,
                              color: Colors.grey,
                              size: 12.0,
                            ),
                            Text(
                              '${members[index].validity}',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                  fontFamily: 'Aller'),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]
                      ),
                      trailing: Icon(
                        Icons.brightness_1,
                        color: members[index].status == 'ACTIVE'
                            ? Colors.green
                            : Colors.red,
                        size: 10.0,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MemberScreen(mid: members[index].mid),
                          ),
                        );
                      },
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
