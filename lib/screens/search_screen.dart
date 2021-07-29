import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
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
                    DropdownButton<String>(
                      isExpanded: true,
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
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        'Filter by Status',
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
                    DropdownButton(
                      isExpanded: true,
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
                  ],
                ),
                actions: [
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      if(_searchExecuted) {
                        _scrollToTop();
                      }
                      search(_searchController.text);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(height: 15.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
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
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _searchController.text = '';
                              });
                            },
                          ),
                          hintText: 'Type keyword here',
                          hintStyle: TextStyle(fontFamily: 'Aller'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35.0)),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50.0,
                              child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                elevation: 0.0,
                                onPressed: () {
                                  if(_searchExecuted) {
                                    _scrollToTop();
                                  }
                                  search(_searchController.text);
                                  FocusScope.of(context).unfocus();
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                padding: EdgeInsets.all(0.0),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: 300.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Search",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'AllerBold'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: RaisedButton(
                              elevation: 0.0,
                              onPressed: () {
                                searchOptionsDialog();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: Border.all(color: Colors.grey)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: 300.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Search Options",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Aller'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          isCheckedBarangay
                              ? Padding(
                                  padding: EdgeInsets.only(top: 15.0),
                                  child: Text(
                                    'Barangay: $_selectedBarangay',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Aller',
                                        color: Colors.grey,
                                        fontSize: 12.0),
                                  ),
                                )
                              : SizedBox.shrink(),
                          isCheckedStatus
                              ? Padding(
                                  padding: EdgeInsets.only(top: 15.0),
                                  child: Text(
                                    'Status: $_selectedStatus',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Aller',
                                        color: Colors.grey,
                                        fontSize: 12.0),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
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
                                            child: Text(
                                              'Results: ${members.length} members found.',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15.0,
                                                  fontFamily: 'Aller'),
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                    //
                                    ListTile(
                                      dense: true,
                                      title: Text(
                                        '${members[index].fullname}',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Aller'),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        '${members[index].barangay} • ${members[index].lastrenewal}',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey,
                                            fontFamily: 'Aller'),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Icon(
                                        Icons.brightness_1,
                                        color: members[index].status == 'ACTIVE'
                                            ? Colors.green
                                            : Colors.red,
                                        size: 15.0,
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
