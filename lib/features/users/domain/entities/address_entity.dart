class AddressEntity {
  final int? id;
  final String street;
  final String suite;
  final String city;
  final String zipcode;

  const AddressEntity({
    this.id,
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
  });
}
