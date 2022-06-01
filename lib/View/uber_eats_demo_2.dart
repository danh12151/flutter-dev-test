import 'package:flutter/material.dart';
import 'package:screening_test/Model/dish.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:vertical_scrollable_tabview/vertical_scrollable_tabview.dart';
import 'package:intl/intl.dart';

class UberEatsDemo extends StatefulWidget {
  UberEatsDemo({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _UberEatsDemoState createState() => _UberEatsDemoState();
}

class _UberEatsDemoState extends State<UberEatsDemo>
    with SingleTickerProviderStateMixin {
  late AutoScrollController _autoScrollController;
  late TabController _tabController;
  final scrollDirection = Axis.vertical;
  final appBarHeight = 160 - kToolbarHeight; //104
  NumberFormat numberFormat = NumberFormat.decimalPattern("en_US");

  bool isExpanded = true;
  bool get _isAppBarExpanded {
    return _autoScrollController.hasClients &&
        _autoScrollController.offset > (appBarHeight);
  }

  @override
  void initState() {
    // TODO: implement initState
    _autoScrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: scrollDirection,
    )..addListener(
          () => _isAppBarExpanded
          ? isExpanded != false
          ? setState(
            () {
          isExpanded = false;
        },
      )
          : {}
          : isExpanded != true
          ? setState(() {
        isExpanded = true;
      })
          : {},
    );
    _tabController = new TabController(length: _data.length, vsync: this);
    super.initState();
  }


  Future _scrollToIndex(int index) async {
    await _autoScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.begin);
    _autoScrollController.highlight(index);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VerticalScrollableTabView(
        tabController: _tabController,
        autoScrollController: _autoScrollController,
        listItemData: _data,
        verticalScrollPosition: VerticalScrollPosition.begin,
        eachItemChild: (object, index) =>
            /// Code for each element goes here
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text(_data[index].title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                ),
                for (var dish in _data[index].dishes)
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 16),
                    //leading: Text("\$${dish.price}",maxLines: 1),
                    title: Text(dish.name,style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dish.description),
                        Text("${numberFormat.format(dish.price)} VND", style: TextStyle(fontWeight: FontWeight.bold)),
                        Divider()
                      ],
                    ),
                    isThreeLine: true,
                  ),


              ],
            )
            //CategorySection(category: object as Category),
        ,
        slivers: [
          //_buildSliverAppbar()
          SliverAppBar(
            brightness: Brightness.light,
              title: PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: isExpanded ? 0 : 1,
                    child: Text(
                      "Restaurant name",
                      style: TextStyle(color: Colors.white),
                    )
                ),
              ),
            centerTitle: false,
            pinned: true,
            expandedHeight: 200.0,
            backgroundColor: Colors.blueAccent,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background:
                  Image.asset(
                'assets/images/image.png',
                fit: BoxFit.cover,
              ),
              title: PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: isExpanded ? 1 : 0,
                  child: Text(
                    "Restaurant name",
                    style: TextStyle(color: Colors.white,backgroundColor: Colors.black),
                  )
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: isExpanded ? 0.0 : 1,
                child: TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.cyan,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    indicatorWeight: 3.0,
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: Colors.black,
                    ),
                    onTap: (index) async {
                      _scrollToIndex(index);
                    },
                    tabs: _data.map((DishSection dish) => Tab(
                        text: dish.title),
                    ).toList()
                ),
              ),
            )
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => setState(() {}),
      //   tooltip: 'Increment Counter',
      //   child: Icon(Icons.add),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  ///MARK: DATA
  final List<DishSection> _data = <DishSection>[
    DishSection(title: "Most Popular", dishes: [
      Dish(name: "Bun Bo Hue", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", price: 40000
      ),
      Dish(name: "Com Tam", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", price: 40000),
      Dish(name: "Pho Bo", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", price: 50000),
    ]),
    DishSection(title: "Lunch Combination", dishes: [
      Dish(name: "Com Ca Kho To", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", price: 70000),
      Dish(name: "Com Canh Chua Ca ", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", price: 70000),
      Dish(name: "Com Thit Kho Trung", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", price: 80000),
    ]),
    DishSection(title: "Sandwiches", dishes: [
      Dish(name: "Banh Mi Thit Nuong", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", price: 30000),
      Dish(name: "Banh Mi Op La", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", price: 20000),
      Dish(name: "Banh Mi  Cha Lua", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", price: 25000),
    ]),
    DishSection(title: "Desserts", dishes: [
      Dish(name: "Vanilla Ice Cream", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", price: 30000),
      Dish(name: "Che Thap Cam",description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", price: 25000),
      Dish(name: "Sua Tuoi Tran Chau Duong Den", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", price: 50000),
      Dish(name: "Hong Tra Machiato", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", price: 50000),
      Dish(name: "Sua Chua Tran Chau Duong Den", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", price: 50000)
    ])
  ];
}
