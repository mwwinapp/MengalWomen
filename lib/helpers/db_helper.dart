import 'dart:io';
import 'package:flutter/services.dart';
import 'package:mw/models/member_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static Database _db;
  static const String MID = 'mid';
  static const String LASTRENEWAL = 'lastrenewal';
  static const String FULLNAME = 'fullname';
  static const String DOB = 'dob';
  static const String BARANGAY = 'barangay';
  static const String STATUS = 'status';
  static const String TABLE = 'tblmembers';
  static const String DBNAME = 'db.db3';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDb();
    return _db;
  }

/*
  _initDbOverWrite() async {

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "db.db3");

// delete existing if any
    await deleteDatabase(path);

// Make sure the parent directory exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

// Copy from asset
    ByteData data = await rootBundle.load(join("assets/database", "db.db3"));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes, flush: true);

// open the database
    var db = await openDatabase(path, readOnly: true);
    return db;
  }
*/

  _initDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "db.db3");
    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets/database", "db.db3"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    var db = await openDatabase(path, readOnly: true);
    return db;
  }

  Future<List<Member>> getMembers() async {
    var dBClient = await db;
    List<Map> maps = await dBClient.rawQuery(
        "SELECT mid, lastrenewal, lastname || ', ' || firstname || ' ' || CASE mi WHEN '' THEN '' ELSE mi || '.' END AS fullname, dob, barangay, CASE WHEN DATE(substr(lastrenewal,7,4)||'-'||substr(lastrenewal,1,2)||'-'||substr(lastrenewal,4,2), '+1 year') <= date('now','start of month','+1 month','-1 day') THEN 'EXPIRED' ELSE 'ACTIVE' END AS status FROM tblmembers");
    List<Member> members = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        members.add(Member.fromMap(maps[i]));
      }
    }
    return members;
  }

  Future<List<Member>> search(String keyword,
      [String filterBarangay = '', String filterStatus = '']) async {
    var dBClient = await db;
    List<Map> maps = await dBClient.rawQuery(
        "SELECT mid, lastrenewal, lastname || ', ' || firstname || ' ' || CASE mi WHEN '' THEN '' ELSE mi || '.' END AS fullname, dob, barangay, CASE WHEN DATE(substr(lastrenewal,7,4)||'-'||substr(lastrenewal,1,2)||'-'||substr(lastrenewal,4,2), '+1 year') <= date('now','start of month','+1 month','-1 day') THEN 'EXPIRED' ELSE 'ACTIVE' END AS status FROM tblmembers WHERE fullname LIKE '%$keyword%' $filterBarangay $filterStatus");
    List<Member> members = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        members.add(Member.fromMap(maps[i]));
      }
    }
    return members;
  }

  Future<List<Member>> birthday() async {
    var dBClient = await db;
    List<Map> maps = await dBClient.rawQuery(
        "SELECT mid, lastrenewal, lastname || ', ' || firstname || ' ' || CASE mi WHEN '' THEN '' ELSE mi || '.' END AS fullname, dob, barangay, CASE WHEN DATE(substr(lastrenewal,7,4)||'-'||substr(lastrenewal,1,2)||'-'||substr(lastrenewal,4,2), '+1 year') <= date('now','start of month','+1 month','-1 day') THEN 'EXPIRED' ELSE 'ACTIVE' END AS status FROM tblmembers WHERE substr(strftime('%Y-%m-%d',datetime(substr(dob, 7, 4) || '-' || substr(dob, 1, 2) || '-' || substr(dob, 4, 2))), 6, 5) = strftime('%m-%d',date('now', 'localtime'))");
    List<Member> members = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        members.add(Member.fromMap(maps[i]));
      }
    }
    return members;
  }

