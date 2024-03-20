part of 'shop_cubit.dart';

sealed class ShopStates {}

final class ShopInitial extends ShopStates {}

final class ShopChangeNavBar extends ShopStates {}

final class ShopLoadingHomeDataState extends ShopStates {}

final class ShopSuccessHomeDataState extends ShopStates {}

final class ShopErrorHomeDataState extends ShopStates {}

final class ShopSuccessCategoriesState extends ShopStates {}

final class ShopErrorCategoriesState extends ShopStates {}

final class ShopChangeFavouriteState extends ShopStates {}

final class ShopChangeSuccessFavouriteState extends ShopStates {
  ChangeFavoriteModel? changeFavoriteModel;
  ShopChangeSuccessFavouriteState(this.changeFavoriteModel);
}

final class ShopChangeErrorFavouriteState extends ShopStates {}

final class ShopLoadingGetFavoriteState extends ShopStates {}

final class ShopSuccessGetFavoriteState extends ShopStates {}

final class ShopErrorGetFavoriteState extends ShopStates {}

final class ShopLoadingGetProfileState extends ShopStates {}

final class ShopSuccessGetProfileState extends ShopStates {}

final class ShopErrorGetProfileState extends ShopStates {}

final class ShopLoadingUpdateProfileState extends ShopStates {}

final class ShopSuccessUpdateProfileState extends ShopStates {
  ShopLoginModel? loginModel;
  ShopSuccessUpdateProfileState(this.loginModel);
}

final class ShopErrorUpdateProfileState extends ShopStates {}
