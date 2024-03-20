//! this is the same with the favouriteItem i use only productModel i can use it the => together[search, favorite]
import 'package:flutter/material.dart';
import 'package:shop_app/cubits/shop_cubit/shop_cubit.dart';
import 'package:shop_app/service/fuctions/colors.dart';

class ProductsItem extends StatelessWidget {
  const ProductsItem(
      {super.key, required this.productModel, this.isOldPrice = true});

  final dynamic productModel;
  final bool isOldPrice;

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
                    '${productModel!.image}',
                  ),
                  width: 120,
                  height: 120,
                ),
                if (productModel!.discount != 0 && isOldPrice)
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
                    '${productModel!.name}',
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
                        '${productModel!.price}',
                        style: TextStyle(
                          fontSize: 14,
                          color: defultAppColor,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      if (productModel!.discount != 0 && isOldPrice)
                        Text(
                          '${productModel!.oldPrice}',
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
                              .changeFavorites(productModel!.id);
                        },
                        icon: CircleAvatar(
                          radius: 15,
                          backgroundColor: ShopCubit.get(context)
                                  .favorites[productModel!.id]!
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
