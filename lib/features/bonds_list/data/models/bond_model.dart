import '../../domain/entities/bond_entity.dart';

class BondModel {
  final String logo;
  final String isin;
  final String rating;
  final String companyName;
  final List<String> tags;

  const BondModel({
    required this.logo,
    required this.isin,
    required this.rating,
    required this.companyName,
    required this.tags,
  });

  factory BondModel.fromJson(Map<String, dynamic> json) => BondModel(
        logo: json['logo'] as String,
        isin: json['isin'] as String,
        rating: json['rating'] as String,
        companyName: json['company_name'] as String,
        tags: (json['tags'] as List<dynamic>).cast<String>(),
      );

  Map<String, dynamic> toJson() => {
        'logo': logo,
        'isin': isin,
        'rating': rating,
        'company_name': companyName,
        'tags': tags,
      };

  BondEntity toEntity() => BondEntity(
        logo: logo,
        isin: isin,
        rating: rating,
        companyName: companyName,
        tags: tags,
      );
}

class BondsListResponse {
  final List<BondModel> data;

  const BondsListResponse({
    required this.data,
  });

  factory BondsListResponse.fromJson(Map<String, dynamic> json) =>
      BondsListResponse(
        data: (json['data'] as List<dynamic>)
            .map((e) => BondModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'data': data.map((e) => e.toJson()).toList(),
      };
}