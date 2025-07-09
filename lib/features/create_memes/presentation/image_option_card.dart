import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageOptionCard extends StatelessWidget {
  final String assetPath;
  final void Function() onTap;

  const ImageOptionCard({
    super.key,
    required this.assetPath,
    required this.onTap,

  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child:  SvgPicture.asset(
                assetPath,
                height: 30,
                width: 30,
              )    
      ),
    );
  }
}
