class Company {
  final String symbol;
  final String name;
  final String description;
  final String marketCap;
  final String peRatio;
  final String dividendYield;
  final String sector;
  final String website;

  const Company({
    required this.symbol,
    required this.name,
    required this.description,
    required this.marketCap,
    required this.peRatio,
    required this.dividendYield,
    required this.sector,
    required this.website,
  });
}
