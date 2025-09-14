import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memit/constants/constants.dart';

class PreCreateMemeScreen extends StatelessWidget {
  PreCreateMemeScreen({super.key});

  final List<_CollageType> collageTypes = [
    _CollageType(
      label: "Single",
      type: CollageType.single,
    ),
    _CollageType(
      label: "2-Grid",
      type: CollageType.twoGrid,
    ),
    _CollageType(
      label: "3-Grid",
      type: CollageType.threeGrid,
    ),
    _CollageType(
      label: "4-Grid",
      type: CollageType.fourGrid,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose a layout',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  itemCount: collageTypes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final collage = collageTypes[index];
                    return GestureDetector(
                      onTap: () {
                        context.pushNamed('selectPosts', extra: collage.type);
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _CollagePreviewIcon(type: collage.type),
                            const SizedBox(height: 16),
                            Text(
                              collage.label,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollageType {
  final String label;
  final CollageType type;
  _CollageType({required this.label, required this.type});
}

class _CollagePreviewIcon extends StatelessWidget {
  final CollageType type;
  const _CollagePreviewIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    if (type == CollageType.single) {
      return Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      );
    } else if (type == CollageType.twoGrid) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 20,
            color: Colors.grey[300],
          ),
          Container(
            width: 60,
            height: 20,
            color: Colors.grey[400],
          ),
        ],
      );
    } else if (type == CollageType.threeGrid) {
      return Column(
        children: [
          Container(
            width: 60,
            height: 14,
            color: Colors.grey[300],
          ),
          Container(
            width: 60,
            height: 14,
            color: Colors.grey[400],
          ),
          Container(
            width: 60,
            height: 14,
            color: Colors.grey[350],
          ),
        ],
      );
    } else if (type == CollageType.fourGrid) {
      return Column(children: [
        Container(width: 60, height: 10, color: Colors.grey[300]),
        Container(width: 60, height: 10, color: Colors.grey[400]),
        Container(width: 60, height: 10, color: Colors.grey[500]),
        Container(width: 60, height: 10, color: Colors.grey[600]),
      ]);
    }
    return Container(width: 40, height: 40, color: Colors.grey[200]);
  }
}