//"SELECT mid, membershipdate, nickname, contactnumber, occupation, age, civilstatus, lastrenewal, lastname || ', ' || firstname || ' ' || CASE mi WHEN '' THEN '' ELSE mi || '.' END AS fullname, dob, barangay, CASE WHEN DATE(substr(lastrenewal,7,4)||'-'||substr(lastrenewal,1,2)||'-'||substr(lastrenewal,4,2), '+1 year') <= date('now','start of month','+1 month','-1 day') THEN 'EXPIRED' ELSE 'ACTIVE' END AS status FROM tblmembers WHERE mid = '$keyword' ");
//"SELECT tblmembers.mid, strftime('%Y-%m-%d',datetime(substr(tblmembers.membershipdate, 7, 4) || '-' || substr(tblmembers.membershipdate, 1, 2) || '-' || substr(tblmembers.membershipdate, 4, 2))) AS membershipdate, strftime('%Y-%m-%d',datetime(substr(tblmembers.lastrenewal, 7, 4) || '-' || substr(tblmembers.lastrenewal, 1, 2) || '-' || substr(tblmembers.lastrenewal, 4, 2))) AS lastrenewal, DATE(substr(tblmembers.lastrenewal,7,4)||'-'||substr(tblmembers.lastrenewal,1,2)||'-'||substr(tblmembers.lastrenewal,4,2), '+1 year') AS Validity, tblmembers.lastname || ', ' || tblmembers.firstname || ' ' || CASE tblmembers.mi WHEN '' THEN '' ELSE tblmembers.mi || '.' END AS fullname, CASE WHEN DATE(substr(tblmembers.lastrenewal,7,4)||'-'||substr(tblmembers.lastrenewal,1,2)||'-'||substr(tblmembers.lastrenewal,4,2), '+1 year') <= date('now','start of month','+1 month','-1 day') THEN 'EXPIRED' ELSE 'ACTIVE' END AS Status, tblmembers.contactnumber, tblmembers.occupation, tblmembers.dob, tblmembers.age, tblmembers.barangay || ', ECHAGUE, ISABELA' AS barangay, tblbenefits.beneficiary, tblbenefits.insurancestatus FROM tblmembers LEFT JOIN tblbenefits ON tblmembers.mid = tblbenefits.mid WHERE mid = '$keyword' ");
//"SELECT tblmembers.mid AS mid, strftime('%Y-%m-%d',datetime(substr(tblmembers.membershipdate, 7, 4) || '-' || substr(tblmembers.membershipdate, 1, 2) || '-' || substr(tblmembers.membershipdate, 4, 2))) AS membershipdate, strftime('%Y-%m-%d',datetime(substr(tblmembers.lastrenewal, 7, 4) || '-' || substr(tblmembers.lastrenewal, 1, 2) || '-' || substr(tblmembers.lastrenewal, 4, 2))) AS lastrenewal, DATE(substr(tblmembers.lastrenewal,7,4)||'-'||substr(tblmembers.lastrenewal,1,2)||'-'||substr(tblmembers.lastrenewal,4,2), '+1 year') AS validity, tblmembers.lastname || ', ' || tblmembers.firstname || ' ' || CASE tblmembers.mi WHEN '' THEN '' ELSE tblmembers.mi || '.' END AS fullname, CASE WHEN DATE(substr(tblmembers.lastrenewal,7,4)||'-'||substr(tblmembers.lastrenewal,1,2)||'-'||substr(tblmembers.lastrenewal,4,2), '+1 year') <= date('now','start of month','+1 month','-1 day') THEN 'EXPIRED' ELSE 'ACTIVE' END AS satus, tblmembers.contactnumber as contactnumber, tblmembers.occupation as occupation, tblmembers.dob as dob, tblmembers.age as age, tblmembers.barangay || ', ECHAGUE, ISABELA' AS barangay, tblbenefits.beneficiary AS beneficiary, tblbenefits.insurancestatus AS insurancestatus FROM tblmembers LEFT JOIN tblbenefits ON tblmembers.mid = tblbenefits.mid WHERE mid = '$keyword' ");
  Future<List<Member>> searchmId(String keyword) async {
    var dBClient = await db;
    List<Map> maps = await dBClient.rawQuery(
        "SELECT tblmembers.mid AS mid, strftime('%Y-%m-%d',datetime(substr(tblmembers.membershipdate, 7, 4) || '-' || substr(tblmembers.membershipdate, 1, 2) || '-' || substr(tblmembers.membershipdate, 4, 2))) AS membershipdate, strftime('%Y-%m-%d',datetime(substr(tblmembers.lastrenewal, 7, 4) || '-' || substr(tblmembers.lastrenewal, 1, 2) || '-' || substr(tblmembers.lastrenewal, 4, 2))) AS lastrenewal, DATE(substr(tblmembers.lastrenewal,7,4)||'-'||substr(tblmembers.lastrenewal,1,2)||'-'||substr(tblmembers.lastrenewal,4,2), '+1 year') AS validity, tblmembers.lastname || ', ' || tblmembers.firstname || ' ' || CASE tblmembers.mi WHEN '' THEN '' ELSE tblmembers.mi || '.' END AS fullname, CASE WHEN DATE(substr(tblmembers.lastrenewal,7,4)||'-'||substr(tblmembers.lastrenewal,1,2)||'-'||substr(tblmembers.lastrenewal,4,2), '+1 year') <= date('now','start of month','+1 month','-1 day') THEN 'EXPIRED' ELSE 'ACTIVE' END AS status, tblmembers.contactnumber AS contactnumber, tblmembers.occupation AS occupation, tblmembers.civilstatus AS civilstatus, tblmembers.dob as dob, tblmembers.age AS age, tblmembers.barangay AS barangay, tblbenefits.beneficiary AS beneficiary, tblbenefits.insurancestatus AS insurancestatus, tblbenefits.mwkit AS mwkit, tblspouse.spousename AS spousename FROM tblmembers LEFT JOIN tblbenefits ON tblmembers.mid = tblbenefits.mid LEFT JOIN tblspouse ON tblmembers.mid = tblspouse.mid WHERE tblmembers.mid = '$keyword' ");
    List<Member> members = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        members.add(Member.fromMap(maps[i]));
        print(maps[i]);
      }
    }
    return members;
  }
}
