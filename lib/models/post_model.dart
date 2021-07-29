class Post {
  String imageUrl;
  String title;
  String content;
  String postDate;

  Post(this.imageUrl, this.title, this.content, this.postDate);

  Post.fromJson(Map<String, dynamic> json) {
    imageUrl = json["imageUrl"];
    title = json["title"];
    content = json["content"];
    postDate = json["postDate"];
    print('From JSON OK');
  }
}
