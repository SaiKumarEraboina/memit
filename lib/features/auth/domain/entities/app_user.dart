class AppUser {
  final String uid;
  final String name;
  final String email;

  AppUser({required this.uid, required this.email, required this.name});
  // convert from json to object
  factory AppUser.fromJson({required Map<String, dynamic> data}) {
    return AppUser(
        uid: data['uid'],
        email: data['email'],
        name: data['name']
     );
  }

  //convert from object to json
  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email, 'name': name};
  }
}
