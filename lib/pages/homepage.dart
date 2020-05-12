import 'package:bifactask/components/PhotosGridView.dart';
import 'package:bifactask/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List tabTitles = ['Plants', 'Pets'];
  TabController tabController;
  ScrollController plantsScrollController = ScrollController();
  ScrollController petsScrollController = ScrollController();
  int currentIndex = 0;

  @override
  void initState() {
    tabController = TabController(
      length: tabTitles.length,
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Services(),
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, kToolbarHeight + 20),
            child: Container(
              padding: EdgeInsets.all(3),
              margin: EdgeInsets.symmetric(horizontal: 64, vertical: 16),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              child: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  indicatorColor: Colors.white,
                  onTap: (index) {
                    currentIndex = index;
                  },
                  indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  controller: tabController,
                  tabs: tabTitles
                      .map((title) => Tab(
                            text: title,
                          ))
                      .toList()),
            ),
          ),
          body: Consumer<Services>(
            builder: (context, services, child) =>
                TabBarView(controller: tabController, children: [
              PhotosGridView(services: services, tab: 0),
              PhotosGridView(services: services, tab: 1)
            ]),
          ),
        ),
      ),
    );
  }
}
