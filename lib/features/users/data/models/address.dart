import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:offline_first/core/mappers/data_mapper.dart';
import 'package:offline_first/features/users/domain/entities/address_entity.dart';


part 'address.g.dart';

@JsonSerializable()
class Address extends Equatable implements DataMapper<AddressEntity> {
  final int? id;
  final String street;
  final String suite;
  final String city;
  final String zipcode;

  const Address({
    this.id,
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  Address copyWith({
    int? id,
    String? street,
    String? suite,
    String? city,
    String? zipcode,
  }) {
    return Address(
      id: id ?? this.id,
      street: street ?? this.street,
      suite: suite ?? this.suite,
      city: city ?? this.city,
      zipcode: zipcode ?? this.zipcode,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      street,
      suite,
      city,
      zipcode,
    ];
  }

  @override
  AddressEntity mapToEntity() {
    return AddressEntity(
      id: id,
      street: street,
      suite: suite,
      city: city,
      zipcode: zipcode,
    );
  }
}
