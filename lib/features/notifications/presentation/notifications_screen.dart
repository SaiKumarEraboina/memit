import 'package:flutter/material.dart';
import 'package:memit/common_widgets/responsive_center.dart';
import 'package:memit/constants/app_sizes.dart';
import 'package:memit/constants/breakpoints.dart';
import 'package:memit/constants/test_notifications_data.dart';
import 'package:memit/features/notifications/domain/notification_model.dart';
import 'package:memit/localization/string_hardcoded.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(          
        centerTitle: false,       
        title: Text('Notification Center'.hardcoded),      
        foregroundColor: Colors.black87,              
        backgroundColor: const Color(0xFFF0F2F5),
      ),
      backgroundColor: const Color(0xFFF0F2F5),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = notifications[index];

              String message = '';
              switch (item.type) {
                case NotificationType.commented:
                  message = '${item.name} commented: "${item.comment}"';
                  break;
                case NotificationType.liked:
                  message = '${item.name} liked your post';
                  break;
                case NotificationType.following:
                  message = '${item.name} started following you';
                  break;
                case NotificationType.requested:
                  message = '${item.name} sent you a follow request';
                  break;
              }

              String timeAgo;
              final now = DateTime.now();
              final difference = now.difference(item.time);
              if (difference.inMinutes < 60) {
                timeAgo = '${difference.inMinutes} min ago';
              } else if (difference.inHours < 24) {
                timeAgo = '${difference.inHours} hr ago';
              } else {
                timeAgo = '${difference.inDays} day(s) ago';
              }

              return ResponsiveCenter( 
                maxContentWidth: Breakpoint.tablet,
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.p16,
                  vertical: Sizes.p12,
                ),
                child: ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))
                  ),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(item.imageUrl),
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    message,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  trailing: Text(
                    timeAgo,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tapped on ${item.name}')),
                    );
                  },
                ),
              );
            }, childCount: notifications.length),
          ),
        ],
      ),
    );
  }
}




