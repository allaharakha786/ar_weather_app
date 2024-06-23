import 'package:flutter/material.dart';
import 'package:weather/helper/constants/colors_resources.dart';
import 'package:weather/helper/constants/dimentions_resources.dart';

import '../../helper/utills/text_styles.dart';

// ignore: must_be_immutable
class CommonTextField extends StatelessWidget {
  TextEditingController? controller;
  Widget? prefixIcon;
  String? hintText;
  bool? isBorder;
  bool? isSuffix;
  Widget? suffixIcon;
  bool? readOnly;
  void Function(String)? onSubmitted;
  bool? obscureText;
  TextInputType? keyboardType;
  void Function()? onTap;
  String? Function(String?)? validator;

  CommonTextField(
      {super.key,
      this.suffixIcon,
      this.obscureText,
      this.controller,
      this.hintText,
      this.prefixIcon,
      this.validator,
      this.isBorder,
      this.onTap,
      this.isSuffix,
      this.keyboardType,
      this.readOnly,
      this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onSubmitted,
      obscureText: obscureText ?? false,
      readOnly: readOnly ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      validator: validator,
      controller: controller,
      style: CustomTextStyles.contentTextStyle(ColorsResources.WHITE_COLOR),
      decoration: InputDecoration(
          filled: isBorder ?? false,
          fillColor: ColorsResources.BLACK_26,
          enabledBorder: isBorder ?? false
              ? OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(DimensionsResource.RADIUS_SMALL),
                  borderSide: BorderSide(color: ColorsResources.WHITE_COLOR))
              : UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorsResources.WHITE_70)),
          border: isBorder ?? false
              ? const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(DimensionsResource.RADIUS_DEFAULT)))
              : null,
          focusedBorder: isBorder ?? false
              ? OutlineInputBorder(
                  borderSide: BorderSide(color: ColorsResources.WHITE_COLOR),
                  borderRadius:
                      BorderRadius.circular(DimensionsResource.RADIUS_DEFAULT))
              : null,
          prefixIcon: prefixIcon,
          suffixIcon: isSuffix ?? false
              ? GestureDetector(onTap: onTap, child: suffixIcon)
              : null,
          prefixIconColor: ColorsResources.WHITE_70,
          hintText: hintText,
          labelStyle:
              CustomTextStyles.contentTextStyle(ColorsResources.WHITE_70)),
    );
  }
}
