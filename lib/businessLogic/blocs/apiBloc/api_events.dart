import 'package:flutter/material.dart';

class ApiEvents {}

class GetApiDataEvent extends ApiEvents {
  String city;
  BuildContext context;
  GetApiDataEvent({required this.city, required this.context});
}
