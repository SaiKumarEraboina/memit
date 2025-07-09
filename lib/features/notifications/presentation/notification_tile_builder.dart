// import 'package:flutter/material.dart';
// import 'package:memit/common_widgets/empty_placeholder_widget.dart';
// import 'package:memit/common_widgets/responsive_center.dart';
// import 'package:memit/features/notifications/domain/notification_model.dart';
// import 'package:memit/localization/string_hardcoded.dart';

// class NotificationItemBuilder extends StatelessWidget {
//   final List<NotificationItem> items;
//   final Widget Function(BuildContext, Item, int) itemBuilder;

//   const NotificationItemBuilder({
//     super.key,
//     required this.items,
//     required this.itemBuilder,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (items.isEmpty) {
//       return EmptyPlaceholderWidget(
//         message: 'Your shopping cart is empty'.hardcoded,
//       );
//     }

//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemBuilder: (context, index) {
//               final item = items[index];
//               return itemBuilder(context, item, index);
//             },
//             itemCount: items.length,
//           ),
//         ),
//       ],
//     );
//   }
// }
