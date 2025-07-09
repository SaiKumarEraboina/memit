import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memit/common_widgets/responsive_scrollable_card.dart';
import 'package:memit/features/create_memes/presentation/collage_catalogue_screen.dart';
import 'package:memit/features/create_memes/presentation/template.dart';


class CreateMemesScreen extends StatelessWidget {
  const CreateMemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ResponsiveScrollableCard(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:const EdgeInsets.only(top: 50),
                child: Text(
                  'Create Meme',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => CollageCatalogueScreen(),)),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(width: 0.5, color: Color(0xffB4B4B4)),
                    color: const Color(0xFFE8F3FF),
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Vertically center
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Horizontally center
                    children: [
                      SvgPicture.asset(
                        'assets/icons/add_circle.svg',
                        width: 40,
                        height: 40,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 8), // Space between icon and text
                      const Text('Create your meme'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Meme Template',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search Template',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // <- Rounded corners
                    borderSide: const BorderSide(
                      width: 0.5,
                      color: Color(0xffB4B4B4),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      width: 0.5,
                      color: Color(0xffB4B4B4),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      width: 0.5,
                      color: Color(0xffB4B4B4),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 14),

       
              const SizedBox(height: 24),
              Text(
                'Create with Latest Templates',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  Row(
                    children: const [
                      Expanded(
                        child: Template(
                          image: 'fire',
                          templateTitle: 'Trending',
                          templateDescription: 'Use Trending meme template',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Template(
                          image: 'movie',
                          templateTitle: 'Movie',
                          templateDescription: 'Meme templates from movies',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: const [
                      Expanded(
                        child: Template(
                          image: 'smiley',
                          templateTitle: 'Funny',
                          templateDescription: 'Light-hearted and fun memes',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Template(
                          image: 'game',
                          templateTitle: 'Gaming',
                          templateDescription: 'Gaming-related memes',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
      ),
    );
  }
}
