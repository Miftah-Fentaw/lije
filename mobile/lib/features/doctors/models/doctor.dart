class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final double rating;
  final int reviews;
  final String experience;
  final double price;
  final String image;
  final bool isOnline;
  final String bio;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.rating,
    required this.reviews,
    required this.experience,
    required this.price,
    this.image = '',
    this.isOnline = false,
    required this.bio,
  });
}
