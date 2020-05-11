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

  Widget plantGridView(Services services) {
    return FutureBuilder(
        future: services.getPlants(),
        builder: (context, snapshot) {
          if (snapshot.data == null) return CircularProgressIndicator();
          return GridView.builder(
              controller: plantsScrollController
                ..addListener(() {
                  if (plantsScrollController.offset >=
                          plantsScrollController.position.maxScrollExtent -
                              100 &&
                      !plantsScrollController.position.outOfRange &&
                      currentIndex == 0) {
                    setState(() {
                      services.increasePlantPage();
                    });
                  }
                }),
              padding: EdgeInsets.all(8),
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio:
                      (MediaQuery.of(context).size.width / 2 - 24) /
                          (((MediaQuery.of(context).size.width / 2 - 24) * 1.5 +
                              20))),
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              '${snapshot.data[index]['url']}',
                              height:
                                  (MediaQuery.of(context).size.width / 2 - 24) *
                                      1.5,
                              width: MediaQuery.of(context).size.width / 2 - 24,
                              fit: BoxFit.fill,
                            )),
                        Flexible(
                            child: Text(
                          '${snapshot.data[index]['title']}',
                          style: TextStyle(color: Colors.black.withOpacity(.5)),
                        ))
                      ],
                    ),
                  ));
        });
  }

  Widget petsGridView(Services services) {
    return FutureBuilder(
        future: services.getPets(),
        builder: (context, snapshot) {
          if (snapshot.data == null) return CircularProgressIndicator();
          return GridView.builder(
              controller: petsScrollController
                ..addListener(() {
                  if (petsScrollController.offset >=
                          petsScrollController.position.maxScrollExtent &&
                      !petsScrollController.position.outOfRange &&
                      currentIndex == 1) {
                    setState(() {
                      Services().increasePetPage();
                    });
                  }
                }),
              padding: EdgeInsets.all(8),
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio:
                      (MediaQuery.of(context).size.width / 2 - 24) /
                          (((MediaQuery.of(context).size.width / 2 - 24) * 1.5 +
                              20))),
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              '${snapshot.data[index]['url']}',
                              height:
                                  (MediaQuery.of(context).size.width / 2 - 24) *
                                      1.5,
                              width: MediaQuery.of(context).size.width / 2 - 24,
                              fit: BoxFit.fill,
                            )),
                        Flexible(
                            child: Text(
                          '${snapshot.data[index]['title']}',
                          style: TextStyle(color: Colors.black.withOpacity(.5)),
                        ))
                      ],
                    ),
                  ));
        });
  }
}
