import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mw/functions/globals.dart';
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
        elevation: 0.0,
        centerTitle: true,
        title: Text('🎂  Today\'s birthdays', style: customTextStyle(fontFamily: appFontBold, color: appBackgroundColorPrimary, fontSize: 18.0),),
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
                      leading: usertype == 'admin' ? CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: 'https://drv.tw/~mwwinapp@gmail.com/gd/Fast.io/mwapp.imfast.io/images/photo/${members[index].mid}.jpg',
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Icon(Icons.person, color: Colors.grey, size: 40.0,),//CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary)),
                        errorWidget: (context, url, error) => Icon(Icons.person, color: Colors.grey, size: 40.0,),
                      ) : Icon(Icons.person, color: Colors.grey, size: 40.0,),
                      dense: true,
                      title: Text(
                        '${members[index].fullname}',
                        style: customTextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: appFont),
                        overflow: TextOverflow.ellipsis,
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
                              style: customTextStyle(
                                  fontSize: 12.0,
                                  color: appFontColorSecondary,
                                  fontFamily: appFont),
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
                              style: customTextStyle(
                                  fontSize: 12.0,
                                  color: appFontColorSecondary,
                                  fontFamily: appFont),
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
                              style: customTextStyle(
                                  fontSize: 12.0,
                                  color: appFontColorSecondary,
                                  fontFamily: appFont),
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
