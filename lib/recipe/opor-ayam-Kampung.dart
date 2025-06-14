class Recipe {
  final String image;
  final String title;
  final String time;
  final String level;
  final String cal;
  final String descriptionMarkdown;
  final String rate;

  Recipe({
    required this.image,
    required this.title,
    required this.time,
    required this.level,
    required this.cal,
    required this.descriptionMarkdown,
    required this.rate,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      image: json['image'],
      title: json['title'],
      time: json['time'],
      level: json['level'],
      cal: json['cal'],
      descriptionMarkdown: json['description_markdown'],
      rate: json['rate'] ?? '0.0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'time': time,
      'level': level,
      'cal': cal,
      'description_markdown': descriptionMarkdown,
      'rate': rate,
    };
  }
}

// Contoh penggunaan
final oporAyam = Recipe(
  rate: "5.0",
  image: "assets/images/opor-ayam-Kampung.jpg",
  title: "Opor Ayam Kampung",
  time: "15",
  level: "Mudah",
  cal: "300",
  descriptionMarkdown: """# Opor Ayam Kampung
dari jeng hayoone

## Bahan-Bahan
- **1 ekor** ayam kampung
- **1 liter** santan dari 1 kelapa tua
- **7 lembar** daun salam
- **5 iris** lengkuas 2 batang serai
- **2 sendok makan** bumbi putih (ada diresep saya)
- **1 sendok makan** bumbu bawang merah (ada diresep saya)
- **1/2 sendok teh** ketumbar bubuk
- **1 sendok makan** garam
- **1 sendok teh** kaldu jamur
- **1/2 sendok teh** gula pasir
- Air
- Bawang goreng

## Cara Membuat

1. Siapkan ayam yang sudah dicuci bersih dan dipotong sesuai selera, rebus dengan panci  presto selama 35 menit.
2. Tuang santan dalam panci, (nyalakan apinya) masukan semua bumbu (tidak perlu ditumis karena bumbunya sudah matang), garam, kaldu jamur, ketumbar, gula, daun salam,lengkuas,aduk2 kemudian masukan ayam beserta kaldunya masak hingga mensdidih dan koreksi rasanya.
3. Jika sudah pas masak hingga kuah agak menyusut dan ayam empuk dan meresap dengan bumbu..
4. Matikan api dan pindahkan opor ke dalam mangkok, taburin dengan bawang goreng. Selamat mencoba""",
);
