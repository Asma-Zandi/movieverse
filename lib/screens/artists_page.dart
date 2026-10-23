import 'package:flutter/material.dart';

class ArtistsPage extends StatelessWidget {


  const ArtistsPage({super.key, });


  List<Map<String, String>> getArtistsList() {
    final List<Map<String, String>> rawData = [
      {'name': 'لئوناردو دیکاپریو', 'image': 'dycaprio.jpg'},
      {'name': 'برد پیت', 'image': 'bradley pitt.jpg'},
      {'name': 'کیلین مورفی', 'image': 'Cillian Murphy.jpg'},
      {'name': 'تام هاردی', 'image': 'Thomas Hardy.jpg'},
      {'name': 'اسکارلت جوهانسون', 'image': 'Scarlett Ingrid Johansson.jpg'},
      {'name': 'رابرت داونی جونیور', 'image': 'Robert John Downey Jr.jpg'},
      {'name': 'کریس همسورث', 'image': 'Christopher Hemsworth .jpg'},
      {'name': 'هنری کویل', 'image': 'Cavill.jpg'},
      {'name': 'آنجلینا جولی', 'image': 'Angelina Jolie .jpg'},
      {'name': 'جانی دپ', 'image': 'Depp.jpg'},
      {'name': 'کریستین بیل', 'image': 'Bale.jpg'},
      {'name': 'آن هاتاوی', 'image': 'Hathaway.jpg'},
      {'name': 'واکین فینیکس', 'image': 'Phoenix.jpg'},
      {'name': 'پدرو پاسکال', 'image': 'Pascal.jpg'},
      {'name': 'جنا اورتگا', 'image': 'Ortega.jpg'},
      {'name': 'تام هالند', 'image': 'Holland.jpg'},
      {'name': 'زندیا', 'image': 'Zendaya.jpg'},
      {'name': 'آنا د آرماس', 'image': 'Armas.jpg'},
      {'name': 'کیانو ریوز', 'image': 'Reeves.jpg'},
      {'name': 'مت دیمون', 'image': 'Damon.jpg'},
      {'name': 'رایان رینولدز', 'image': 'Reynolds.jpg'},
      {'name': 'رایان گاسلینگ', 'image': 'Gosling.jpg'},
      {'name': 'مارگو رابی', 'image': 'Robbie.jpg'},
      {'name': 'فلورنس پیو', 'image': 'Florence Pugh.jpg'},
      {'name': 'تیموتی شالامی', 'image': 'Chalamet.jpg'},
      {'name': 'آنتونی هاپکینز', 'image': 'Hopkins.jpg'},
      {'name': 'مورگان فریمن', 'image': 'Freeman.jpg'},
      {'name': 'بردلی کوپر', 'image': 'Cooper.jpg'},
      {'name': 'امیلیا کلارک', 'image': 'Clarke.jpg'},
      {'name': 'کیت هرینگتون', 'image': 'Harington.jpg'},
      {'name': 'برایان کرانستون', 'image': 'Cranston.jpg'},
      {'name': 'آرون پال', 'image': 'Paul.jpg'},
      {'name': 'بندیکت کامبربچ', 'image': 'Cumberbatch.jpg'},
      {'name': 'تام هنکس', 'image': 'Hanks.jpg'},
      {'name': 'هیو جکمن', 'image': 'Jackman.jpg'},
      {'name': 'پنه لوپه کروز', 'image': 'Penélope Cruz.jpg'},
      {'name': 'ناتالی پورتمن', 'image': 'Natalie Portman.jpg'},
      {'name': 'هریسون فورد', 'image': 'Harrison Ford.jpg'},
      {'name': 'آل پایچنو', 'image': 'Pacino.jpg'},
      {'name': 'رابرت دنیرو', 'image': 'De Niro.jpg'},
      {'name': 'مارلون براندو', 'image': 'Brando.jpg'},
      {'name': 'مریل استریپ', 'image': 'Streep.jpg'},
    ];

    final List<String> allNames = [
      'لئوناردو دیکاپریو', 'برد پیت', 'کیلین مورفی', 'تام هاردی',
      'اسکارلت جوهانسون', 'رابرت داونی جونیور', 'کریس همسورث', 'هنری کویل',
      'آنجلینا جولی', 'جانی دپ', 'کریستین بیل', 'آن هاتاوی',
      'واکین فینیکس', 'پدرو پاسکال', 'جنا اورتگا', 'تام هالند',
      'زندیا', 'آنا د آرماس', 'کیانو ریوز', 'مت دیمون',
      'رایان رینولدز', 'رایان گاسلینگ', 'مارگو رابی', 'فلورنس پیو',
      'تیموتی شالامی', 'آنتونی هاپکینز', 'مورگان فریمن', 'بردلی کوپر',
      'امیلیا کلارک', 'کیت هرینگتون', 'برایان کرانستون', 'آرون پال',
      'بندیکت کامبربچ', 'تام هنکس', 'هیو جکمن', 'پنه لوپه کروز',
      'ناتالی پورتمن', 'هریسون فورد', 'آل پاچینو', 'روبرت دنیرو',
      'مارلون براندو', 'مریل استریپ'
    ];

    return List.generate(allNames.length, (index) {
      String? imgName;
      if (index < rawData.length) {
        imgName = rawData[index]['image'];
      }
      return {
        'name': allNames[index],
        'image': imgName != null ? 'assets/images/$imgName' : '',
        'role': index % 2 == 0 ? 'بازیگر سینما' : 'بازیگر سریال',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final artists = getArtistsList();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // تعریف رنگ‌ها بر اساس تم تاریک یا روشن
    final Color primaryGreen = const Color(0xFF00E676);
    final Color backgroundColor = isDark ? const Color(0xFF0D1117) : const Color(0xFFF5F6FA);
    final Color appBarColor = isDark ? const Color(0xFF161D26) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF2D3142);
    final Color subTextColor = isDark ? Colors.white54 : const Color(0xFF9098B1);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'هنرمندان و بازیگران',
          style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: artists.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final artist = artists[index];
            final imagePath = artist['image']!;
            bool hasImage = imagePath.isNotEmpty;

            return Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: hasImage
                          ? Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>  Icon(
                          Icons.person_rounded,
                          color: primaryGreen,
                          size: 36,
                        ),
                      )
                          :  Icon(
                        Icons.person_rounded,
                        color: primaryGreen,
                        size: 36,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  artist['name']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  artist['role']!,
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 11,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}