class Announcement {
  String imageUrl;
  String title;
  String content;
  String postDate;

  Announcement(this.imageUrl, this.title, this.content, this.postDate);

  Announcement.fromJson(Map<String, dynamic> json) {
    imageUrl = json["imageUrl"];
    title = json["title"];
    content = json["content"];
    postDate = json["postDate"];
  }
}
