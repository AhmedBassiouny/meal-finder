import 'package:flutter/material.dart';

class HeartFavWidget extends StatefulWidget {
  final VoidCallback onSelected;
  final VoidCallback onDeselected;
  final bool isSelected;

  const HeartFavWidget({
    super.key,
    required this.onSelected,
    required this.onDeselected,
    this.isSelected = false,
  });

  @override
  State<HeartFavWidget> createState() => _HeartFavWidgetState();
}

class _HeartFavWidgetState extends State<HeartFavWidget> with SingleTickerProviderStateMixin {
  late bool _selected;
  late AnimationController _animationController;
  late Animation _colorAnimation;
  late Animation _sizeAnimation;

  @override
  void initState() {
    super.initState();

    _selected = widget.isSelected;

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    if (_selected) {
      _animationController.value = 1.0;
    }

    _colorAnimation = ColorTween(begin: Colors.grey, end: Colors.blueAccent)
        .animate(_animationController);

    _sizeAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1, end: 1.35),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.35, end: 1),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selected = !_selected;

          if (_selected) {
            _animationController.forward();
            widget.onSelected();
          } else {
            _animationController.reverse();
            widget.onDeselected();
          }
        });
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, _) {
          return Icon(
            Icons.favorite,
            color: _colorAnimation.value,
            size: 30.0 * _sizeAnimation.value,
          );
        },
      ),
    );
  }
}
