class OfferModel {
  final String id;
  final String title;
  final String description;
  final String code;
  final String discount;
  final DateTime expiryDate;
  final String imageUrl;

  OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.discount,
    required this.expiryDate,
    required this.imageUrl,
  });
}
