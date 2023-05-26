import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperapp/.env.dart';
import 'package:wallpaperapp/model/image_model.dart';
import 'package:wallpaperapp/pages/view.dart';

class Home extends GetView {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpaper App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getImages(),
                builder: (context, AsyncSnapshot<List<ImageModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  // if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  //   return const Text('No Wallpaper Found');
                  // }
                  return GridView.count(
                    crossAxisCount: 2,
                    children:
                        List.generate(snapshot.data?.length ?? 0, (index) {
                      ImageModel model = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => ViewImage(
                                  imageUrl: model.src.large,
                                  id: model.id.toString(),
                                ));
                          },
                          child: Hero(
                            tag: model.id.toString(),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                      model.src.medium),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
          )
        ],
      ),
    );
  }

  Future<List<ImageModel>> getImages() async {
    var response = await http.get(
      Uri.parse('https://api.pexels.com/v1/curated?page=1&per_page=40'),
      headers: {
        'Authorization': pexelAPI,
      },
    );

    final responseData = jsonDecode(response.body);

    List<ImageModel> list = [];
    for (var data in responseData['photos']) {
      list.add(ImageModel.fromJson(data));
    }
    return list;
  }
}
