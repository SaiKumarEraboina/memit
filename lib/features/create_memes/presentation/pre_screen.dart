import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PreCreateMemeScreen extends StatelessWidget {
  PreCreateMemeScreen({super.key});

  final List<_CollageType> collageTypes = [
    _CollageType(
      label: "Single",
      type: "single",
    ),
    _CollageType(
      label: "2-Grid",
      type: "2grid",
    ),
    _CollageType(
      label: "3-Grid",
      type: "3grid",
    ),
    _CollageType(
      label: "4-Grid",
      type: "4grid",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Meme', style: TextStyle(color: Colors.black)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
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
                      context.push('/create-meme', extra: collage.type);
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
    );
  }
}

class _CollageType {
  final String label;
  final String type;
  _CollageType({required this.label, required this.type});
}

class _CollagePreviewIcon extends StatelessWidget {
  final String type;
  const _CollagePreviewIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    if (type == "single") {
      return Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      );
    } else if (type == "2grid") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 40,
            color: Colors.grey[300],
            margin: const EdgeInsets.only(right: 4),
          ),
          Container(
            width: 24,
            height: 40,
            color: Colors.grey[400],
          ),
        ],
      );
    } else if (type == "3grid") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 16,
            height: 40,
            color: Colors.grey[300],
            margin: const EdgeInsets.only(right: 2),
          ),
          Container(
            width: 16,
            height: 40,
            color: Colors.grey[400],
            margin: const EdgeInsets.only(right: 2),
          ),
          Container(
            width: 16,
            height: 40,
            color: Colors.grey[350],
          ),
        ],
      );
    } else if (type == "4grid") {
      return Wrap(
        spacing: 2,
        runSpacing: 2,
        children: List.generate(
            4,
            (i) => Container(
                  width: 18,
                  height: 18,
                  color: Colors.grey[300 + (i * 50)],
                )),
      );
    }
    return Container(width: 40, height: 40, color: Colors.grey[200]);
  }
}
