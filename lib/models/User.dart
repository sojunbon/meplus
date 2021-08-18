class User {
  String users;
  bool admin;

  User(this.users);

  Map<String, dynamic> toJson() => {
        'users': users,
        'admin': admin,
      };
}
