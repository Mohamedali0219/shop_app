import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/constant.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/service/remote/dio_helper.dart';
import 'package:shop_app/service/remote/end_points.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;
  void productSearch(String text) {
    emit(SearchLoadingState());

    DioHelper.postData(
      url: search,
      token: token,
      data: {
        'text': text,
      },
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((e) {
      emit(SearchErrorState());
    });
  }
}
