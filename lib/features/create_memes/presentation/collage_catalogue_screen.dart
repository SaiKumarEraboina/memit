// This version replaces helper widget functions with separate widget classes for clarity.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memit/common_widgets/responsive_scrollable_card.dart';
import 'package:memit/features/create_memes/presentation/pick_image_for_collage_screen.dart';
import 'package:memit/features/create_memes/presentation/select_image_source.dart';

class CollageCatalogueScreen extends StatelessWidget {
  const CollageCatalogueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Collage')),
      backgroundColor: const Color(0xffEFF3F5),
      body: SafeArea(
        child: ResponsiveScrollableCard(
          child: Column(
            children: const [
              Row(
                children: [
                  Expanded(child: Collage1()),
                  Expanded(child: Collage2()),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Collage3()),
                  Expanded(child: Collage4()),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Collage5()),
                  Expanded(child: Collage6()),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Collage7()),
                  Expanded(child: Collage8()),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Collage9()),
                  Expanded(child: Collage10()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({super.key});
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 0.5, thickness: 0.5, color: Colors.grey);
}

class VerticalDividerWidget extends StatelessWidget {
  const VerticalDividerWidget({super.key});
  @override
  Widget build(BuildContext context) =>
      const VerticalDivider(width: 0.5, thickness: 0.5, color: Colors.grey);
}

class CollageWrapper extends StatelessWidget {
  final double height;
  final Widget Function(BuildContext context, bool showIcons) builder;
  const CollageWrapper({
    super.key,
    required this.height,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      MaximizedCollageScreen(layout: builder(context, true)),
            ),
          );
        },
        child: Card(color: Colors.white, child: builder(context, false)),
      ),
    );
  }
}

class Collage1 extends StatelessWidget {
  const Collage1({super.key});
  @override
  Widget build(BuildContext context) {
    return CollageWrapper(
      height: 200,
      builder:
          (ctx, showIcons) => Column(
            children: [
              Expanded(
                child:
                    showIcons
                        ? const SelectMediaFromSource()
                        : const SizedBox(),
              ),
            ],
          ),
    );
  }
}

class Collage2 extends StatelessWidget {
  const Collage2({super.key});
  @override
  Widget build(BuildContext context) {
    return CollageWrapper(
      height: 200,
      builder:
          (ctx, showIcons) => Column(
            children: [
              Expanded(
                child:
                    showIcons
                        ? const SelectMediaFromSource()
                        : const SizedBox(),
              ),
              const HorizontalDivider(),
              Expanded(
                child:
                    showIcons
                        ? const SelectMediaFromSource()
                        : const SizedBox(),
              ),
            ],
          ),
    );
  }
}

class Collage3 extends StatelessWidget {
  const Collage3({super.key});
  @override
  Widget build(BuildContext context) {
    return CollageWrapper(
      height: 200,
      builder:
          (ctx, showIcons) => Column(
            children: [
              Expanded(
                child:
                    showIcons
                        ? const SelectMediaFromSource()
                        : const SizedBox(),
              ),
              const HorizontalDivider(),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                    const VerticalDividerWidget(),
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}

class Collage4 extends StatelessWidget {
  const Collage4({super.key});
  @override
  Widget build(BuildContext context) {
    return CollageWrapper(
      height: 200,
      builder:
          (ctx, showIcons) => Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                    const VerticalDividerWidget(),
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                  ],
                ),
              ),
              const HorizontalDivider(),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                    const VerticalDividerWidget(),
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}

class Collage5 extends StatelessWidget {
  const Collage5({super.key});
  @override
  Widget build(BuildContext context) {
    return CollageWrapper(
      height: 200,
      builder:
          (ctx, showIcons) => Row(
            children: [
              const Expanded(child: SizedBox()),
              const VerticalDividerWidget(),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                    const HorizontalDivider(),
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}

class Collage6 extends StatelessWidget {
  const Collage6({super.key});
  @override
  Widget build(BuildContext context) {
    return CollageWrapper(
      height: 200,
      builder:
          (ctx, showIcons) => Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                    const HorizontalDivider(),
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                  ],
                ),
              ),
              const VerticalDividerWidget(),
              Expanded(
                child:
                    showIcons
                        ? const SelectMediaFromSource()
                        : const SizedBox(),
              ),
            ],
          ),
    );
  }
}

class Collage7 extends StatelessWidget {
  const Collage7({super.key});
  @override
  Widget build(BuildContext context) {
    return CollageWrapper(
      height: 300,
      builder:
          (ctx, showIcons) => Column(
            children: [
              Expanded(
                child:
                    showIcons
                        ? const SelectMediaFromSource()
                        : const SizedBox(),
              ),
              const HorizontalDivider(),
              Expanded(
                child:
                    showIcons
                        ? const SelectMediaFromSource()
                        : const SizedBox(),
              ),
              const HorizontalDivider(),
              Expanded(
                child:
                    showIcons
                        ? const SelectMediaFromSource()
                        : const SizedBox(),
              ),
            ],
          ),
    );
  }
}

class Collage8 extends StatelessWidget {
  const Collage8({super.key});
  @override
  Widget build(BuildContext context) {
    return CollageWrapper(
      height: 300,
      builder:
          (ctx, showIcons) => Column(
            children: [
              Expanded(
                child:
                    showIcons
                        ? const SelectMediaFromSource()
                        : const SizedBox(),
              ),
              const HorizontalDivider(),
              Expanded(
                child:
                    showIcons
                        ? const SelectMediaFromSource()
                        : const SizedBox(),
              ),
              const HorizontalDivider(),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                    const VerticalDividerWidget(),
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}

class Collage9 extends StatelessWidget {
  const Collage9({super.key});
  @override
  Widget build(BuildContext context) {
    return CollageWrapper(
      height: 300,
      builder:
          (ctx, showIcons) => Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                    const VerticalDividerWidget(),
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                  ],
                ),
              ),
              const HorizontalDivider(),
              Expanded(
                child:
                    showIcons
                        ? const SelectMediaFromSource()
                        : const SizedBox(),
              ),
              const HorizontalDivider(),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                    const VerticalDividerWidget(),
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}

class Collage10 extends StatelessWidget {
  const Collage10({super.key});
  @override
  Widget build(BuildContext context) {
    return CollageWrapper(
      height: 300,
      builder:
          (ctx, showIcons) => Column(
            children: [
              Expanded(
                child:
                    showIcons
                        ? const SelectMediaFromSource()
                        : const SizedBox(),
              ),
              const HorizontalDivider(),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                    const VerticalDividerWidget(),
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                  ],
                ),
              ),
              const HorizontalDivider(),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                    const VerticalDividerWidget(),
                    Expanded(
                      child:
                          showIcons
                              ? const SelectMediaFromSource()
                              : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}
