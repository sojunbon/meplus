import 'package:flutter/material.dart';
import 'package:meplus/screens/meplussrc/products/meproducts.dart';
import 'package:meplus/screens/meplussrc/package/package.dart';
import 'package:meplus/screens/meplussrc/category/mecard.dart';
//import 'package:meplus/screens/meplussrc/products/product_page.dart';
import 'package:meplus/routes.dart';
import 'package:meplus/models/category.dart';

class CategoryCard extends StatelessWidget {
  final Color begin;
  final Color end;
  final String categoryName;
  final String assetPath;

  CategoryCard(
      {Key key,
      this.controller,
      this.begin,
      this.end,
      this.categoryName,
      this.assetPath})
      :

        // Each animation defined here transforms its value during the subset
        // of the controller's duration defined by the animation's interval.
        // For example the opacity animation transforms its value during
        // the first 10% of the controller's duration.

        height = Tween<double>(begin: 150, end: 250.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.300,
              curve: Curves.ease,
            ),
          ),
        ),
        itemHeight = Tween<double>(begin: 0, end: 150.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.300,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> height;
  final Animation<double> itemHeight;

  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      height: height.value,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [begin, end],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
              alignment: Alignment(-1, 0),
              child: Text(
                categoryName,
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            //        mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 16.0),
                height: itemHeight.value,
                child: Image.asset(
                  assetPath,
                ),
              ),
              /*
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(24))),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'View',
                  style: TextStyle(color: end, fontWeight: FontWeight.bold),
                ),
              )
              */
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

class CardClick extends StatefulWidget {
  final Color begin;
  final Color end;
  final String categoryName;
  final String assetPath;

  List<Category> catergory;

  //final SwiperController swiperController = SwiperController();

  CardClick({Key key, this.begin, this.end, this.categoryName, this.assetPath})
      : super(key: key);

  final String getForm = Mecard().toString();

  //final String typeA = categoryName;
  //final String typeB = Mecard().createState().categories as String;

  @override
  _CardClick createState() => _CardClick();
}

class _CardClick extends State<CardClick> with TickerProviderStateMixin {
  AnimationController _controller;
  bool isActive = false;
  //final String getkey = categoryName;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
  }

  Future<void> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  Future<void> _reverseAnimation() async {
    try {
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  // -------- Link สินค้า และ การลงทุน ---------
  @override
  Widget build(BuildContext context) {
    var timeDilation = 10.0; // 1.0 is normal animation speed.

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      //onTap: () => Navigator.of(context).push(MaterialPageRoute(
      //    builder: (_) => Meproduct())), // ProductPage(product: product)));

      onTap: () {
        //  Navigator.push(
        //    context, MaterialPageRoute(builder: (context) => Meproduct()));

        // Navigator.pushNamed(context, '/meproduct');
        /*
        if (CategoryCard().categoryName == "สินค้า") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Meproduct()));
        }
        if (CategoryCard().categoryName == "การลงทุน") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Package()));
        }
        */
        //if (isActive) {
        //  isActive = !isActive;
        //  _reverseAnimation();
        //} else {
        //  isActive = !isActive;
        //  _playAnimation();
        //}
      },
      child: CategoryCard(
        controller: _controller.view,
        categoryName: widget.categoryName,
        begin: widget.begin,
        end: widget.end,
        assetPath: widget.assetPath,
      ),
    );
  }
}
