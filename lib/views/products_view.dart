import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/shop_cubit/shop_cubit.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/service/fuctions/colors.dart';
import 'package:shop_app/service/fuctions/flutter_toast.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        //! this in the case of the token is not founded
        if (state is ShopChangeSuccessFavouriteState) {
          if (!state.changeFavoriteModel!.status!) {
            showToast(
                msg: state.changeFavoriteModel!.message!,
                state: ToastStates.error);
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).homeModel != null &&
              ShopCubit.get(context).categoriesModel != null,
          builder: (context) => ProductsBuilder(
              homeModel: ShopCubit.get(context).homeModel,
              categoriesModel: ShopCubit.get(context).categoriesModel),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class ProductsBuilder extends StatelessWidget {
  const ProductsBuilder(
      {super.key, required this.homeModel, required this.categoriesModel});

  final HomeModel? homeModel;
  final CategoriesModel? categoriesModel;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: homeModel!.data!.banners
                .map(
                  (e) => Image.network(
                    '${e.image}',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: 250,
              initialPage: 0,
              viewportFraction: 1,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(seconds: 1),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return CategoryItem(
                          dataModel: categoriesModel!.data!.data[index],
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            width: 5,
                          ),
                      itemCount: categoriesModel!.data!.data.length),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'New Products',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 1 / 1.62,
              children: List.generate(
                homeModel!.data!.products.length,
                (index) => BuildGridProduct(
                    productsModel: homeModel!.data!.products[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.dataModel,
  });
  final DataModel? dataModel;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Image(
          image: NetworkImage('${dataModel!.image}'),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(0.7),
          width: 100,
          child: Text(
            '${dataModel!.name}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}

class BuildGridProduct extends StatelessWidget {
  const BuildGridProduct({super.key, required this.productsModel});
  final ProductsModel? productsModel;

  @override
  Widget build(BuildContext context) {
    var heigthScreen = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage(
                      '${productsModel!.image}',
                    ),
                    width: double.infinity,
                    height: heigthScreen * 0.2,
                  ),
                  if (productsModel!.discount != 0)
                    Container(
                      color: Colors.red,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        child: Text(
                          'DISCOUNT',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Text(
                '${productsModel!.name}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    //  fontSize: 16,
                    ),
              ),
              Row(
                children: [
                  Text(
                    '${productsModel!.price}',
                    style: TextStyle(
                      fontSize: 14,
                      color: defultAppColor,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  if (productsModel!.discount != 0)
                    Text(
                      '${productsModel!.oldPrice}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      ShopCubit.get(context).changeFavorites(
                        productsModel!.id,
                      );
                      print(productsModel!.id);
                    },
                    icon: CircleAvatar(
                      radius: 15,
                      backgroundColor:
                          ShopCubit.get(context).favorites[productsModel!.id]!
                              ? Colors.red
                              : Colors.grey,
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
