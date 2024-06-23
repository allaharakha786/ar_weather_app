import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather/businessLogic/blocs/apiBloc/api_bloc.dart';
import 'package:weather/businessLogic/blocs/apiBloc/api_events.dart';
import 'package:weather/businessLogic/blocs/apiBloc/api_states.dart';
import 'package:weather/helper/constants/colors_resources.dart';
import 'package:weather/helper/constants/dimentions_resources.dart';
import 'package:weather/helper/constants/image_resources.dart';
import 'package:weather/helper/constants/screen_percentage.dart';
import 'package:weather/helper/constants/string_resources.dart';
import 'package:weather/helper/data/list_data.dart';
import 'package:weather/helper/enums/status_enums.dart';
import 'package:weather/helper/utills/text_styles.dart';
import 'package:weather/presentation/widgets/common_textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  late ApiBloc bloc;
  @override
  void initState() {
    bloc = BlocProvider.of<ApiBloc>(context);
    bloc.add(GetApiDataEvent(context: context, city: StringResources.LAHORE));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuerySize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            body: BlocListener<ApiBloc, ApiStates>(
      listener: (context, state) {},
      child: BlocBuilder<ApiBloc, ApiStates>(builder: (context, state) {
        if (state.states == StatusEnums.LOADING_STATE) {
          return Container(
            height: mediaQuerySize.height * ScreenPercentage.SCREEN_SIZE_100.h,
            width: mediaQuerySize.width.w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    opacity: 0.5,
                    fit: BoxFit.cover,
                    image:
                        AssetImage(ImageResources.LOADING_BACKGROUND_IMAGE))),
            child: Center(
              child: CircularProgressIndicator(
                color: ColorsResources.BLACK_87,
              ),
            ),
          );
        }
        if (state.states == StatusEnums.API_DATA_LOADED) {
          var description =
              state.apiResponse!.weather[0].description.toLowerCase();
          var sunRiseTimeStamp = state.apiResponse!.sys.sunrise;
          DateTime sunRiseDateStamp =
              DateTime.fromMillisecondsSinceEpoch(sunRiseTimeStamp * 1000);
          String formattedSunrise =
              DateFormat('h:mm a').format(sunRiseDateStamp);
          var sunSetTimeStamp = state.apiResponse!.sys.sunset;
          DateTime sunSetDateStamp =
              DateTime.fromMillisecondsSinceEpoch(sunSetTimeStamp * 1000);
          String formattedSunSet = DateFormat('h:mm a').format(sunSetDateStamp);

          return Container(
              height: mediaQuerySize.height,
              width: mediaQuerySize.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      opacity: 0.3,
                      fit: BoxFit.cover,
                      image: description.contains('rain')
                          ? AssetImage(ImageResources.RAIN_BACKGROUND)
                          : description.contains('clouds')
                              ? AssetImage(ImageResources.CLOUDS_BACKGROUND)
                              : description.contains('dust')
                                  ? AssetImage(ImageResources.DUST_BACKGROUND)
                                  : AssetImage(
                                      ImageResources.CLEAR_SKY_BACKGROUND))),
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    height: mediaQuerySize.height *
                        ScreenPercentage.SCREEN_SIZE_7.h,
                    decoration: BoxDecoration(
                        color: ColorsResources.BLACK_26,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(
                                DimensionsResource.RADIUS_LARGE),
                            bottomLeft: Radius.circular(
                                DimensionsResource.RADIUS_LARGE))),
                    width: mediaQuerySize.width,
                    child: Center(
                      child: Text(
                        StringResources.TITLE,
                        style: TextStyle(
                            fontFamily: StringResources.SEGO_REGULAR,
                            color: ColorsResources.WHITE_COLOR,
                            fontSize:
                                DimensionsResource.FONT_SIZE_3X_EXTRA_MEDIUM),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(
                          DimensionsResource.PADDING_SIZE_EXTRA_SMALL),
                      child: CommonTextField(
                        controller: controller,
                        isBorder: true,
                        onSubmitted: (value) {
                          bloc.add(GetApiDataEvent(
                              context: context, city: controller.text));
                        },
                        isSuffix: true,
                        suffixIcon: Icon(
                          Icons.search,
                          color: ColorsResources.WHITE_COLOR,
                        ),
                        hintText: StringResources.SEARCH,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: DimensionsResource.PADDING_SIZE_DEFAULT),
                    child: Container(
                      height: mediaQuerySize.height *
                          ScreenPercentage.SCREEN_SIZE_47.h,
                      width: mediaQuerySize.width *
                          ScreenPercentage.SCREEN_SIZE_90.w,
                      decoration: BoxDecoration(
                        color: ColorsResources.BLACK_26,
                        borderRadius: BorderRadius.circular(
                            DimensionsResource.RADIUS_2X_EXTRA_LARGE.sp),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: DimensionsResource.PADDING_SIZE_SMALL,
                              bottom: DimensionsResource.PADDING_SIZE_SMALL),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                state.apiResponse!.name,
                                style: CustomTextStyles.customStyle(
                                    ColorsResources.WHITE_COLOR),
                              ),
                              Text(
                                DateFormat()
                                    .add_MMMMEEEEd()
                                    .format(DateTime.now()),
                                style: CustomTextStyles.contentTextStyle(
                                    ColorsResources.WHITE_COLOR),
                              ),
                              Divider(color: ColorsResources.GREY_COLOR),
                              SizedBox(
                                width: mediaQuerySize.width *
                                    ScreenPercentage.SCREEN_SIZE_30.w,
                                height: mediaQuerySize.height *
                                    ScreenPercentage.SCREEN_SIZE_15.h,
                                child: state.apiResponse!.weather[0].description
                                        .toLowerCase()
                                        .contains('clouds')
                                    ? Image.asset(ImageResources.CLOUDS_ICON)
                                    : state.apiResponse!.weather[0].description
                                            .toLowerCase()
                                            .contains('dust')
                                        ? Image.asset(ImageResources.DUST_ICON)
                                        : description.contains('rain')
                                            ? Image.asset(
                                                ImageResources.RAIN_ICON)
                                            : Image.asset(
                                                ImageResources.CLEAR_SKY_ICON),
                              ),
                              Text(
                                state.apiResponse!.weather[0].description
                                    .toUpperCase(),
                                style: CustomTextStyles.contentTextStyle(
                                    ColorsResources.WHITE_COLOR),
                              ),
                              Divider(color: ColorsResources.GREY_COLOR),
                              Text(
                                  '${StringResources.FEELS_LIKE}  ${(state.apiResponse!.main.feelsLike - 273.15).round().toString()}\u2103',
                                  style: CustomTextStyles.contentTextStyle(
                                      ColorsResources.WHITE_COLOR)),
                              Divider(
                                color: ColorsResources.GREY_COLOR,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left:
                                        DimensionsResource.PADDING_SIZE_DEFAULT,
                                    right: DimensionsResource
                                        .PADDING_SIZE_DEFAULT),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '${StringResources.MIN_TEMP}  ${(state.apiResponse!.main.tempMin - 273.15).round().toString()}\u2103',
                                      style: CustomTextStyles.contentTextStyle(
                                          ColorsResources.WHITE_COLOR),
                                    ),
                                    Text(
                                      '${StringResources.MAX_TEMP} ${(state.apiResponse!.main.tempMax - 267.15).round().toString()}\u2103',
                                      style: CustomTextStyles.contentTextStyle(
                                          ColorsResources.WHITE_COLOR),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                color: ColorsResources.GREY_COLOR,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left:
                                        DimensionsResource.PADDING_SIZE_DEFAULT,
                                    right: DimensionsResource
                                        .PADDING_SIZE_DEFAULT),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '${StringResources.HUMIDTY} ${state.apiResponse!.main.humidity}%',
                                      style: CustomTextStyles.contentTextStyle(
                                          ColorsResources.WHITE_COLOR),
                                    ),
                                    Text(
                                      '${StringResources.AIR_SPEED}  ${(state.apiResponse!.wind.speed).round()} KM/H',
                                      style: CustomTextStyles.contentTextStyle(
                                          ColorsResources.WHITE_COLOR),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                color: ColorsResources.GREY_COLOR,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left:
                                        DimensionsResource.PADDING_SIZE_DEFAULT,
                                    right: DimensionsResource
                                        .PADDING_SIZE_DEFAULT),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '${StringResources.SUNRISE} $formattedSunrise',
                                      style: CustomTextStyles.contentTextStyle(
                                          ColorsResources.WHITE_COLOR),
                                    ),
                                    Text(
                                      '${StringResources.SUNSET} $formattedSunSet',
                                      style: CustomTextStyles.contentTextStyle(
                                          ColorsResources.WHITE_COLOR),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    StringResources.OTHER_CITIES,
                    style: CustomTextStyles.contentTextStyle(
                        ColorsResources.WHITE_COLOR),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                          4,
                          (index) => Padding(
                                padding: const EdgeInsets.all(DimensionsResource
                                    .PADDING_SIZE_EXTRA_SMALL),
                                child: GestureDetector(
                                  onTap: () {
                                    bloc.add(GetApiDataEvent(
                                        context: context,
                                        city: ListData.cities[index]));

                                    controller.text = ListData.cities[index];
                                  },
                                  child: Container(
                                    height: mediaQuerySize.height *
                                        ScreenPercentage.SCREEN_SIZE_15.h,
                                    width: mediaQuerySize.width *
                                        ScreenPercentage.SCREEN_SIZE_32.w,
                                    decoration: BoxDecoration(
                                        color: ColorsResources.BLACK_12,
                                        borderRadius: BorderRadius.circular(
                                            DimensionsResource
                                                .RADIUS_LARGE.sp)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          DimensionsResource
                                              .PADDING_SIZE_SMALL),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Image.asset(
                                                ListData.imagePath[index]),
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: DimensionsResource
                                                        .PADDING_SIZE_SMALL),
                                                child: Text(
                                                  ListData.cities[index],
                                                  style: CustomTextStyles
                                                      .contentTextStyle(
                                                          ColorsResources
                                                              .WHITE_COLOR),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                    ),
                  )
                ]),
              ));
        }
        return Container();
      }),
    )));
  }
}
