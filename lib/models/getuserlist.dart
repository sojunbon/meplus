import './getuser_model.dart';

/// Represents a tourism location a user can visit.
class GetuserList {
  final String uid;
  final String name;
  final String bankname;
  final String bankaccount;
  final String mobile;
  final List<GetuserModel> facts;

  GetuserList(this.uid, this.name, this.bankname, this.bankaccount, this.mobile,
      this.facts);

  // NOTE: implementing functionality here in the next step!
}
