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
  bool _isScrollable = false;

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
    //_isScrollable = true;
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
                backgroundColor: appBackgroundColorPrimary,
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
                      activeColor: appColorPrimary,
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
                              if(_isScrollable) {
                                _scrollToTop();
                              }
                              search(_searchController.text);
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text(
                              "Apply",
                              textAlign: TextAlign.center,
                              style: customTextStyle(fontFamily: appFontBold, color: appBackgroundColorPrimary),
                            ),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(appBackgroundColorPrimary),
                              backgroundColor: MaterialStateProperty.all<Color>(appColorPrimary),
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
                              backgroundColor: MaterialStateProperty.all<Color>(appBackgroundColorPrimary),
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
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: appColorPrimary, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: appFontColorSecondary,
                      width: 1.0,
                    ),
                  ),
                  fillColor: appBackgroundColorPrimary,
                  filled: true,
                  isDense: true,
                  prefixIcon: IconTheme(data: IconThemeData(color: appColorPrimary), child: Icon(Icons.search)),
                  suffixIcon: IconTheme(
                    data: IconThemeData(color: appColorPrimary),
                    child: IconButton(
                      icon: Icon(Icons.more_vert),
                      tooltip: 'Click here for search options.',
                      onPressed: () {
                        usertype == 'admin' ? searchOptionsDialog() : customDialog(context, 'Access Denied', 'Guest users have limited access.', true, onPressedOk: () {Navigator.of(context, rootNavigator: true).pop();});
                      },
                    ),
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
                            _checkScrollable();
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
                                      placeholder: (context, url) => CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary)),
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
        _isScrollable
            ? Positioned(
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
              )
            : SizedBox.shrink(),
      ],
    );
  }

  void _checkScrollable() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_scrollController.position.maxScrollExtent > 0) {
        setState(() {
          _isScrollable = true;
        });
      } else {
        setState(() {
          _isScrollable = false;
        });
      }
    });
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
