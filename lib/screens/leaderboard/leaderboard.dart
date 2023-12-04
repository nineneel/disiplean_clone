import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  /// dummy data leaderboard
  final List<Map<String, dynamic>> leaderboardData = [
    {'rank': 1, 'name': 'Alex', 'score': 100},
    {'rank': 2, 'name': 'Henry', 'score': 100},
    {'rank': 3, 'name': 'Niel', 'score': 80},
    {'rank': 4, 'name': 'Cangrandhi', 'score': 50},
    {'rank': 5, 'name': 'John', 'score': 30},
    {'rank': 6, 'name': 'Doel', 'score': 10},
    {'rank': 7, 'name': 'Jane', 'score': 90},
    {'rank': 8, 'name': 'Bob', 'score': 70},
    {'rank': 9, 'name': 'Alice', 'score': 60},
    {'rank': 10, 'name': 'Eve', 'score': 40},
    {'rank': 11, 'name': 'Michael', 'score': 20},
    {'rank': 12, 'name': 'Sarah', 'score': 85},
    {'rank': 13, 'name': 'David', 'score': 75},
    {'rank': 14, 'name': 'Emily', 'score': 55},
    {'rank': 15, 'name': 'Chris', 'score': 45},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboard'),
          backgroundColor: const Color(0xFF6D9773),
          titleTextStyle: smNormalTextStyle.copyWith(
              color: Colors.white,
              fontSize: 18
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: NestedScrollView(
            headerSliverBuilder: (context, isScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  collapsedHeight: 170,
                  flexibleSpace: Column(
                    children: [
                      Text(
                        'Berikut ini adalah merupakan peringkat lokasi yang mendapatkan score tertinggi. '
                            'Lokasi dengan peringkat tertinggi akan mendapatkan hadiah setiap akhir bulan.',
                        style: smNormalTextStyle.copyWith(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 15),
                      buildDateIntervalContainer('Januari 2023'),
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  delegate: MyDelegate(
                    buildLeaderboardHeader(),
                  ),
                  floating: true,
                  pinned: true,
                ),
              ];
            },
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    // Use ListView.builder to build leaderboard items
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: leaderboardData.length,
                      itemBuilder: (context, index) {
                        leaderboardData.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
                        final item = leaderboardData[index];
                        String name = item['name'] as String;
                        int score = item['score'];
                        int rank = 1 + index++;
                        return buildLeaderboardItem(rank, name, score);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // return SafeArea(
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Leaderboard'),
    //       backgroundColor: const Color(0xFF6D9773),
    //       titleTextStyle: smNormalTextStyle.copyWith(color: Colors.white, fontSize: 18),
    //     ),
    //     body: Padding(
    //       padding: const EdgeInsets.all(20),
    //       child: ListView(
    //         children: [
    //           Text(
    //             'Berikut ini adalah contoh leaderboard dengan data dummy untuk visualisasi penerapan '
    //             'fitur nested scroll view',
    //             style: smNormalTextStyle.copyWith(
    //               fontSize: 16,
    //             ),
    //           ),
    //           const SizedBox(height: 10),
    //           buildDateIntervalContainer('01 Jan 2023 - 07 Jan 2023'),
    //           const SizedBox(height: 20),
    //           buildLeaderboardHeader(),
    //           buildLeaderboardItem(1, 'Alex', 100),
    //           buildLeaderboardItem(2, 'Henry', 100),
    //           buildLeaderboardItem(3, 'Niel', 80),
    //           buildLeaderboardItem(4, 'Cangrandhi', 50),
    //           buildLeaderboardItem(5, 'John', 30),
    //           buildLeaderboardItem(6, 'Doel', 10),
    //           // Add more leaderboard items as needed
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget buildDateIntervalContainer(String dateInterval) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xFF6D9773),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.schedule_outlined,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 15),
          Text(
            dateInterval,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildLeaderboardHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        color: Color(0xFF6D9773),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Rank',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Nama',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Score',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLeaderboardItem(int rank, String name, int score) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(rank.toString()),
          Text(name),
          Text(score.toString()),
        ],
      ),
    );
  }

}

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.widget);
  final Widget widget;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: widget,
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
