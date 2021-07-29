class DetailedMember {

  String mid;
  String membershipdate;
  String lastrenewal;
  String fullname;
  String dob;
  String barangay;
  String status;

  DetailedMember(this.mid, this.lastrenewal, this.fullname, this.dob, this.barangay, this.status);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'mid' : mid,
      'lastrenewal' : lastrenewal,
      'fullname' : fullname,
      'dob' : dob,
      'barangay' : barangay,
      'status' : status
    };
    return map;
  }

  DetailedMember.fromMap(Map<String, dynamic> map) {
    mid = map['mid'];
    lastrenewal = map['lastrenewal'];
    fullname = map['fullname'];
    dob = map['dob'];
    barangay = map['barangay'];
    status = map['status'];
  }
}