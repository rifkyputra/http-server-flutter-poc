import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scratchpad/web_server_launch.dart';

void main() => runApp(Root());

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  final List items = [
    (i) => CardItem(index: i),
    (i) => CardItem(index: i),
    (i) => CardItem(index: i),
    (i) => CardItem(index: i),
    (i) => CardItem(index: i),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.horizontal,
      slivers: [
        // MySliderSliver(
        //   child: SizedBox(
        //     child: Stack(
        //       children: List.generate(
        //         items.length,
        //         (index) => items[index](index),
        //       ),
        //       // children: [
        //       //   CardItem(),
        //       //   CardItem(),
        //       //   CardItem(),
        //       //   CardItem(),
        //       // ],
        //     ),
        //   ),
        // ),
        SliverToBoxAdapter(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Test'),
                SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                Center(child: WebServerLauncher()),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class CardItem extends StatelessWidget {
  final int index;

  const CardItem({Key? key, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: index * 100),
      // offset: Offset(index * 100, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(23),
        ),
        height: 400,
        width: 200,
        child: Center(
          child: Text('Nama Kartu'),
        ),
      ),
    );
  }
}

class MySliderSliver extends SingleChildRenderObjectWidget {
  MySliderSliver({
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomSlider();
  }
}

class CustomSlider extends RenderSliverSingleBoxAdapter {
  CustomSlider({RenderBox? child}) : super(child: child);

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final SliverConstraints constraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      // scrollExtent: 500,
      // paintExtent: 300,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    setChildParentData(child!, constraints, geometry!);
  }
}
