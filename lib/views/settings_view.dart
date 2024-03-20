import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/constant.dart';
import 'package:shop_app/cubits/shop_cubit/shop_cubit.dart';
import 'package:shop_app/widgets/defult_buttons.dart';
import 'package:shop_app/widgets/defult_text_formfield.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        //! in this the states will changes very fast and it can not get the data
        // if (state is ShopSuccessGetProfileState) {
        //   nameController.text =
        //       ShopCubit.get(context).userDataModel!.data!.name!;
        //   emailController.text =
        //       ShopCubit.get(context).userDataModel!.data!.email!;
        //   phoneController.text =
        //       ShopCubit.get(context).userDataModel!.data!.phone!;
        // }
      },
      builder: (context, state) {
        //! it good to play with model and not play with states
        var userModel = ShopCubit.get(context).userDataModel!.data;
        nameController.text = userModel!.name!;
        emailController.text = userModel.email!;
        phoneController.text = userModel.phone!;
        return ConditionalBuilder(
          condition: ShopCubit.get(context).userDataModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if (state is ShopLoadingUpdateProfileState)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 20,
                  ),
                  defultTextFormField(
                    controller: nameController,
                    hintText: 'Name',
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name must not be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  defultTextFormField(
                    controller: emailController,
                    hintText: 'email',
                    prefixIcon: Icons.email,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name must not be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  defultTextFormField(
                    controller: phoneController,
                    hintText: 'Phone',
                    prefixIcon: Icons.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name must not be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  defultElevatedButton(
                      onPressed: () {
                        signOut(context);
                      },
                      text: 'LOGOUT'),
                  const SizedBox(
                    height: 10,
                  ),
                  defultElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          ShopCubit.get(context).upDateProfile(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                          );
                        }
                      },
                      text: 'UPDATE'),
                ],
              ),
            ),
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
