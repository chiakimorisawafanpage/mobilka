import 'products_seed.dart';

/// Energy drinks scraped from https://sweet-shop.si/en/14-energy-drinks
/// Images hosted on sweet-shop.si CDN.
final List<ProductSeedRow> energyDrinksSeed = [
  const ProductSeedRow(
    title: 'Monster Energy — Pacific Punch',
    brand: 'Monster',
    flavor: 'Pacific Punch',
    volumeMl: 500,
    price: 299,
    description:
        'Pacific Punch combines diverse classic flavors: notes of apple, orange, raspberry, cherry, pineapple, and passion fruit. These fruits are perfectly blended with a little bit of what you love about Monster. This juice will not only rehydrate you but also give you an energy boost.',
    ingredients:
        'вода, сахар, сок (яблоко, апельсин, малина, вишня, ананас, маракуйя), кофеин, таурин, витамины группы B',
    eraNote: 'Juice Monster — фруктовый удар из линейки Punch',
    imageLabel: 'PACIFIC PUNCH',
    gifUrl:
        'https://sweet-shop.si/3360-large_default/monster-energy-pacific-punch-500-ml.jpg',
    stock: 25,
  ),
  const ProductSeedRow(
    title: 'Monster Energy — Ultra Black',
    brand: 'Monster',
    flavor: 'Ultra Black',
    volumeMl: 500,
    price: 297,
    description:
        'Enter the dark side of refreshment with Monster Energy Ultra Black! A mysterious combination of the classic punch of Monster Energy and the deep dark notes of black cherries. Ultra Black is the perfect companion for those who crave energy without compromising on taste.',
    ingredients:
        'газированная вода, кофеин, таурин, вишнёвый экстракт, витамины B3, B6, B12, подсластители',
    eraNote: 'Ultra серия — без сахара, максимум вкуса',
    imageLabel: 'ULTRA BLACK',
    gifUrl:
        'https://sweet-shop.si/3190-large_default/monster-energy-ultra-black-500ml-eu.jpg',
    stock: 18,
  ),
  const ProductSeedRow(
    title: 'Monster Energy — Rehab Lemonade',
    brand: 'Monster',
    flavor: 'Rehab Lemonade',
    volumeMl: 500,
    price: 249,
    description:
        'Monster Rehab Tea Lemonade: Refresh, rehydrate, invigorate! A killer blend of tea, lemonade, electrolytes, and the badass Monster Rehab energy mix. REHABILITATE THE BEAST!',
    ingredients:
        'вода, чайный экстракт, лимонный сок, сахар, электролиты, кофеин, таурин, витамины',
    eraNote: 'Rehab — для восстановления после бессонной ночи',
    imageLabel: 'REHAB LEMONADE',
    gifUrl:
        'https://sweet-shop.si/3361-large_default/monster-energy-rehab-lemonade-500ml-eu.jpg',
    stock: 30,
  ),
  const ProductSeedRow(
    title: 'Monster Energy — Ultra Violet',
    brand: 'Monster',
    flavor: 'Ultra Violet',
    volumeMl: 500,
    price: 249,
    description:
        'Welcome to the 70s psychedelic vibe! Ultra Violet is refreshing, with a sweet and tangy grape flavor powered by the Monster Energy blend. Jump on this purple monster for a wild ride! UNLEASH THE ULTRA BEAST!',
    ingredients:
        'газированная вода, кофеин, таурин, виноградный ароматизатор, витамины B3, B6, B12, подсластители',
    eraNote: 'Ultra Violet — виноградный взрыв без сахара',
    imageLabel: 'ULTRA VIOLET',
    gifUrl:
        'https://sweet-shop.si/3089-large_default/monster-energy-ultra-violet-500ml-eu.jpg',
    stock: 22,
  ),
  const ProductSeedRow(
    title: 'Monster Energy — Ripper',
    brand: 'Monster',
    flavor: 'Ripper',
    volumeMl: 500,
    price: 359,
    description:
        '"The Juice is Loose"... A killer combo of tropical juices infused with the original taste of Monster, topped off with a full load of the original Monster Energy blend. Banzai! 20%% juice — 100%% Monster!',
    ingredients:
        'вода, сахар, тропические соки, кофеин, таурин, женьшень, гуарана, витамины',
    eraNote: 'Juice Monster — тропический рай',
    imageLabel: 'RIPPER',
    gifUrl:
        'https://sweet-shop.si/3086-large_default/monster-energy-ripper-500ml-uk.jpg',
    stock: 15,
  ),
  const ProductSeedRow(
    title: 'Monster Energy — Ultra Peachy Keen',
    brand: 'Monster',
    flavor: 'Peachy Keen',
    volumeMl: 500,
    price: 248,
    description:
        'Summer of love — carefree fun and unlimited possibilities. Everything is peachy keen when you sip Ultra Peachy Keen. Sugar-free, juicy taste, and Monster Energy blend from our secret stash.',
    ingredients:
        'газированная вода, кофеин, таурин, персиковый ароматизатор, витамины B3, B6, B12, подсластители',
    eraNote: 'Ultra Peachy Keen — персиковое лето',
    imageLabel: 'PEACHY KEEN',
    gifUrl:
        'https://sweet-shop.si/3354-large_default/monster-energy-ultra-peachy-keen-500ml-eu.jpg',
    stock: 20,
  ),
  const ProductSeedRow(
    title: 'Monster Energy — Bad Apple',
    brand: 'Monster',
    flavor: 'Bad Apple',
    volumeMl: 500,
    price: 199,
    description:
        'Juiced Monster Bad Apple is like nothing you have ever tasted. A crisp, dry apple flavor that is not too sweet and becomes smooth. Sinfully delicious taste and full of our legendary Monster Energy blend. Unleash the beast!',
    ingredients:
        'вода, сахар, яблочный сок, кофеин, таурин, витамины группы B, ароматизаторы',
    eraNote: 'Bad Apple — запретный плод энергии',
    imageLabel: 'BAD APPLE',
    gifUrl:
        'https://sweet-shop.si/3088-large_default/monster-energy-bad-apple-500ml-eu.jpg',
    stock: 12,
  ),
  const ProductSeedRow(
    title: 'Monster Energy — Nitro',
    brand: 'Monster',
    flavor: 'Nitro',
    volumeMl: 500,
    price: 249,
    description:
        'One of the most closely guarded secrets in energy drinks! Infused with nitrous oxide, creating a smooth, creamy texture. With a full dose of Monster classic energy blend, it provides the boost you need! UNLEASH THE NITRO BEAST!',
    ingredients:
        'газированная вода, закись азота, кофеин, таурин, сахар, витамины, ароматизаторы',
    eraNote: 'Nitro — кремовая текстура с азотом',
    imageLabel: 'NITRO',
    gifUrl:
        'https://sweet-shop.si/3362-large_default/monster-energy-nitro-500ml-eu.jpg',
    stock: 16,
  ),
  const ProductSeedRow(
    title: 'Monster Energy — Ultra Watermelon',
    brand: 'Monster',
    flavor: 'Ultra Watermelon',
    volumeMl: 500,
    price: 249,
    description:
        'Under a sky illuminated by fireworks, good music and even better friends — this is Ultra Watermelon. Light, refreshing, and sugar-free with a crisp watermelon taste powered by the Monster Energy blend.',
    ingredients:
        'газированная вода, кофеин, таурин, арбузный ароматизатор, витамины B3, B6, B12, подсластители',
    eraNote: 'Ultra Watermelon — арбузная свежесть',
    imageLabel: 'ULTRA WATERMELON',
    gifUrl:
        'https://sweet-shop.si/3205-large_default/monster-energy-ultra-watermelon-500ml-eu.jpg',
    stock: 28,
  ),
  const ProductSeedRow(
    title: 'Rockstar Energy — Original',
    brand: 'Rockstar',
    flavor: 'Original',
    volumeMl: 500,
    price: 269,
    description:
        'Rockstar Original energy drink — designed for those who lead active lifestyles. A powerful blend of caffeine, taurine, B-vitamins, and ginseng. The signature gold and black can that has become an icon of energy culture.',
    ingredients:
        'газированная вода, сахар, кофеин, таурин, женьшень, гуарана, инозитол, витамины B2, B3, B6, B12',
    eraNote: 'Rockstar Original — классика рок-энергетики',
    imageLabel: 'ROCKSTAR',
    gifUrl:
        'https://sweet-shop.si/2926-large_default/rockstar-energy-drink-original-500ml.jpg',
    stock: 20,
  ),
];
