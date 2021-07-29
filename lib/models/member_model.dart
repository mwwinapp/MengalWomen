class Member {

  String mid;
  String membershipdate;
  String lastrenewal;
  String fullname;
  String contactnumber;
  String dob;
  String age;
  String occupation;
  String civilstatus;
  String barangay;
  String status;
  String insurancestatus;
  String mwkit;
  String validity;

  Member({this.mid, this.membershipdate, this.lastrenewal, this.fullname, this.contactnumber, this.dob, this.age, this.occupation, this.civilstatus, this.barangay, this.status});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'mid' : mid,
      'membershipdate' : membershipdate,
      'lastrenewal' : lastrenewal,
      'fullname' : fullname,
      'contactnumber' : contactnumber,
      'dob' : dob,
      'age' : age,
      'occupation' : occupation,
      'civilstatus' : civilstatus,
      'barangay' : barangay,
      'status' : status,
      'insurancestatus' : insurancestatus,
      'mwkit' : mwkit,
      'validity' : validity
    };
    return map;
  }

  Member.fromMap(Map<String, dynamic> map) {
    mid = map['mid'];
    membershipdate = map['membershipdate'];
    lastrenewal = map['lastrenewal'];
    fullname = map['fullname'];
    contactnumber = map['contactnumber'];
    dob = map['dob'];
    age = map['age'];
    occupation = map['occupation'];
    civilstatus = map['civilstatus'];
    barangay = map['barangay'];
    status = map['status'];
    insurancestatus = map['insurancestatus'];
    mwkit = map['mwkit'];
    validity = map['validity'];
  }
}