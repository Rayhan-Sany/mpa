// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserDetails {
  String name;
  String email;
  String profilePhotoUrl;
  String uid;
  UserDetails({
    required this.name,
    required this.email,
    required this.profilePhotoUrl,
    required this.uid,
  });
  factory UserDetails.fromMap(Map<String, dynamic> user) {
    String name = user["name"];
    String email = user["email"];
    String profilePhotoUrl = user["profilePhotoUrl"];
    String uid = user["uid"];
    return UserDetails(
        name: name, email: email, uid: uid, profilePhotoUrl: profilePhotoUrl);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> userDetils = {
      "name": name,
      "email": email,
      "profilePhotoUrl": profilePhotoUrl,
      "uid": uid
    };
    return userDetils;
  }
}
