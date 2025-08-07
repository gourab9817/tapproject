import '../../domain/entities/bond_detail_entity.dart';

class BondDetailModel {
  final String logo;
  final String companyName;
  final String description;
  final String isin;
  final String status;
  final ProsConsModel? prosAndCons;
  final FinancialsModel? financials;
  final IssuerDetailsModel? issuerDetails;

  const BondDetailModel({
    required this.logo,
    required this.companyName,
    required this.description,
    required this.isin,
    required this.status,
    this.prosAndCons,
    this.financials,
    this.issuerDetails,
  });

  factory BondDetailModel.fromJson(Map<String, dynamic> json) =>
      BondDetailModel(
        logo: json['logo'] as String,
        companyName: json['company_name'] as String,
        description: json['description'] as String,
        isin: json['isin'] as String,
        status: json['status'] as String,
        prosAndCons: json['pros_and_cons'] != null
            ? ProsConsModel.fromJson(json['pros_and_cons'] as Map<String, dynamic>)
            : null,
        financials: json['financials'] != null
            ? FinancialsModel.fromJson(json['financials'] as Map<String, dynamic>)
            : null,
        issuerDetails: json['issuer_details'] != null
            ? IssuerDetailsModel.fromJson(json['issuer_details'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'logo': logo,
        'company_name': companyName,
        'description': description,
        'isin': isin,
        'status': status,
        'pros_and_cons': prosAndCons?.toJson(),
        'financials': financials?.toJson(),
        'issuer_details': issuerDetails?.toJson(),
      };

  BondDetailEntity toEntity() => BondDetailEntity(
        logo: logo,
        companyName: companyName,
        description: description,
        isin: isin,
        status: status,
        prosAndCons: prosAndCons?.toEntity(),
        ebitdaHistory: financials?.ebitda?.map((e) => e.toEntity()).toList(),
        revenueHistory: financials?.revenue?.map((e) => e.toEntity()).toList(),
        issuerDetails: issuerDetails?.toEntity(),
      );
}

class EbitdaDataPointModel {
  final String month;
  final double value;

  const EbitdaDataPointModel({
    required this.month,
    required this.value,
  });

  factory EbitdaDataPointModel.fromJson(Map<String, dynamic> json) =>
      EbitdaDataPointModel(
        month: json['month'] as String,
        value: (json['value'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'month': month,
        'value': value,
      };

  EbitdaDataPoint toEntity() => EbitdaDataPoint(
        month: month,
        value: value,
      );
}

class FinancialsModel {
  final List<EbitdaDataPointModel>? ebitda;
  final List<EbitdaDataPointModel>? revenue;

  const FinancialsModel({
    this.ebitda,
    this.revenue,
  });

  factory FinancialsModel.fromJson(Map<String, dynamic> json) =>
      FinancialsModel(
        ebitda: json['ebitda'] != null
            ? (json['ebitda'] as List<dynamic>)
                .map((e) => EbitdaDataPointModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : null,
        revenue: json['revenue'] != null
            ? (json['revenue'] as List<dynamic>)
                .map((e) => EbitdaDataPointModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
        'ebitda': ebitda?.map((e) => e.toJson()).toList(),
        'revenue': revenue?.map((e) => e.toJson()).toList(),
      };
}

class IssuerDetailsModel {
  final String? issuerName;
  final String? typeOfIssuer;
  final String? sector;
  final String? industry;
  final String? issuerNature;
  final String? cin;
  final String? leadManager;
  final String? registrar;
  final String? debentureTrustee;

  const IssuerDetailsModel({
    this.issuerName,
    this.typeOfIssuer,
    this.sector,
    this.industry,
    this.issuerNature,
    this.cin,
    this.leadManager,
    this.registrar,
    this.debentureTrustee,
  });

  factory IssuerDetailsModel.fromJson(Map<String, dynamic> json) =>
      IssuerDetailsModel(
        issuerName: json['issuer_name'] as String?,
        typeOfIssuer: json['type_of_issuer'] as String?,
        sector: json['sector'] as String?,
        industry: json['industry'] as String?,
        issuerNature: json['issuer_nature'] as String?,
        cin: json['cin'] as String?,
        leadManager: json['lead_manager'] as String?,
        registrar: json['registrar'] as String?,
        debentureTrustee: json['debenture_trustee'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'issuer_name': issuerName,
        'type_of_issuer': typeOfIssuer,
        'sector': sector,
        'industry': industry,
        'issuer_nature': issuerNature,
        'cin': cin,
        'lead_manager': leadManager,
        'registrar': registrar,
        'debenture_trustee': debentureTrustee,
      };

  IssuerDetailsEntity toEntity() => IssuerDetailsEntity(
        issuerName: issuerName,
        typeOfIssuer: typeOfIssuer,
        sector: sector,
        industry: industry,
        issuerNature: issuerNature,
        cin: cin,
        leadManager: leadManager,
        registrar: registrar,
        debentureTrustee: debentureTrustee,
      );
}

class ProsConsModel {
  final List<String> pros;
  final List<String> cons;

  const ProsConsModel({
    required this.pros,
    required this.cons,
  });

  factory ProsConsModel.fromJson(Map<String, dynamic> json) =>
      ProsConsModel(
        pros: (json['pros'] as List<dynamic>).cast<String>(),
        cons: (json['cons'] as List<dynamic>).cast<String>(),
      );

  Map<String, dynamic> toJson() => {
        'pros': pros,
        'cons': cons,
      };

  ProsCons toEntity() => ProsCons(
        pros: pros,
        cons: cons,
      );
}