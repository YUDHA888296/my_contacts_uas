class Contact {
  int? id;
  String name;
  String phone;
  String email;

  Contact({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  // Convert Object ke Map (untuk Database)
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'phone': phone, 'email': email};
  }

  // Convert Map ke Object (dari Database)
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
    );
  }
}
