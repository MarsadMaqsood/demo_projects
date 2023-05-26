import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewImage extends GetView {
  const ViewImage({super.key, required this.id, required this.imageUrl});
  final String id;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Hero(
                  tag: id,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        title: Text('Applying...'),
                        content: SizedBox(
                            width: 50,
                            height: 50,
                            child: Center(
                                child: CircularProgressIndicator.adaptive())),
                      );
                    });

                await AsyncWallpaper.setWallpaper(url: imageUrl);

                await Future.delayed(1.seconds);

                Get.back();
              },
              splashColor: Colors.red,
              hoverColor: Colors.red,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.1),
                ),
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.check,
                  size: 32,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
