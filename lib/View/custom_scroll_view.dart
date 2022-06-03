import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:screening_test/Model/dish.dart';
import 'package:intl/intl.dart';
import 'package:screening_test/View/ForSearchBarSliverDelegate.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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
  //final scrollDirection = Axis.vertical;
  final listViewKey = RectGetter.createGlobalKey();
  NumberFormat numberFormat = NumberFormat.decimalPattern("en_US");
  Map<int, dynamic> itemsKeys = {};
  late TextEditingController _textEditingController = TextEditingController();

  /// MARK: main build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RectGetter(
        key: listViewKey,
        child: NotificationListener<ScrollNotification>(
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            controller: _autoScrollController,
            slivers: [buildSliverAppBar(),
              SliverPersistentHeader(delegate: ForSearchBarSliverDelegate(
                maxHeight: 50,
                minHeight: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(0,15,0,0),
                        prefixIcon: Icon(
                          Icons.search
                        ),
                        hintText: 'Search...',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent, width: 32.0),
                            borderRadius: BorderRadius.circular(25.0)
                        )
                      ),
                    ),
                  ),
                )
              )),
              buildSliverListTile()],
          ),
          onNotification: (scrollNotification){
            List<int> visibleItems = getVisibleItemsIndex();
            _tabController.animateTo(visibleItems[0]);
            return false;
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _autoScrollController = AutoScrollController();
    _tabController = new TabController(length: _data.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _autoScrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // bool onScrollNotification (ScrollNotification scrollNotification){
  //   List<int> visibleItems = getVisibleItemsIndex();
  //   _tabController.animateTo(visibleItems[0]);
  //   return false;
  // }

  List<int> getVisibleItemsIndex() {
    // get ListView Rect
    Rect? rect = RectGetter.getRectFromKey(listViewKey);
    List<int> items = [];
    if (rect == null) return items;

    /// TODO Horizontal ScrollDirection
    // bool isHorizontalScroll = widget._axisOrientation == Axis.horizontal;
    bool isHorizontalScroll = false;
    itemsKeys.forEach((index, key) {
      Rect? itemRect = RectGetter.getRectFromKey(key);
      if (itemRect == null) return;
      // y 軸座越大，代表越下面
      // 如果 item 上方的座標 比 listView 的下方的座標 的位置的大 代表不在畫面中。
      // bottom meaning => The offset of the bottom edge of this widget from the y axis.
      // top meaning => The offset of the top edge of this widget from the y axis.
      //Change offset based on AxisOrientation [horizontal] [vertical]
      switch (isHorizontalScroll) {
        case true:
          if (itemRect.left > rect.right) return;
          // 如果 item 下方的座標 比 listView 的上方的座標 的位置的小 代表不在畫面中。
          if (itemRect.right < rect.left) return;
          break;
        default:
          if (itemRect.top > rect.bottom) return;
          // 如果 item 下方的座標 比 listView 的上方的座標 的位置的小 代表不在畫面中。
          if (itemRect.bottom <
              rect.top +
                  MediaQuery.of(context).viewPadding.top +
                  kToolbarHeight +
                  56) return;
      }

      items.add(index);
    });
    return items;
  }

  Future _scrollToIndex(int index) async {
    await _autoScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.begin);
    _autoScrollController.highlight(index);
  }

  Widget buildSliverAppBar() => SliverAppBar(
        backgroundColor: Colors.blueAccent,
        expandedHeight: 200,
        pinned: true,
        //title: Text("Insert Restaurant Name"),
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          title: Text("Insert Restaurant Name"),
          titlePadding: EdgeInsets.only(bottom: 64),
          background:
          Opacity(
            opacity: 1.0,
            child: Image.asset(
              'assets/images/image.png',
              fit: BoxFit.cover,
            ),
          ),
          centerTitle: true,
        ),
        bottom: TabBar(
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
            tabs: _data
                .map(
                  (DishSection dish) => Tab(text: dish.title),
                )
                .toList()),
      );

  Widget buildSliverListTile() => SliverList(
        delegate: SliverChildListDelegate(
          List.generate(_data.length, (index) {
            itemsKeys[index] = RectGetter.createGlobalKey();
            return buildItem(index);
          }),
        ),
      );

  Widget buildItem(int index) {
    dynamic category = _data[index];
    return Column(
      children: [
        RectGetter(
          /// when announce GlobalKey，we can use RectGetter.getRectFromKey(key) to get Rect
          /// 宣告 GlobalKey，之後可以 RectGetter.getRectFromKey(key) 的方式獲得 Rect
          key: itemsKeys[index],
          child: AutoScrollTag(
            key: ValueKey(index),
            index: index,
            controller: _autoScrollController,
            child: buildCategoryAndDish(category, index),
          ),
        ),
      ],
    );
  }

  Widget buildCategoryAndDish(dynamic object, int index) => Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                object.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          for (var dish in _data[index].dishes)
            ListTile(
              contentPadding: const EdgeInsets.only(left: 16),
              //leading: Text("\$${dish.price}",maxLines: 1),
              title: Text(
                dish.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dish.description),
                  Text("${numberFormat.format(dish.price)} VND",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Divider()
                ],
              ),
              isThreeLine: true,
            ),
        ],
      );



  ///MARK: DATA
  final List<DishSection> _data = <DishSection>[
    DishSection(title: "Most Popular", dishes: [
      Dish(
          name: "Bun Bo Hue",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          price: 40000),
      Dish(
          name: "Com Tam",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          price: 40000),
      Dish(
          name: "Pho Bo",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          price: 50000),
    ]),
    DishSection(title: "Lunch Combination", dishes: [
      Dish(
          name: "Com Ca Kho To",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          price: 70000),
      Dish(
          name: "Com Canh Chua Ca ",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          price: 70000),
      Dish(
          name: "Com Thit Kho Trung",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          price: 80000),
    ]),
    DishSection(title: "Sandwiches", dishes: [
      Dish(
          name: "Banh Mi Thit Nuong",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          price: 30000),
      Dish(
          name: "Banh Mi Op La",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          price: 20000),
      Dish(
          name: "Banh Mi Cha Lua",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          price: 25000),
    ]),
    DishSection(title: "Desserts", dishes: [
      Dish(
          name: "Vanilla Ice Cream",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          price: 30000),
      Dish(
          name: "Che Thap Cam",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          price: 25000),
      Dish(
          name: "Sua Tuoi Tran Chau Duong Den",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          price: 50000),
      Dish(
          name: "Hong Tra Machiato",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          price: 50000),
      Dish(
          name: "Sua Chua Tran Chau Duong Den",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          price: 50000)
    ])
  ];
}



