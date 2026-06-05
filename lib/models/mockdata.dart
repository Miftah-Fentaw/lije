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

const List<Doctor> mockDoctors = [
  Doctor(
    id: '1',
    name: 'Dr. Bethlehem Tadesse',
    specialty: 'Obstetrician & Gynecologist',
    hospital: 'St. Paul\'s Hospital',
    rating: 4.9,
    reviews: 124,
    experience: '8 years',
    price: 500.0,
    isOnline: true,
    bio: 'Specialized in high-risk pregnancy and prenatal care. Dedicated to providing compassionate care for maternal health.',
  ),
  Doctor(
    id: '2',
    name: 'Dr. Yonas Mulugeta',
    specialty: 'Pediatrician',
    hospital: 'Black Lion Hospital',
    rating: 4.8,
    reviews: 89,
    experience: '12 years',
    price: 450.0,
    isOnline: true,
    bio: 'Expert in newborn care and child development. Focuses on preventive medicine and infectious diseases in children.',
  ),
  Doctor(
    id: '3',
    name: 'Dr. Selamawit Hailu',
    specialty: 'Maternal-Fetal Medicine',
    hospital: 'Hayat Hospital',
    rating: 4.7,
    reviews: 56,
    experience: '6 years',
    price: 600.0,
    isOnline: false,
    bio: 'Focused on fetal development monitoring and managing complex pregnancy conditions through advanced imaging.',
  ),
  Doctor(
    id: '4',
    name: 'Dr. Abel Kebede',
    specialty: 'General Practitioner',
    hospital: 'Landmark Hospital',
    rating: 4.6,
    reviews: 112,
    experience: '5 years',
    price: 300.0,
    isOnline: true,
    bio: 'Providing comprehensive primary care for families with a focus on maternal wellness and community health.',
  ),
];
