/// Анимированные картинки по HTTPS (нужен `INTERNET` в AndroidManifest).
const List<String> kY2KGifPool = [
  'https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif',
  'https://media.giphy.com/media/ICOgUNjpvO0PC/giphy.gif',
  'https://media.giphy.com/media/l0HlyQetfVt0AboX6/giphy.gif',
  'https://media.giphy.com/media/26BRuo6sLetdllBRQ/giphy.gif',
  'https://media.giphy.com/media/3o7abKhOpu0NwenH3O/giphy.gif',
];

String kY2KGifAt(int index) => kY2KGifPool[index % kY2KGifPool.length];

class ProductSeedRow {
  const ProductSeedRow({
    required this.title,
    required this.brand,
    required this.flavor,
    required this.volumeMl,
    required this.price,
    required this.description,
    required this.ingredients,
    required this.eraNote,
    required this.imageLabel,
    required this.gifUrl,
    this.stock = 20,
  });

  final String title;
  final String brand;
  final String flavor;
  final int volumeMl;
  final double price;
  final String description;
  final String ingredients;
  final String eraNote;
  final String imageLabel;
  final String gifUrl;
  final int stock;
}

final List<ProductSeedRow> productsSeed = [
  ProductSeedRow(
    title: 'Burn (Classic) — «как на дискотеке»',
    brand: 'Burn',
    flavor: 'Classic',
    volumeMl: 250,
    price: 89,
    description:
        'Ранний Burn с «кислой» классикой и ощущением «интернет-кафе 2005». Для тех, кто помнит, что «энергия» — это ещё и музыка громче соседей.',
    ingredients:
        'вода, сахар, кофеин, таурин, витамины группы B, регулятор кислотности, ароматизаторы',
    eraNote: '2000-е: яркая банка, клубная эстетика',
    imageLabel: 'BURN CLASSIC',
    gifUrl: kY2KGifAt(0),
  ),
  ProductSeedRow(
    title: 'Red Bull Energy Drink (Original)',
    brand: 'Red Bull',
    flavor: 'Original',
    volumeMl: 250,
    price: 129,
    description:
        'Классика «серебряно-синей» эпохи. Вкус как у старых сайтов: знакомо, предсказуемо, надёжно.',
    ingredients:
        'вода, сахар, глюкоза, кофеин, таурин, инозитол, ниацин, пантотеновая кислота, B6, B12, ароматизаторы',
    eraNote: '2000-е: «It gives you wings» везде',
    imageLabel: 'RED BULL',
    gifUrl: kY2KGifAt(1),
  ),
  ProductSeedRow(
    title: 'Monster Energy (Green)',
    brand: 'Monster',
    flavor: 'Green',
    volumeMl: 500,
    price: 149,
    description:
        'Зелёный Monster — как старый форум: много текста, много энергии, мало сна.',
    ingredients:
        'вода, сахар, глюкоза, таурин, панакс женьшень, L-карнитин, кофеин, инозитол, гуарана, B2, B3, B6, B12',
    eraNote: '2000-е: «M» на всём подряд',
    imageLabel: 'MONSTER M',
    gifUrl: kY2KGifAt(2),
  ),
  ProductSeedRow(
    title: 'Rockstar Original',
    brand: 'Rockstar',
    flavor: 'Original',
    volumeMl: 500,
    price: 139,
    description:
        'Rockstar в оригинале — как mp3-плеер: громко, просто, без лишних «микросервисов».',
    ingredients:
        'вода, сахар, кофеин, таурин, инозитол, ниацин, пантотеновая кислота, B6, B12, ароматизаторы',
    eraNote: '2000-е: звезда на банке = статус',
    imageLabel: 'ROCKSTAR STAR',
    gifUrl: kY2KGifAt(3),
  ),
  ProductSeedRow(
    title: 'XS Power Drink (Citrus)',
    brand: 'XS',
    flavor: 'Citrus',
    volumeMl: 250,
    price: 119,
    description:
        'Цитрус XS — «как реклама на баннере»: кислинка, яркость, и ощущение, что ты «в теме».',
    ingredients:
        'газированная вода, кофеин, таурин, подсластители, витамины, ароматизаторы',
    eraNote: '2000-е: много «витаминов» на этикетке',
    imageLabel: 'XS CITRUS',
    gifUrl: kY2KGifAt(4),
  ),
  ProductSeedRow(
    title: 'Battery Energy Drink (Original)',
    brand: 'Battery',
    flavor: 'Original',
    volumeMl: 330,
    price: 99,
    description:
        'Battery Original — финский минимализм до модного минимализма: просто работает.',
    ingredients: 'вода, сахар, кофеин, таурин, ниацин, B6, B12, ароматизаторы',
    eraNote: '2000-е: «просто банка с зарядом»',
    imageLabel: 'BATTERY',
    gifUrl: kY2KGifAt(5),
  ),
  ProductSeedRow(
    title: 'Shark Energy (Classic)',
    brand: 'Shark',
    flavor: 'Classic',
    volumeMl: 250,
    price: 79,
    description:
        'Shark Classic — как старый каталог товаров: без глянца, зато честно «энергетик».',
    ingredients: 'вода, сахар, кофеин, таурин, витамины, ароматизаторы',
    eraNote: '2000-е: «акула» на полке магазина у дома',
    imageLabel: 'SHARK',
    gifUrl: kY2KGifAt(6),
  ),
  ProductSeedRow(
    title: 'Effect Energy (Double)',
    brand: 'Effect',
    flavor: 'Double',
    volumeMl: 500,
    price: 109,
    description:
        'Effect Double — «двойной» как двойной клик: быстрее, сильнее, проще.',
    ingredients: 'вода, сахар, кофеин, таурин, витамины, ароматизаторы',
    eraNote: '2000-е: «DOUBLE» крупными буквами',
    imageLabel: 'EFFECT DOUBLE',
    gifUrl: kY2KGifAt(7),
  ),
  ProductSeedRow(
    title: 'Hype Energy (Mango)',
    brand: 'Hype',
    flavor: 'Mango',
    volumeMl: 500,
    price: 119,
    description:
        'Hype Mango — как фоновая музыка на сайте: сладко, навязчиво, но цепляет.',
    ingredients: 'вода, сахар, кофеин, таурин, витамины, ароматизаторы',
    eraNote: '2000-е: «HYPE» как культура форумов',
    imageLabel: 'HYPE MANGO',
    gifUrl: kY2KGifAt(8),
  ),
  ProductSeedRow(
    title: 'Adrenaline Rush (Original)',
    brand: 'Adrenaline Rush',
    flavor: 'Original',
    volumeMl: 250,
    price: 89,
    description:
        'Adrenaline Rush — как аватарка с огоньком: коротко, резко, по делу.',
    ingredients: 'вода, сахар, кофеин, таурин, витамины, ароматизаторы',
    eraNote: '2000-е: «RUSH» в названии = скорость',
    imageLabel: 'ADR RUSH',
    gifUrl: kY2KGifAt(9),
  ),
  ProductSeedRow(
    title: 'Lost Energy (Mystery)',
    brand: 'Lost',
    flavor: 'Mystery',
    volumeMl: 355,
    price: 139,
    description:
        'Lost Mystery — как скрытая страница сайта: непонятно что внутри, но интересно.',
    ingredients:
        'вода, сахар/глюкоза, кофеин, таурин, витамины, «секретная смесь» (ароматизаторы)',
    eraNote: '2000-е: линейка «как у сериала»',
    imageLabel: 'LOST MYSTERY',
    gifUrl: kY2KGifAt(10),
  ),
  ProductSeedRow(
    title: 'Full Throttle (Original Citrus)',
    brand: 'Full Throttle',
    flavor: 'Citrus',
    volumeMl: 473,
    price: 149,
    description:
        'Full Throttle Citrus — как пиксельная кнопка «BUY»: грубо, заметно, работает.',
    ingredients: 'вода, сахар, кофеин, таурин, витамины, ароматизаторы',
    eraNote: '2000-е: «американский» размер банки',
    imageLabel: 'FULL THROTTLE',
    gifUrl: kY2KGifAt(11),
  ),
  ProductSeedRow(
    title: 'SoBe Adrenaline Rush (Citrus)',
    brand: 'SoBe',
    flavor: 'Citrus',
    volumeMl: 473,
    price: 159,
    description:
        'SoBe Adrenaline — как бутылка с ящерицей на обоях: странно, ярко, запоминается.',
    ingredients:
        'чайный экстракт, кофеин, таурин, сахар, ароматизаторы, витамины',
    eraNote: '2000-е: дизайн «как реклама напитка»',
    imageLabel: 'SOBE LIZARD',
    gifUrl: kY2KGifAt(12),
  ),
  ProductSeedRow(
    title: 'BURN Ice (Cool)',
    brand: 'Burn',
    flavor: 'Ice',
    volumeMl: 250,
    price: 95,
    description:
        'Burn Ice — «охлаждение» как звук модема: не всем нравится, но эффект есть.',
    ingredients: 'вода, сахар, кофеин, таурин, витамины, ароматизаторы',
    eraNote: '2000-е: «ICE» = свежесть',
    imageLabel: 'BURN ICE',
    gifUrl: kY2KGifAt(13),
  ),
  ProductSeedRow(
    title: 'Monster Assault (кола-стиль)',
    brand: 'Monster',
    flavor: 'Cola',
    volumeMl: 500,
    price: 159,
    description:
        'Assault — как тёмная тема Windows XP: кола-нотка, дерзость, «не для всех».',
    ingredients: 'вода, сахар, кофеин, таурин, витамины, ароматизаторы',
    eraNote: '2000-е: камуфляж/«военный» маркетинг',
    imageLabel: 'MONSTER CAMO',
    gifUrl: kY2KGifAt(14),
  ),
  ProductSeedRow(
    title: 'Red Bull Sugarfree (ранний стиль)',
    brand: 'Red Bull',
    flavor: 'Sugarfree',
    volumeMl: 250,
    price: 139,
    description:
        'Sugarfree — «облегчённая версия сайта»: меньше сахара, но тот же драйв.',
    ingredients: 'вода, подсластители, кофеин, таурин, витамины, ароматизаторы',
    eraNote: '2000-е: диетические линейки набирают ход',
    imageLabel: 'RB SUGARFREE',
    gifUrl: kY2KGifAt(15),
  ),
];
