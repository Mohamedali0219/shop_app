import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/constant.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorite_model.dart';
import 'package:shop_app/models/favorite_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/shop_login_model.dart';
import 'package:shop_app/service/remote/dio_helper.dart';
import 'package:shop_app/service/remote/end_points.dart';
import 'package:shop_app/views/category_view.dart';
import 'package:shop_app/views/favourite_view.dart';
import 'package:shop_app/views/products_view.dart';
import 'package:shop_app/views/settings_view.dart';
part 'shop_state.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitial());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    const ProductsView(),
    const CategoryView(),
    const FavouriteView(),
    SettingsView(),
  ];
  void changeBottomNav(int index) {
    currentIndex = index;
    emit(
      ShopChangeNavBar(),
    );
  }

  HomeModel? homeModel;
  Map<int?, bool?> favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: home,
      token: token,
    ).then((value) {
      emit(ShopSuccessHomeDataState());
      homeModel = HomeModel.fromJson(value.data);

      for (var element in homeModel!.data!.products) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      }
      print(favorites);
    }).catchError((error) {
      // print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: categories,
      // token: token,
    ).then((value) {
      emit(ShopSuccessCategoriesState());
      categoriesModel = CategoriesModel.fromJson(value.data);
    }).catchError((error) {
      // print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoriteModel? changeFavoriteModel;
  void changeFavorites(int? productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavouriteState());

    DioHelper.postData(
      url: favorite,
      data: {'product_id': productId},
      token: token,
    ).then((value) {
      changeFavoriteModel = ChangeFavoriteModel.fromJson(value.data);
      if (!changeFavoriteModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorite();
      }
      //print(value.data);
      emit(ShopChangeSuccessFavouriteState(changeFavoriteModel));
    }).catchError(
      (error) {
        favorites[productId] = !favorites[productId]!;
        emit(ShopChangeErrorFavouriteState());
      },
    );
  }

  FavoriteModel? favoriteModel;

  void getFavorite() {
    emit(ShopLoadingGetFavoriteState());
    DioHelper.getData(
      url: favorite,
      token: token,
    ).then((value) {
      emit(ShopSuccessGetFavoriteState());

      favoriteModel = FavoriteModel.fromJson(value.data);
      print(favoriteModel);
    }).catchError((error) {
      // print(error.toString());
      emit(ShopErrorGetFavoriteState());
    });
  }

  ShopLoginModel? userDataModel;

  void getProfile() {
    emit(ShopLoadingGetFavoriteState());
    DioHelper.getData(
      url: profile,
      token: token,
    ).then((value) {
      emit((ShopSuccessGetProfileState()));

      userDataModel = ShopLoginModel.fromJson(value.data);

      print(userDataModel!.data!.name);
    }).catchError((error) {
      // print(error.toString());
      emit(ShopErrorGetProfileState());
    });
  }

  void upDateProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateProfileState());
    DioHelper.putData(url: updataProfile, token: token, data: {
      'name': name,
      'email': email,
      'phone': phone,
    }).then((value) {
      emit((ShopSuccessUpdateProfileState(userDataModel)));

      userDataModel = ShopLoginModel.fromJson(value.data);

      print(userDataModel!.data!.name);
    }).catchError((error) {
      // print(error.toString());
      emit(ShopErrorUpdateProfileState());
    });
  }
}
