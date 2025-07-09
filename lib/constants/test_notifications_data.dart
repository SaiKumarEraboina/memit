 import 'package:memit/features/notifications/domain/notification_model.dart';

final List<NotificationItem> notifications = [
      NotificationItem(
        name: 'Alice',
        comment: 'Nice photo!',
        type: NotificationType.commented, 
        time: DateTime.now().subtract(const Duration(minutes: 5)), 
        imageUrl: 'https://plus.unsplash.com/premium_photo-1664015982598-283bcdc9cae8?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8bWVufGVufDB8fDB8fHww',
      ),
      NotificationItem(
        name: 'Bob',
        comment: '',
        type: NotificationType.liked,
        time: DateTime.now().subtract(const Duration(minutes: 10)),
          imageUrl: 'https://images.unsplash.com/photo-1496345875659-11f7dd282d1d?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWVufGVufDB8fDB8fHww',
      ),
      NotificationItem(
        name: 'Charlie',
        comment: '',
        type: NotificationType.following,
        time: DateTime.now().subtract(const Duration(hours: 1)),
          imageUrl: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fG1lbnxlbnwwfHwwfHx8MA%3D%3D',
      ),
      NotificationItem(
        name: 'Dana',
        comment: '',
        type: NotificationType.requested,
        time: DateTime.now().subtract(const Duration(hours: 2)),
          imageUrl: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8d29tZW58ZW58MHx8MHx8fDA%3D',
      ),
      NotificationItem(
        name: 'Eva',
        comment: 'Love this!',
        type: NotificationType.commented,
        time: DateTime.now().subtract(const Duration(days: 1)),
          imageUrl: 'https://plus.unsplash.com/premium_photo-1681493353999-a3eea8b95e1d?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fHdvbWVufGVufDB8fDB8fHww',
      ),
    ];