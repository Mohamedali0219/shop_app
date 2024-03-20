import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/shop_cubit/shop_cubit.dart';
import 'package:shop_app/models/favorite_model.dart';
import 'package:shop_app/service/fuctions/colors.dart';
import 'package:shop_app/widgets/product_item.dart';

class FavouriteView extends StatelessWidget {
  const FavouriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is! ShopLoadingGetFavoriteState,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) => ProductsItem(
              productModel: ShopCubit.get(context)
                  .favoriteModel!
                  .data!
                  .data![index]
                  .product,
            ),
            separatorBuilder: (context, index) => const Divider(
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            itemCount: ShopCubit.get(context).favoriteModel!.data!.data!.length,
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class FavouriteItem extends StatelessWidget {
  const FavouriteItem({super.key, required this.favoriteData});
  final FavoriteData? favoriteData;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(
                    '${favoriteData!.product!.image}',
                  ),
                  width: 120,
                  height: 120,
                ),
                if (favoriteData!.product!.discount != 0)
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
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${favoriteData!.product!.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        //  fontSize: 16,
                        ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '${favoriteData!.product!.price}',
                        style: TextStyle(
                          fontSize: 14,
                          color: defultAppColor,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      if (favoriteData!.product!.discount != 0)
                        Text(
                          '${favoriteData!.product!.oldPrice}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context)
                              .changeFavorites(favoriteData!.product!.id);
                        },
                        icon: CircleAvatar(
                          radius: 15,
                          backgroundColor: ShopCubit.get(context)
                                  .favorites[favoriteData!.product!.id]!
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
            )
          ],
        ),
      ),
    );
  }
}
