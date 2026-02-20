class Stock {
  final String ticker;
  final String price;
  final String changeAmount;
  final String changePercentage;
  final String volume;

  const Stock({
    required this.ticker,
    required this.price,
    required this.changeAmount,
    required this.changePercentage,
    required this.volume,
  });
}
