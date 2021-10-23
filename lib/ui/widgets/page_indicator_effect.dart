import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/constants/palette.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

WormEffect pageIndicatorEffect() {
  return WormEffect(
    dotColor: Colors.white,
    activeDotColor: Palette.green,
    dotHeight: 12,
    dotWidth: 12,
  );
}
