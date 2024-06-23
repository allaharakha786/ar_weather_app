import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/businessLogic/blocs/apiBloc/api_events.dart';
import 'package:weather/businessLogic/blocs/apiBloc/api_states.dart';
import 'package:weather/helper/constants/string_resources.dart';
import 'package:weather/helper/enums/status_enums.dart';
import 'package:http/http.dart' as http;
import 'package:weather/presentation/widgets/alert_dialog.dart';
import 'package:weather/providerDataModel/model/apiModels/api_response_model.dart';

class ApiBloc extends Bloc<ApiEvents, ApiStates> {
  ApiBloc() : super(ApiStates(states: StatusEnums.INITIAL_STATE)) {
    on<GetApiDataEvent>(getApiData);
  }

  getApiData(GetApiDataEvent event, Emitter<ApiStates> emit) async {
    try {
      emit(state.copyWith(states: StatusEnums.LOADING_STATE));
      var url =
          'https://api.openweathermap.org/data/2.5/weather?q=${event.city}&lang=en&appid=b02af426a3fad0d92d3e0b32f9324cf0';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        dynamic jsonDecodeData = response.body;
        emit(state.copyWith(
            states: StatusEnums.API_DATA_LOADED,
            apiResponse: apiResponseFromJson(jsonDecodeData)));
        if (response.statusCode == 404 ||
            response.statusCode == 403 ||
            response.statusCode == 402 ||
            response.statusCode == 401) {
          // ignore: use_build_context_synchronously
          AwesomeDialogAlert.showDialogAlert(event.context, DialogType.error,
              StringResources.ERROR_ALERT, StringResources.ERROR_404, () {});
          emit(state.copyWith(
              states: StatusEnums.API_DATA_LOADED,
              errorMessage: response.statusCode.toString()));
        }
      } else {
        // ignore: use_build_context_synchronously
        AwesomeDialogAlert.showDialogAlert(event.context, DialogType.error,
            StringResources.ERROR_ALERT, StringResources.ERROR_404, () {});
        emit(state.copyWith(
            states: StatusEnums.API_DATA_LOADED,
            errorMessage: response.statusCode.toString()));
      }
    } catch (e) {
      emit(state.copyWith(
          states: StatusEnums.API_DATA_LOADED, errorMessage: e.toString()));
    }
  }
}
