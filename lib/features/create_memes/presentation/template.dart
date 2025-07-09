import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Template extends StatelessWidget {
  final String image;
  final String templateDescription;
  final String templateTitle;

  const Template({
    super.key,
    required this.image,
    required this.templateDescription,
    required this.templateTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0), // consolidated padding
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE9F8FF),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/$image.svg",
                width: 64,
                height: 64,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            templateTitle,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            templateDescription,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
