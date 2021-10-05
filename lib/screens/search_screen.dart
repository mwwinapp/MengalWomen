import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mw/functions/custom_dialog.dart';
import 'package:mw/functions/globals.dart';
import 'package:mw/helpers/db_helper.dart';
import 'package:mw/models/member_model.dart';
import 'package:mw/strings/strings.dart';

import 'member_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<List<Member>> members;
  var dBHelper = DbHelper();
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _searchExecuted = false;

  @override
  void initState() {
    super.initState();
    //
  }

  search(String keyword,
      [String filterBarangay = '', String filterStatus = '']) {
    if (isCheckedBarangay) {
      filterBarangay = " AND barangay = '$_selectedBarangay'";
    }
    if (isCheckedStatus) {
      filterStatus = " AND status = '$_selectedStatus'";
    }
    setState(() {
      members = dBHelper.search(keyword, filterBarangay, filterStatus);
    });
    _searchExecuted = true;
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

  bool isCheckedBarangay = false;
  bool isCheckedStatus = false;
  String _selectedBarangay = 'ANGOLUAN';
  String _selectedStatus = 'ACTIVE';

  Future searchOptionsDialog() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                actionsPadding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
                titleTextStyle: customTextStyle(fontFamily: appFont),
                contentTextStyle: customTextStyle(fontFamily: appFont),
                scrollable: true,
                title: Text(
                  'Search Options:',
                  style: customTextStyle(
                      color: appFontColorSecondary, fontFamily: appFont, fontSize: 18.0),
                ),
                content: ListBody(
                  children: [
                    Text(
                      'Filter by:',
                      style: customTextStyle(color: appFontColorSecondary, fontFamily: appFont),
                    ),
                    SwitchListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Barangay',
                        style: customTextStyle(fontFamily: appFont),
                      ),
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
                              if(_searchExecuted) {
                                _scrollToTop();
                              }
                              search(_searchController.text);
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text(
                              "Apply",
                              textAlign: TextAlign.center,
                              style: customTextStyle(fontFamily: appFontBold, color: Colors.white),
                            ),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: BorderSide(color: Colors.blue),
                                ),
                              ),
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
                              style: customTextStyle(fontFamily: appFontBold, color: Colors.blue),
                            ),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: BorderSide(color: Colors.blue),
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (term) {
                  search(_searchController.text);
                },
                style: customTextStyle(fontFamily: appFont),
                textCapitalization: TextCapitalization.characters,
                controller: _searchController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  isDense: true,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.more_vert),
                    tooltip: 'Click here for search options.',
                    onPressed: () {
                      usertype == 'admin' ? searchOptionsDialog() : customDialog(context, 'Access Denied', 'Guest users have limited access.', true, onPressedOk: () {Navigator.of(context, rootNavigator: true).pop();});
                    },
                  ),
                  hintText: 'Type keyword here',
                  hintStyle: customTextStyle(fontFamily: appFont, color: appFontColorSecondary),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35.0)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: Container(
                child: FutureBuilder(
                  future: members,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Member> members = snapshot.data;
                      return ListView.builder(
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          if (snapshot.hasData) {
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
                                        )
                                      : SizedBox.shrink(),
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
                                      placeholder: (context, url) => CircularProgressIndicator(),
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
                              ),
                            );
                          }
                          return Text('No results found.');
                        },
                      );
                    }

                    if (snapshot.data == null || snapshot.data.length == 0) {
                      return Center(
                        child: Text(
                          'Type keyword to start searching...',
                          style: customTextStyle(
                              color: appFontColorSecondary, fontFamily: appFont),
                        ),
                      );
                    }

                    return CircularProgressIndicator();
                  },
                ),
              ),
            ),
          ],
        ),
        _searchExecuted
            ? Positioned(
                bottom: 20.0,
                right: 20.0,
                child: Opacity(
                  opacity: .25,
                  child: FloatingActionButton(
                    child: Icon(Icons.keyboard_arrow_up),
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      _scrollToTop();
                    },
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
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
}



/*



*/
