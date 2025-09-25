
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:offline_first/core/mappers/data_mapper.dart';
import 'package:offline_first/features/users/data/models/address.dart';
import 'package:offline_first/features/users/data/models/company.dart';
import 'package:offline_first/features/users/domain/entities/user_entity.dart';


part 'user.g.dart';

@JsonSerializable()
class User extends Equatable implements DataMapper<UserEntity> {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;
  final String phone;
  final String website;
  final Company company;
  final bool changedLocally;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
    this.changedLocally = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object> get props {
    return [
      id,
      name,
      username,
      email,
      address,
      phone,
      website,
      company,
    ];
  }

  @override
  bool get stringify => true;

  User copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    Address? address,
    String? phone,
    String? website,
    Company? company,
    bool? changedLocally,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      company: company ?? this.company,
      changedLocally: changedLocally ?? this.changedLocally,
    );
  }

  @override
  UserEntity mapToEntity() {
    return UserEntity(
      id: id,
      name: name,
      username: username,
      email: email,
      address: address.mapToEntity(),
      phone: phone,
      website: website,
      company: company.mapToEntity(),
    );
  }
}
