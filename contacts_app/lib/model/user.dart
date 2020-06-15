
class User {
  int id;
  final String name;
  final String mobile;
  final String landLine;
  final String path;
  final int fav;

  User({this.name, this.mobile, this.landLine,  this.path, this.fav = 0});

  User.fromId({this.id, this.name, this.mobile, this.landLine, this.path, this.fav = 0});

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Mobile': mobile,
      'Landline': landLine,
      'Path': path,
      'Favorite': fav
    };
  }

}