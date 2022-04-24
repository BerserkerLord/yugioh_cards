class CardImage{
  int? id;
  String? imageUrl;
  String? imageUrlSmall;

  CardImage({
    this.id,
    this.imageUrl,
    this.imageUrlSmall
  });



  factory CardImage.fromMap(Map<String, dynamic> map){
    return CardImage(
      id: map['id'],
      imageUrl: map['image_url'],
      imageUrlSmall: map['image_url_small']
    );
  }
}