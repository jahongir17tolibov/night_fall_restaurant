import 'package:flutter/material.dart';
import 'package:night_fall_restaurant/utils/helpers.dart';
import 'package:night_fall_restaurant/utils/ui_components/shimmer_gradient.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({super.key});

  @override
  State<StatefulWidget> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rowShimmerContainers = <Widget>[
      _buildShimmerAnimation(
        width: 90.0,
        height: 40.0,
        context: context,
        borderRadius: 200.0,
      ),
      _buildShimmerAnimation(
        width: 90.0,
        height: 40.0,
        context: context,
        borderRadius: 200.0,
      ),
      _buildShimmerAnimation(
        width: 90.0,
        height: 40.0,
        context: context,
        borderRadius: 200.0,
      ),
      _buildShimmerAnimation(
        width: 90.0,
        height: 40.0,
        context: context,
        borderRadius: 200.0,
      ),
    ];
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rowShimmerContainers,
          ),
          Expanded(
              child: CustomScrollView(
            primary: false,
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: <Widget>[
                    _buildShimmerAnimation(context: context),
                    _buildShimmerAnimation(context: context),
                    _buildShimmerAnimation(context: context),
                    _buildShimmerAnimation(context: context),
                    _buildShimmerAnimation(context: context),
                    _buildShimmerAnimation(context: context),
                    _buildShimmerAnimation(context: context),
                    _buildShimmerAnimation(context: context),
                    _buildShimmerAnimation(context: context),
                    _buildShimmerAnimation(context: context),
                  ],
                ),
              ),
            ],
          ))
        ],
      )),
    );
  }

  Widget _buildShimmerAnimation({
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
    double? borderRadius,
    required BuildContext context,
  }) =>
      AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Container(
            width: width,
            height: height,
            margin: margin,
            decoration: BoxDecoration(
              gradient: shimmerEffect(context, _controller),
              borderRadius: BorderRadius.circular(borderRadius ??= 16.0),
            )),
      );
}
