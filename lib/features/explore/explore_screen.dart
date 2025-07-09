import 'package:flutter/material.dart';
import 'package:memit/common_widgets/responsive_center.dart';
import 'package:memit/common_widgets/search_textfield.dart';
import 'package:memit/constants/app_sizes.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_dismissOnScreenKeyboard);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_dismissOnScreenKeyboard);
    super.dispose();
  }

  void _dismissOnScreenKeyboard() {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const MemeSearchTextField(),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Meme of the day '),
                trailing: TextButton(onPressed: () {}, child: Text('See All')),
                onTap: () {},
              ),
            ]),
          ),
          ResponsiveSliverCenter(
            child:Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(12),
              elevation: 3,
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Image.network(
'https://plus.unsplash.com/premium_vector-1745292933875-d7dc07819d7c?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8am9rZXN8ZW58MHwwfDB8fHww'  ,                  fit: BoxFit.fitWidth, // or BoxFit.contain
                    width: double.infinity,
                  ),

                  const SizedBox(height: 8),

                  // Username
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'meme_raja',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),

                  // Description
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      'No pain no gain',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),

                  // Like count at bottom right
                  const Padding(
                    padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(), // empty space to align like count right
                        Text(
                          '2.5k likes',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // First horizontal list
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                leading: Icon(Icons.person),
                title: Text('AI Picks for you'),
                trailing: TextButton(onPressed: () {}, child: Text('See All')),
                onTap: () {},
              ),
            ]),
          ),
          ResponsiveSliverCenter(
            padding: const EdgeInsets.all(Sizes.p16),
            child: SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder:
                    (context, index) => Card( 
                      margin: const EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: 140,
                        child: Center(child: Text('Card 1 - $index')),
                      ),
                    ),
              ),
            ),
          ),

          // Second horizontal list
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Meme Moments'),
                trailing: TextButton(onPressed: () {}, child: Text('See All')),
                onTap: () {},
              ),
            ]),
          ),
          ResponsiveSliverCenter(
            padding: const EdgeInsets.all(Sizes.p16),
            child: SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder:
                    (context, index) => Card(
                      margin: const EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: 140,
                        child: Center(child: Text('Card 2 - $index')),
                      ),
                    ),
              ),
            ),
          ),
              SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                leading: Icon(Icons.person),
                title: Text('#Remix Challenges'),
                trailing: TextButton(onPressed: () {}, child: Text('See All')),
                onTap: () {},
              ),
            ]),
          ),
          ResponsiveSliverCenter(
            padding: const EdgeInsets.all(Sizes.p16),
            child: SizedBox(
              height:150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder:
                    (context, index) => Card(
                      margin: const EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: 140,
                        child: Center(child: Text('Card 2 - $index')),
                      ),
                    ),
              ),
            ),
          ),
     
       
        ],
      ),
    );
  }
}
