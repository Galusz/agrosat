class Field {
  int? id;
  int? user;
  String? name;
  String? comment;
  String? geom;

  Field(
      {this.id,
        this.user,
        this.name,
        this.comment,
        this.geom,});

  Field.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    name = json['name'];
    comment = json['comment'];
    geom = json['geom'];
  }
}