import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/palette.dart';
import 'package:iposter_chat_demo/core/models/images.dart';
import 'package:iposter_chat_demo/ui/widgets/page_indicator_effect.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GalleryArguments {
  final List<iPosterImage> images;
  final int initialIndex;

  GalleryArguments({@required this.images, this.initialIndex = 0});
}

class GalleryPage extends StatefulWidget {
  static const routeName = '/gallery-page';

  final GalleryArguments args;

  GalleryPage({@required this.args});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  PageController controller;

  @override
  void initState() {
    controller = PageController(initialPage: widget.args.initialIndex);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.args.images;

    return Scaffold(
      backgroundColor: Palette.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: controller,
            itemCount: images.length,
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(color: Palette.black),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(
                  images[index].getUrl(full: true),
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.contained,
              );
            },
            loadingBuilder: (context, progress) {
              return Center(child: CircularProgressIndicator());
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: SmoothPageIndicator(
                  controller: controller,
                  count: widget.args.images.length,
                  effect: pageIndicatorEffect(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
