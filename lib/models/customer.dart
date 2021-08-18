import 'role.dart';

class Customer {
  String name;
  double balance;
  double money;
  //List<Shop> shops;
  String email;
  String uid;
  Role roles;
  bool active;

  Customer(
      {this.name, this.balance, this.money, this.email, this.uid, this.active});
}
