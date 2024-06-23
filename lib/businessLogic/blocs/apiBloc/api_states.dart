import 'package:weather/helper/enums/status_enums.dart';
import 'package:weather/providerDataModel/model/apiModels/api_response_model.dart';

class ApiStates {
  StatusEnums states;
  final ApiResponse? apiResponse;
  String errorMessage;
  ApiStates(
      {this.states = StatusEnums.INITIAL_STATE,
      this.apiResponse,
      this.errorMessage = ''});
  ApiStates copyWith(
      {StatusEnums? states, String? errorMessage, ApiResponse? apiResponse}) {
    return ApiStates(
        apiResponse: apiResponse ?? this.apiResponse,
        errorMessage: errorMessage ?? this.errorMessage,
        states: states ?? this.states);
  }

  List<Object>? get props => [apiResponse!, states, errorMessage];
}
