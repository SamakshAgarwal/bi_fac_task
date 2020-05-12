import 'package:flutter/material.dart';

class PhotosGridView extends StatefulWidget {
  final services;
  final int tab;

  PhotosGridView({@required this.services, @required this.tab});

  @override
  _PhotosGridViewState createState() => _PhotosGridViewState();
}

class _PhotosGridViewState extends State<PhotosGridView> {
  var services;
  ScrollController scrollController;
  int tab;

  @override
  void initState() {
    services = widget.services;
    scrollController = ScrollController()..addListener(scrollListener);
    tab = widget.tab;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: tab == 0 ? services.getPlants() : services.getPets(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Center(child: CircularProgressIndicator());
          return GridView.builder(
              controller: scrollController,
              padding: EdgeInsets.all(8),
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio:
                      (MediaQuery.of(context).size.width / 2 - 24) /
                          (((MediaQuery.of(context).size.width / 2 - 24) * 1.5 +
                              24))),
              itemBuilder: (context, index) => Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
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
                                          (MediaQuery.of(context).size.width /
                                                      2 -
                                                  24) *
                                              1.5,
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          24,
                                      fit: BoxFit.fill,
                                    )),
                                Flexible(
                                    child: Text(
                                  '${snapshot.data[index]['title']}',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(.5)),
                                ))
                              ],
                            ),
                          ),
                        ),
                        if (index == snapshot.data.length - 1 &&
                            snapshot.data.length % 10 == 0)
                          Text('Loading...')
                      ],
                    ),
                  ));
        });
  }

  scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        tab == 0 ? services.increasePlantPage() : services.increasePetPage();
      });
    }
  }
}
