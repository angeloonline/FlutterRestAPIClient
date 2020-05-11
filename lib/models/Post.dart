class Post{
  String id;
  String title;
  String description;
  DateTime date;

  Post({
    this.id,
    this.title,
    this.description,
    this.date
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description
    };
  }
}