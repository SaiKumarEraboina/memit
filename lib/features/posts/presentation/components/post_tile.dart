import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memit/features/auth/domain/entities/app_user.dart';
import 'package:memit/features/auth/presentation/components/custom_textfield.dart';
import 'package:memit/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:memit/features/posts/domain/entities/comment.dart';
import 'package:memit/features/posts/domain/entities/post.dart';
import 'package:memit/features/posts/presentation/cubit/post_cubit.dart';
import 'package:memit/features/profile/cubit/profile_cubit.dart';
import 'package:memit/features/profile/domain/entities/profile_user.dart';
import 'package:video_player/video_player.dart';

class PostTile extends StatefulWidget {
  const PostTile({super.key, required this.post, required this.onDelete});
  final Post post;
  final void Function()? onDelete;

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late final postCubit;
  late final profileCubit;
  bool isOwnPost = false;
  AppUser? currentUser;
  ProfileUser? postUser;
  final commentTextController = TextEditingController();
  VideoPlayerController? _videoController;
  bool _isVideo = false;

  @override
  void initState() {
    super.initState();
    postCubit = context.read<PostCubit>();
    profileCubit = context.read<ProfileCubit>();
    getCurrentUser();
    fetchPostUser();
    _checkIfVideo();
  }

  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: CustomTextField(
          controller: commentTextController,
          hintText: "Type a comment",
          obscureText: false,
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),

          // save button
          TextButton(
            onPressed: () {
              addComment();
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void addComment() {
    // create a new comment
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: widget.post.userId,
      userName: widget.post.userName,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );

    // add comment using cubit
    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  void _checkIfVideo() {
    final url = widget.post.imageUrl;
    final isVideo = widget.post.mediaType ?? 'image';
    _isVideo = isVideo == 'video';
    if (_isVideo) {
      _videoController = VideoPlayerController.network(url)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    commentTextController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchUser != null) {
      setState(() {
        postUser = fetchUser;
      });
    }
  }

  void toggleLikePost() {
    final isLiked = widget.post.likes.contains(currentUser!.uid);
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });
    postCubit.togglePost(widget.post.id, currentUser!.uid).catchError((error) {
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post?"),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),

          // delete button
          TextButton(
            onPressed: () {
              widget.onDelete!();
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLiked = widget.post.likes.contains(currentUser?.uid);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar: Avatar, username, options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Row(
              children: [
                postUser?.profileImgUrl != null
                    ? CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            CachedNetworkImageProvider(postUser!.profileImgUrl),
                        backgroundColor: Colors.grey[300],
                      )
                    : const CircleAvatar(radius: 20, child: Icon(Icons.person)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.post.userName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                if (isOwnPost)
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: showOptions,
                  ),
              ],
            ),
          ),
          // Post media (image or video)
          _isVideo
              ? Container(
                  width: double.infinity,
                  height: 400,
                  color: Colors.black,
                  child: _videoController != null &&
                          _videoController!.value.isInitialized
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_videoController!.value.isPlaying) {
                                    _videoController!.pause();
                                  } else {
                                    _videoController!.play();
                                  }
                                });
                              },
                              child: Icon(
                                _videoController!.value.isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_filled,
                                color: Colors.white.withOpacity(0.7),
                                size: 64,
                              ),
                            ),
                          ],
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                )
              : CachedNetworkImage(
                  imageUrl: widget.post.imageUrl,
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) => Container(
                    height: 400,
                    color: Colors.grey[200],
                    child: Icon(Icons.image_not_supported, size: 40),
                  ),
                  placeholder: (context, url) => Container(
                    height: 400,
                    color: Colors.grey[200],
                  ),
                ),
          // Action row: Like, Comment, Share, Bookmark
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : theme.iconTheme.color,
                  ),
                  onPressed: toggleLikePost,
                ),
                IconButton(
                  icon: Image.asset(
                    "assets/icons/comment.png",
                    height: 22,
                    width: 22,
                    color: theme.iconTheme.color,
                  ),
                  onPressed: openNewCommentBox,
                ),
                IconButton(
                  icon: Icon(Icons.send_outlined, color: theme.iconTheme.color),
                  onPressed: () {}, // Placeholder for share
                ),
                const Spacer(),
                IconButton(
                  icon:
                      Icon(Icons.bookmark_border, color: theme.iconTheme.color),
                  onPressed: () {}, // Placeholder for bookmark
                ),
              ],
            ),
          ),
          // Likes count
          if (widget.post.likes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "${widget.post.likes.length} like${widget.post.likes.length == 1 ? '' : 's'}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          // Post text: username + text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: widget.post.userName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const TextSpan(text: "  "),
                  TextSpan(
                    text: widget.post.text,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Comments count
          if (widget.post.comments.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
              child: GestureDetector(
                onTap: openNewCommentBox,
                child: Text(
                  "View all ${widget.post.comments.length} comment${widget.post.comments.length == 1 ? '' : 's'}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ),
            ),
          // Timestamp
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
            child: Text(
              _formatTimestamp(widget.post.timestamp),
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}
