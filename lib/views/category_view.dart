import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/shop_cubit/shop_cubit.dart';
import 'package:shop_app/models/categories_model.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.builder(
          itemBuilder: (context, index) => BuildCategoryItem(
            dataModel:
                ShopCubit.get(context).categoriesModel!.data!.data[index],
          ),
          itemCount: ShopCubit.get(context).categoriesModel!.data!.data.length,
        );
      },
    );
  }
}

class BuildCategoryItem extends StatelessWidget {
  const BuildCategoryItem({super.key, required this.dataModel});
  final DataModel? dataModel;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Image(
            image: NetworkImage('${dataModel!.image}'),
            width: screenWidth * 0.2,
            height: screenHeight * 0.1,
            // fit: BoxFit.cover,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            '${dataModel!.name}',
            style: const TextStyle(fontSize: 20),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
