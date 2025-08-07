class BondDetailEntity {
  final String logo;
  final String companyName;
  final String description;
  final String isin;
  final String status;
  final ProsCons? prosAndCons;
  final List<EbitdaDataPoint>? ebitdaHistory;
  final List<EbitdaDataPoint>? revenueHistory;
  final IssuerDetailsEntity? issuerDetails;

  const BondDetailEntity({
    required this.logo,
    required this.companyName,
    required this.description,
    required this.isin,
    required this.status,
    this.prosAndCons,
    this.ebitdaHistory,
    this.revenueHistory,
    this.issuerDetails,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BondDetailEntity &&
          runtimeType == other.runtimeType &&
          logo == other.logo &&
          companyName == other.companyName &&
          description == other.description &&
          isin == other.isin &&
          status == other.status &&
          prosAndCons == other.prosAndCons &&
          ebitdaHistory == other.ebitdaHistory &&
          revenueHistory == other.revenueHistory &&
          issuerDetails == other.issuerDetails;

  @override
  int get hashCode =>
      logo.hashCode ^
      companyName.hashCode ^
      description.hashCode ^
      isin.hashCode ^
      status.hashCode ^
      prosAndCons.hashCode ^
      ebitdaHistory.hashCode ^
      revenueHistory.hashCode ^
      issuerDetails.hashCode;
}

class EbitdaDataPoint {
  final String month;
  final double value;

  const EbitdaDataPoint({
    required this.month,
    required this.value,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EbitdaDataPoint &&
          runtimeType == other.runtimeType &&
          month == other.month &&
          value == other.value;

  @override
  int get hashCode => month.hashCode ^ value.hashCode;
}

class IssuerDetailsEntity {
  final String? issuerName;
  final String? typeOfIssuer;
  final String? sector;
  final String? industry;
  final String? issuerNature;
  final String? cin;
  final String? leadManager;
  final String? registrar;
  final String? debentureTrustee;

  const IssuerDetailsEntity({
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssuerDetailsEntity &&
          runtimeType == other.runtimeType &&
          issuerName == other.issuerName &&
          typeOfIssuer == other.typeOfIssuer &&
          sector == other.sector &&
          industry == other.industry &&
          issuerNature == other.issuerNature &&
          cin == other.cin &&
          leadManager == other.leadManager &&
          registrar == other.registrar &&
          debentureTrustee == other.debentureTrustee;

  @override
  int get hashCode =>
      issuerName.hashCode ^
      typeOfIssuer.hashCode ^
      sector.hashCode ^
      industry.hashCode ^
      issuerNature.hashCode ^
      cin.hashCode ^
      leadManager.hashCode ^
      registrar.hashCode ^
      debentureTrustee.hashCode;
}

class ProsCons {
  final List<String> pros;
  final List<String> cons;

  const ProsCons({
    required this.pros,
    required this.cons,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProsCons &&
          runtimeType == other.runtimeType &&
          pros.toString() == other.pros.toString() &&
          cons.toString() == other.cons.toString();

  @override
  int get hashCode => pros.hashCode ^ cons.hashCode;
}