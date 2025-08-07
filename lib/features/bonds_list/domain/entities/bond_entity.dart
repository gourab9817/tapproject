class BondEntity {
  final String logo;
  final String isin;
  final String rating;
  final String companyName;
  final List<String> tags;

  const BondEntity({
    required this.logo,
    required this.isin,
    required this.rating,
    required this.companyName,
    required this.tags,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BondEntity &&
          runtimeType == other.runtimeType &&
          logo == other.logo &&
          isin == other.isin &&
          rating == other.rating &&
          companyName == other.companyName &&
          tags.toString() == other.tags.toString();

  @override
  int get hashCode =>
      logo.hashCode ^
      isin.hashCode ^
      rating.hashCode ^
      companyName.hashCode ^
      tags.hashCode;

  @override
  String toString() {
    return 'BondEntity{logo: $logo, isin: $isin, rating: $rating, companyName: $companyName, tags: $tags}';
  }
}