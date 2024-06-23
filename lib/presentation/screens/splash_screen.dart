import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather/helper/constants/colors_resources.dart';
import 'package:weather/helper/constants/image_resources.dart';
import 'package:weather/helper/constants/screen_percentage.dart';
import 'package:weather/helper/constants/string_resources.dart';
import 'package:weather/helper/utills/text_styles.dart';
import 'package:weather/presentation/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    splashScreenMethod();
    super.initState();
  }

  splashScreenMethod() async {
    await Future.delayed(const Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuerySize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
            height: mediaQuerySize.height * ScreenPercentage.SCREEN_SIZE_100.h,
            width: mediaQuerySize.width * ScreenPercentage.SCREEN_SIZE_100.w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    opacity: 0.5,
                    fit: BoxFit.cover,
                    image:
                        AssetImage(ImageResources.LOADING_BACKGROUND_IMAGE))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: mediaQuerySize.height *
                        ScreenPercentage.SCREEN_SIZE_20.h,
                    width: mediaQuerySize.width *
                        ScreenPercentage.SCREEN_SIZE_100.w,
                    child: Image.asset(ImageResources.APP_LOGO)),
                Text(StringResources.TITLE,
                    style:
                        CustomTextStyles.customStyle(ColorsResources.BLACK_87))
              ],
            )),
      ),
    );
  }
}
