import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/cubit/search_cubit.dart';
import 'package:shop_app/widgets/defult_text_formfield.dart';
import 'package:shop_app/widgets/product_item.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    var formkey = GlobalKey<FormState>();
    var searchController = TextEditingController();
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(),
              body: Form(
                key: formkey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      defultTextFormField(
                        controller: searchController,
                        hintText: 'Search',
                        prefixIcon: Icons.search,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Search must not be empty';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          if (formkey.currentState!.validate()) {
                            SearchCubit.get(context).productSearch(value);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (state is SearchLoadingState)
                        const LinearProgressIndicator(),
                      if (state is SearchSuccessState)
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) => ProductsItem(
                              isOldPrice: false,
                              productModel: SearchCubit.get(context)
                                  .searchModel!
                                  .data!
                                  .data![index],
                            ),
                            separatorBuilder: (context, index) => const Divider(
                              thickness: 1,
                              indent: 10,
                              endIndent: 10,
                            ),
                            itemCount: SearchCubit.get(context)
                                .searchModel!
                                .data!
                                .data!
                                .length,
                          ),
                        )
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
