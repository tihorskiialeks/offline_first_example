import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:offline_first/core/mappers/data_mapper.dart';
import 'package:offline_first/features/users/domain/entities/company_entity.dart';


part 'company.g.dart';

@JsonSerializable()
class Company extends Equatable implements DataMapper<CompanyEntity> {
  final int? id;
  final String name;
  final String catchPhrase;
  final String bs;

  const Company({
    this.id,
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);

  Company copyWith({
    int? id,
    String? name,
    String? catchPhrase,
    String? bs,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      catchPhrase: catchPhrase ?? this.catchPhrase,
      bs: bs ?? this.bs,
    );
  }

  @override
  List<Object> get props => [name, catchPhrase, bs];

  @override
  bool get stringify => true;

  @override
  CompanyEntity mapToEntity() {
    return CompanyEntity(
      id: id,
      name: name,
      catchPhrase: catchPhrase,
      bs: bs,
    );
  }
}
