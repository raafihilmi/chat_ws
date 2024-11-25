import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Avatar extends StatelessWidget {
  final String avatarUrl;
  final String status;
  final double size;
  final double statusSize;

  const Avatar({
    Key? key,
    required this.avatarUrl,
    required this.status,
    this.size = 40.0,
    this.statusSize = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: size / 2,
          child: avatarUrl.isNotEmpty
              ? ClipOval(
            child: CachedNetworkImage(
              imageUrl: avatarUrl,
              placeholder: (context, url) => SizedBox(
                width: size / 2,
                height: size / 2,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (context, url, error) =>
              const Icon(Icons.person),
              fit: BoxFit.cover,
            ),
          )
              : const Icon(Icons.person),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: statusSize,
            height: statusSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: status == 'ONLINE' ? Colors.green : Colors.grey,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
