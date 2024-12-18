import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Avatar extends StatelessWidget {
  final String avatarUrl;
  final String status;
  final double size;
  final double statusSize;

  const Avatar({
    super.key,
    required this.avatarUrl,
    required this.status,
    this.size = 40.0,
    this.statusSize = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundColor: avatarUrl.isEmpty
              ? Color(0xff4E74ED)
              : null, // Customize the color
          child: avatarUrl.isNotEmpty
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: avatarUrl,
                    placeholder: (context, url) => SizedBox(
                      width: size / 2,
                      height: size / 2,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person),
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(Icons.person,
                  color: Colors.white), // Add contrasting color for the icon
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
