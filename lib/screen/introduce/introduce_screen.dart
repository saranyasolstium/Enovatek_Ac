import 'package:enavatek_mobile/router/route_constant.dart';
import 'package:enavatek_mobile/screen/introduce/slide_item.dart';
import 'package:enavatek_mobile/screen/introduce/slide.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';

import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

class IntroductionScreen extends StatelessWidget {
  IntroductionScreen({Key? key}) : super(key: key);

  final List<Slide> slides = [
    Slide(
      imageUrl: ImgPath.pngIntro1,
      title: 'Control your device',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
    ),
    Slide(
      imageUrl: ImgPath.pngIntro2,
      title: 'Track your device status',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
    ),
    Slide(
      imageUrl: ImgPath.pngIntro3,
      title: 'Track energy usage',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isTablet = screenWidth >= 600;
    return Scaffold(
      backgroundColor: ConstantColors.backgroundColor,
      body: Swiper(
        itemCount: slides.length,
        loop: false,
        autoplay: true,
        autoplayDelay: 3000,
        autoplayDisableOnInteraction: true,
        itemBuilder: (context, index) {
          return SlideItem(
            imageUrl: slides[index].imageUrl,
            title: slides[index].title,
            description: slides[index].description,
          );
        },
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            color: const Color.fromRGBO(246, 249, 255, 1),
            size: isTablet ? screenHeight * 0.03 : screenHeight * 0.05,
            activeColor: ConstantColors.lightBlueColor,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ConstantColors.backgroundColor,
        height: isTablet ? screenHeight * 0.15 : screenHeight * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RoundedButton(
              onPressed: () {
                Navigator.pushNamed(context, loginRoute);
              },
              text: "Skip",
              backgroundColor: ConstantColors.whiteColor,
              textColor: ConstantColors.borderButtonColor,
            ),
            RoundedButton(
              onPressed: () {
                Navigator.pushNamed(context, loginRoute);
              },
              text: "Next",
              backgroundColor: ConstantColors.borderButtonColor,
              textColor: ConstantColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
