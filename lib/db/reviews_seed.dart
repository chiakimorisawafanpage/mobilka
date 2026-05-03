class ReviewSeedRow {
  const ReviewSeedRow({
    required this.productTitle,
    required this.author,
    required this.rating,
    required this.text,
  });

  final String productTitle;
  final String author;
  final int rating;
  final String text;
}

const List<ReviewSeedRow> reviewsSeed = [
  ReviewSeedRow(
    productTitle: 'Red Bull Energy Drink (Original)',
    author: 'user_2003',
    rating: 5,
    text: 'как раньше в ларьке. вкус тот же. ностальгия 10/10',
  ),
  ReviewSeedRow(
    productTitle: 'Monster Energy (Green)',
    author: 'forum_king',
    rating: 4,
    text: 'много, зелёное, работает. после пары лаб по ТРПО — только так',
  ),
  ReviewSeedRow(
    productTitle: 'Burn (Classic) — «как на дискотеке»',
    author: 'disco_denis',
    rating: 5,
    text: 'пахнет «клубом» и старыми баннерами. мне норм',
  ),
  ReviewSeedRow(
    productTitle: 'Rockstar Original',
    author: 'mp3_player',
    rating: 3,
    text: 'сладковато, но бодрит. как старый winamp skin',
  ),
  ReviewSeedRow(
    productTitle: 'Lost Energy (Mystery)',
    author: 'xX_mystery_Xx',
    rating: 4,
    text: 'не понял вкус, но прикольно. как скрытая ссылка на сайте',
  ),
  ReviewSeedRow(
    productTitle: 'Monster Assault (кола-стиль)',
    author: 'tank_driver',
    rating: 2,
    text: 'кола-странность. но за дизайн +1',
  ),
];
