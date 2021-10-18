import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:mw/functions/custom_dialog.dart';
import 'package:mw/functions/globals.dart';
import 'package:mw/helpers/db_helper.dart';
import 'package:mw/models/member_model.dart';
import 'package:mw/screens/member_screen.dart';
import 'package:mw/strings/strings.dart';

class SearchBarScreen extends StatefulWidget {

  @override
  _SearchBarScreenState createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {

  Future<List<Member>> members;
  var dBHelper = DbHelper();
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isCheckedBarangay = false;
  bool isCheckedStatus = false;
  bool isCheckedMemberType = false;
  String _selectedMemberType = 'REGULAR';
  String _selectedBarangay = 'ANGOLUAN';
  String _selectedStatus = 'ACTIVE';
  int resultCount = 0;
  bool isScrolling = false;

  @override
  void initState() {
    super.initState();
/*    _scrollController.addListener(() {
      if(!_scrollController.position.atEdge) {
        setState((){
          isScrolling = true;
        });
      } else {
        if(_scrollController.position.pixels == 0) {
          setState((){
            isScrolling = false;
          });
        }
      }
    });*/
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  search(String keyword,
      [String filterBarangay = '', String filterStatus = '', String filterMemberType = '']) {
    if (isCheckedBarangay) {
      filterBarangay = " AND barangay = '$_selectedBarangay'";
    }
    if (isCheckedStatus) {
      filterStatus = " AND status = '$_selectedStatus'";
    }
    if (isCheckedMemberType) {
      filterMemberType = " AND insurancestatus = '$_selectedMemberType'";
    }
    setState(() {
      members = dBHelper.search(keyword, filterBarangay, filterStatus, filterMemberType);
      isScrolling = false;
      _scrollToTop();
    });
  }

  List<DropdownMenuItem> barangayList() {
    if (isCheckedBarangay) {
      return barangay.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList();
    }
    return null;
  }

  List<DropdownMenuItem> statusList() {
    if (isCheckedStatus) {
      return [
        DropdownMenuItem(
          value: 'ACTIVE',
          child: Text('ACTIVE'),
        ),
        DropdownMenuItem(
          value: 'EXPIRED',
          child: Text('EXPIRED'),
        ),
      ];
    }
    return null;
  }

  List<DropdownMenuItem> memberTypeList() {
    if (isCheckedMemberType) {
      return [
        DropdownMenuItem(
          value: 'REGULAR',
          child: Text('REGULAR'),
        ),
        DropdownMenuItem(
          value: 'PREMIUM',
          child: Text('PREMIUM'),
        ),
      ];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: TextFormField(
            autofocus: true,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (term) {
              search(_searchController.text);

            },
            style: customTextStyle(fontFamily: appFont),
            textCapitalization: TextCapitalization.characters,
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: IconTheme(data: IconThemeData(color: appColorPrimary), child: Icon(Icons.search)),
              suffixIcon: IconTheme(
                data: IconThemeData(color: appColorPrimary),
                child: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.text = '';
              });
                  },
                ),
              ),
              hintText: 'Type keyword here',
            ),
          ),
          actions: [
            IconTheme(
              data: IconThemeData(color: appBackgroundColorPrimary),
              child: IconButton(
                icon: Icon(Icons.more_vert),
                tooltip: 'Click here for search options.',
                onPressed: () {
                  usertype == 'admin' ? searchOptionsDialog() : customDialog(context, 'Access Denied', 'Guest users have limited access.', true, onPressedOk: () {Navigator.of(context, rootNavigator: true).pop();});
                },
              ),
            ),
          ],
        ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isCheckedBarangay || isCheckedStatus ?
                    Text('Filtered by: ',
                        style: customTextStyle(
                            fontFamily: appFont,
                            fontWeight: FontWeight.bold,
                            color: appFontColorSecondary,
                            fontSize: 12.0)) :
                    SizedBox.shrink(),
                    isCheckedBarangay
                        ? Text(
                      'Barangay: $_selectedBarangay',
                      overflow: TextOverflow.ellipsis,
                      style: customTextStyle(
                          fontFamily: appFont,
                          color: appFontColorSecondary,
                          fontSize: 12.0),
                    )
                        : SizedBox.shrink(),
                    isCheckedBarangay && isCheckedStatus ?
                    Text(', ',
                        style: customTextStyle(
                            fontFamily: appFont,
                            color: appFontColorSecondary,
                            fontSize: 12.0)) :
                    SizedBox.shrink(),
                    isCheckedStatus
                        ? Text(
                      'Status: $_selectedStatus',
                      overflow: TextOverflow.ellipsis,
                      style: customTextStyle(
                          fontFamily: appFont,
                          color: appFontColorSecondary,
                          fontSize: 12.0),
                    )
                        : SizedBox.shrink(),
                    (isCheckedBarangay || isCheckedStatus) && isCheckedMemberType ?
                    Text(', ',
                        style: customTextStyle(
                            fontFamily: appFont,
                            color: appFontColorSecondary,
                            fontSize: 12.0)) :
                    SizedBox.shrink(),
                    isCheckedMemberType
                        ? Expanded(
                          child: Text(
                      'Membertype: $_selectedMemberType',
                      overflow: TextOverflow.ellipsis,
                      style: customTextStyle(
                            fontFamily: appFont,
                            color: appFontColorSecondary,
                            fontSize: 12.0),
                    ),
                        )
                        : SizedBox.shrink()
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: members,
                  builder: (context, snapshot) {
                      List<Member> members = snapshot.data;
                      if (snapshot.hasData) {
                        return ListView.builder(
                          controller: _scrollController,
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Column(
                                  children: [
                                    index == 0
                                        ? Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 20.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Result: ',
                                                overflow: TextOverflow.ellipsis,
                                                style: customTextStyle(
                                                    color: appFontColorSecondary,
                                                    fontSize: 15.0,
                                                    fontFamily: appFont),
                                              ),
                                              Text(
                                                '${members.length}',
                                                overflow: TextOverflow.ellipsis,
                                                style: customTextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.0,
                                                    fontFamily: appFont),
                                              ),
                                              Text(
                                                ' member(s) found.',
                                                overflow: TextOverflow.ellipsis,
                                                style: customTextStyle(
                                                    color: appFontColorSecondary,
                                                    fontSize: 15.0,
                                                    fontFamily: appFont),
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                        ],
                                      ),
                                    ) : SizedBox.shrink(),
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
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: appFont),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: usertype == 'admin' ? Row(
                                          children: [
                                            Icon(
                                              Icons.place,
                                              color: Colors.grey,
                                              size: 10.0,
                                            ),
                                            Text(
                                              '${members[index].barangay}',
                                              style: customTextStyle(
                                                  fontSize: 10.0,
                                                  color: appFontColorSecondary,
                                                  fontFamily: appFont),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(width: 2.0),
                                            Icon(
                                              Icons.update,
                                              color: Colors.grey,
                                              size: 10.0,
                                            ),
                                            Text(
                                              '${members[index].validity}',
                                              style: customTextStyle(
                                                  fontSize: 10.0,
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
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          DateFormat("MM/dd").format(DateTime.now()).toString() == members[index].dob.substring(0, 5) ? Text('🎂  ') : SizedBox.shrink(),
                                          Icon(
                                            Icons.brightness_1,
                                            color: members[index].status == 'ACTIVE'
                                                ? Colors.green
                                                : Colors.red,
                                            size: 10.0,
                                          ),
                                        ],
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
                                ),
                              );
                          },
                        );
                      }

                      if (snapshot.data == null || snapshot.data.length == 0) {
                        return Center(
                          child: Text('Type keyword to start searching...'),
                        );
                      }

                      return Center(
                        child: Container(
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary)),
                          height: 50.0,
                          width: 50.0,
                        ),
                      );
                  },
                ),
              ),
            ],
          ),
          //----------
          isScrolling ? Positioned(
            bottom: 20.0,
            right: 20.0,
            child: Opacity(
              opacity: .75,
              child: FloatingActionButton(
                child: Icon(Icons.arrow_upward),
                backgroundColor: appColorPrimary,
                onPressed: () {
                  _scrollToTop();
                },
              ),
            ),
          ) : SizedBox.shrink()
        ],
      ),
    );
  }

  void _scrollToTop() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.elasticOut,
      );
    });
  }


  Future searchOptionsDialog() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                actionsPadding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
                scrollable: true,
                title: Text(
                  'Search Options:',
                  style: customTextStyle(
                      color: appFontColorSecondary,fontSize: 18.0),
                ),
                content: ListBody(
                  children: [
                    Text(
                      'Filter by:',
                      style: customTextStyle(color: appFontColorSecondary),
                    ),
                    SwitchListTile(
                      activeColor: appColorPrimary,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.all(0),
                      title: Text('Barangay'),
                      value: isCheckedBarangay,
                      onChanged: (value) {
                        setState(
                              () {
                            isCheckedBarangay = value;
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: DropdownButton<String>(
                        dropdownColor: appBackgroundColorPrimary,
                        isExpanded: true,
                        disabledHint: Text(
                          'Select Barangay',
                          style: customTextStyle(fontFamily: appFont, color: appFontColorSecondary),
                        ),
                        style: customTextStyle(fontFamily: appFont),
                        items: barangayList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedBarangay = value;
                          });
                        },
                        value: _selectedBarangay,
                      ),
                    ),
                    SwitchListTile(
                      activeColor: appColorPrimary,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Status',
                        style: customTextStyle(fontFamily: appFont),
                      ),
                      value: isCheckedStatus,
                      onChanged: (value) {
                        setState(
                              () {
                            isCheckedStatus = value;
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: DropdownButton(
                        dropdownColor: appBackgroundColorPrimary,
                        isExpanded: true,
                        disabledHint: Text(
                          'Select Status',
                          style: customTextStyle(fontFamily: appFont, color: appFontColorSecondary),
                        ),
                        style: customTextStyle(fontFamily: appFont),
                        items: statusList(),
                        value: _selectedStatus,
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                      ),
                    ),
                    SwitchListTile(
                      activeColor: appColorPrimary,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Member Type',
                        style: customTextStyle(fontFamily: appFont),
                      ),
                      value: isCheckedMemberType,
                      onChanged: (value) {
                        setState(
                              () {
                            isCheckedMemberType = value;
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: DropdownButton(
                        dropdownColor: appBackgroundColorPrimary,
                        isExpanded: true,
                        disabledHint: Text(
                          'Select Membertype',
                          style: customTextStyle(fontFamily: appFont, color: appFontColorSecondary),
                        ),
                        style: customTextStyle(fontFamily: appFont),
                        items: memberTypeList(),
                        value: _selectedMemberType,
                        onChanged: (value) {
                          setState(() {
                            _selectedMemberType = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                actions: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50.0,
                          child: TextButton(
                            onPressed: () {
                              search(_searchController.text);
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text(
                              "Apply",
                              textAlign: TextAlign.center,
                              style: customTextStyle(fontFamily: appFontBold, color: appBackgroundColorPrimary),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Expanded(
                        child: Container(
                          height: 50.0,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text(
                              "Close",
                              textAlign: TextAlign.center,
                              style: customTextStyle(fontFamily: appFontBold, color: appColorPrimary),
                            ),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(appColorPrimary),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: BorderSide(color: appColorPrimary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        });
  }
}
