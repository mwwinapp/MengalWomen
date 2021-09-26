import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mw/functions/custom_dialog.dart';
import 'package:mw/functions/global_variables.dart';
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
  int results;

  Future searchOptionsDialog() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                actionsPadding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
                titleTextStyle: TextStyle(fontFamily: 'Aller'),
                contentTextStyle: TextStyle(fontFamily: 'Aller'),
                scrollable: true,
                title: Text(
                  'Search Options:',
                  style: TextStyle(
                      color: Colors.grey, fontFamily: 'Aller', fontSize: 18.0),
                ),
                content: ListBody(
                  children: [
                    Text(
                      'Filter by:',
                      style: TextStyle(color: Colors.grey, fontFamily: 'Aller'),
                    ),
                    SwitchListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Barangay',
                        style: TextStyle(fontFamily: 'Aller'),
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
                          style: TextStyle(fontFamily: 'Aller'),
                        ),
                        style:
                        TextStyle(fontFamily: 'Aller', color: Colors.black),
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
                        style: TextStyle(fontFamily: 'Aller'),
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
                            style: TextStyle(fontFamily: 'Aller'),
                          ),
                        style:
                        TextStyle(fontFamily: 'Aller', color: Colors.black),
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
                              "Search",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'AllerBold'),
                            ),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: BorderSide(color: Colors.green),
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
                              "Cancel",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'AllerBold'),
                            ),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: BorderSide(color: Colors.red),
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
                style: TextStyle(fontFamily: 'Aller'),
                textCapitalization: TextCapitalization.characters,
                controller: _searchController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  isDense: true,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      usertype == 'admin' ? searchOptionsDialog() : customDialog(context, 'Access Denied', 'Guest users have limited access.', true, onPressedOk: () {Navigator.of(context, rootNavigator: true).pop();});
                    },
                  ),
                  hintText: 'Type keyword here',
                  hintStyle: TextStyle(fontFamily: 'Aller'),
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
                          style: TextStyle(
                          fontFamily: 'Aller',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 12.0)) :
                  SizedBox.shrink(),
                  isCheckedBarangay
                      ? Text(
                        'Barangay: $_selectedBarangay',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Aller',
                            color: Colors.grey,
                            fontSize: 12.0),
                      )
                      : SizedBox.shrink(),
                  isCheckedBarangay && isCheckedStatus ?
                  Text(', ',
                      style: TextStyle(
                          fontFamily: 'Aller',
                          color: Colors.grey,
                          fontSize: 12.0)) :
                  SizedBox.shrink(),
                  isCheckedStatus
                      ? Text(
                        'Status: $_selectedStatus',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Aller',
                            color: Colors.grey,
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
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15.0,
                                                        fontFamily: 'Aller'),
                                                  ),
                                                  Text(
                                                    '${members.length}',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15.0,
                                                        fontFamily: 'Aller'),
                                                  ),
                                                  Text(
                                                    ' member(s) found.',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15.0,
                                                        fontFamily: 'Aller'),
                                                  ),
                                                ],
                                              ),
                                              Divider(),
                                            ],
                                          ),
                                        )
                                      : SizedBox.shrink(),
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
                          style: TextStyle(
                              color: Colors.grey, fontFamily: 'Aller'),
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
