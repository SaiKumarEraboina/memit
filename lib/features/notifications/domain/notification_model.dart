enum NotificationType {
  commented,
  liked,
  following,
  requested,
}

class NotificationItem {
  final String name;
  final String comment;
  final NotificationType type;
  final DateTime time;
  final String imageUrl;

  NotificationItem({
    required this.name,
    required this.comment,
    required this.type,
    required this.time,
    required this.imageUrl
  });
}
