import 'package:flutter/material.dart';
import 'package:memit/features/home/domain/meme_model.dart';
import 'package:memit/features/home/presentation/feed_layout.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with TickerProviderStateMixin {
  late TabController _controller;
  late AnimationController _animationControllerOn;
  late AnimationController _animationControllerOff;
  late Animation<Color?> _colorTweenBackgroundOn;
  late Animation<Color?> _colorTweenBackgroundOff;
  late Animation<Color?> _colorTweenForegroundOn;
  late Animation<Color?> _colorTweenForegroundOff;

  int _currentIndex = 0;
  int _prevControllerIndex = 0;
  double _aniValue = 0.0;
  double _prevAniValue = 0.0;

  // final List<String> categories= [
  //   'All',
  //   'Memes',
  //   'Sports',
  //   'News',
  //   'Entertainment',
  //   'Politics'
  // ];

  final categories = [
    CategoryTab(label: 'All', category: Category.all),
    CategoryTab(label: 'Memes', category: Category.memes),
    CategoryTab(label: 'Sports', category: Category.sports),
    CategoryTab(label: 'News', category: Category.news),
    CategoryTab(label: 'Entertainment', category: Category.entertainment),
    CategoryTab(label: 'Politics', category: Category.politics),
  ];

  final Color _foregroundOn = Colors.white;
  final Color _foregroundOff = Colors.black;
  final Color _backgroundOn = Colors.blue;
  final Color _backgroundOff = Colors.grey.shade300;

  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _keys = [];

  bool _buttonTap = false;

  @override
  void initState() {
    super.initState();

    for (int index = 0; index < categories.length; index++) {
      _keys.add(GlobalKey());
    }

    _controller = TabController(vsync: this, length: categories.length);
    _controller.animation!.addListener(_handleTabAnimation);
    _controller.addListener(_handleTabChange);

    _animationControllerOff = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 75),
    )..value = 1.0;

    _animationControllerOn = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..value = 1.0;

    _colorTweenBackgroundOff = ColorTween(
      begin: _backgroundOn,
      end: _backgroundOff,
    ).animate(_animationControllerOff);

    _colorTweenForegroundOff = ColorTween(
      begin: _foregroundOn,
      end: _foregroundOff,
    ).animate(_animationControllerOff);

    _colorTweenBackgroundOn = ColorTween(
      begin: _backgroundOff,
      end: _backgroundOn,
    ).animate(_animationControllerOn);

    _colorTweenForegroundOn = ColorTween(
      begin: _foregroundOff,
      end: _foregroundOn,
    ).animate(_animationControllerOn);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationControllerOn.dispose();
    _animationControllerOff.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
 Material(
  elevation: 2, // controls shadow depth
  color: const Color(0xffEFF3F5), // background color
  child: SizedBox(
    height: 50.0,
    child: ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Padding(
          key: _keys[index],
          padding: const EdgeInsets.all(6.0),
          child: AnimatedBuilder(
            animation: _animationControllerOn,
            builder: (context, child) => TextButton(
              style: TextButton.styleFrom(
                backgroundColor: _getBackgroundColor(index),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
              ),
              onPressed: () {
                setState(() {
                  _buttonTap = true;
                  _controller.animateTo(index);
                  _setCurrentIndex(index);
                  _scrollTo(index);
                });
              },
              child: Text(
                categories[index].label,
                style: TextStyle(color: _getForegroundColor(index)),
              ),
            ),
          ),
        );
      },
    ),
  ),
),

        Expanded(
          child: TabBarView(
            controller: _controller,
            children:
                categories.map((category) {
                  return FeedLayout(
                    category: category.category!,
                  ); // nullable Category?
                }).toList(),
          ),
        ),
      ],
    );
  }

  void _handleTabAnimation() {
    _aniValue = _controller.animation!.value;
    if (!_buttonTap && (_aniValue - _prevAniValue).abs() < 1) {
      _setCurrentIndex(_aniValue.round());
    }
    _prevAniValue = _aniValue;
  }

  void _handleTabChange() {
    if (_buttonTap) _setCurrentIndex(_controller.index);
    if ((_controller.index == _prevControllerIndex) ||
        (_controller.index == _aniValue.round())) {
      _buttonTap = false;
    }
    _prevControllerIndex = _controller.index;
  }

  void _setCurrentIndex(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      _triggerAnimation();
      _scrollTo(index);
    }
  }

  void _triggerAnimation() {
    _animationControllerOn.reset();
    _animationControllerOff.reset();
    _animationControllerOn.forward();
    _animationControllerOff.forward();
  }

  void _scrollTo(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final renderBox =
        _keys[index].currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size.width;
    final position = renderBox.localToGlobal(Offset.zero).dx;
    double offset = (position + size / 2) - screenWidth / 2;

    final firstBox =
        _keys.first.currentContext?.findRenderObject() as RenderBox?;
    final lastBox = _keys.last.currentContext?.findRenderObject() as RenderBox?;

    if (offset < 0 && firstBox != null) {
      final firstPosition = firstBox.localToGlobal(Offset.zero).dx;
      if (firstPosition > offset) offset = firstPosition;
    } else if (offset > 0 && lastBox != null) {
      final lastPosition = lastBox.localToGlobal(Offset.zero).dx;
      final lastSize = lastBox.size.width;
      if (lastPosition + lastSize - offset < screenWidth) {
        offset = lastPosition + lastSize - screenWidth;
      }
    }

    _scrollController.animateTo(
      offset + _scrollController.offset,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }

  Color? _getBackgroundColor(int index) {
    if (index == _currentIndex) return _colorTweenBackgroundOn.value;
    if (index == _prevControllerIndex) return _colorTweenBackgroundOff.value;
    return _backgroundOff;
  }

  Color? _getForegroundColor(int index) {
    if (index == _currentIndex) return _colorTweenForegroundOn.value;
    if (index == _prevControllerIndex) return _colorTweenForegroundOff.value;
    return _foregroundOff;
  }
}
