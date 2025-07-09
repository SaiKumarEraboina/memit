import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memit/localization/string_hardcoded.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget{
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      leading: Padding(
        padding: const EdgeInsets.all(10.0), // optional for spacing
        child: SvgPicture.asset(
          'assets/icons/logo.svg',
          height: 24, // try a visible size
          width: 24,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        'MEMIT'.hardcoded,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 24,
          color: Theme.of(context).textTheme.titleMedium!.color,
        ),
      ),
      actions: [
        Container(
          width: 30, // Adjust size as needed
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 0.5,color: Colors.grey)
          ),
          child: Center(
            child: Icon(
              Icons.message_sharp,
              color: Theme.of(context).iconTheme.color,
              size: Theme.of(context).iconTheme.copyWith(size: 14).size,
    
            ), // Your icon here
          ),
        ),
        SizedBox(width: 10,)
      ],
      
      backgroundColor: Color(0xffEFF3F5),
    );
  }
  

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
  
}
