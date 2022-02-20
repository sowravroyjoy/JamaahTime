class UserModel{
  String? userID;
  String? email;
  String? firstName;
  String? secondName;
  String? role;

  UserModel({this.userID, this.email, this.firstName, this.secondName, this.role});

  factory UserModel.fromMap(map){
    return UserModel(
      userID: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'uid' : userID,
      'email' : email,
      'firstName' : firstName,
      'secondName' : secondName,
      'role' : role,
    };
  }

}