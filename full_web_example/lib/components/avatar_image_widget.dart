import 'dart:io';
import 'package:npua_project/constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget(
      {this.url, this.file, this.size = 30, this.radius = 25, Key? key})
      : super(key: key);
  final String? url;
  final File? file;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final path = url;
    final image = file;

    return Container(
      padding: const EdgeInsets.all(5),
      child: CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.solitudeColor,
          child: ClipOval(
              child: path != null
                  ? CachedNetworkImage(
                      imageUrl: path,
                      placeholder: (context, imageProvider) =>
                          Stack(alignment: Alignment.center, children: [
                            Icon(Icons.person,
                                color: AppColors.empressColor, size: size),
                            SizedBox(
                                height: size,
                                width: size,
                                child: const CupertinoActivityIndicator())
                          ]),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: size,
                      width: size)
                  : image != null
                      ? Image.file(image,
                          fit: BoxFit.cover, height: size, width: size)
                      : Icon(Icons.person,
                          color: AppColors.empressColor, size: size))),
    );
  }
}
