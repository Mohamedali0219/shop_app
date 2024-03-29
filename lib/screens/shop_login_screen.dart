import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/constant.dart';
import 'package:shop_app/cubits/login_cubit/shop_login_cubit.dart';
import 'package:shop_app/cubits/login_cubit/shop_login_state.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/screens/shpo_register_screen.dart';
import 'package:shop_app/service/fuctions/flutter_toast.dart';
import 'package:shop_app/service/fuctions/navigator_fun.dart';
import 'package:shop_app/service/local/cache_helper.dart';
import 'package:shop_app/widgets/defult_buttons.dart';
import 'package:shop_app/widgets/defult_text_formfield.dart';

class ShopLoginScreen extends StatelessWidget {
  ShopLoginScreen({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel!.status!) {
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel!.data!.token,
              ).then((value) {
                token = state.loginModel!.data!.token;
                navigatAndReplace(
                  context,
                  const ShopLayout(),
                );
              });
              showToast(
                msg: state.loginModel!.message!,
                state: ToastStates.success,
              );
            } else {
              showToast(
                msg: state.loginModel!.message!,
                state: ToastStates.error,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 45,
                          ),
                        ),
                        const Text(
                          'Login to browse our products',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        defultTextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Enter your email',
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Your Email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defultTextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Enter your password',
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: ShopLoginCubit.get(context).suffixIcon,
                          obscureText: ShopLoginCubit.get(context).isPassword,
                          changeSuffixIcon: () {
                            ShopLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                          onFieldSubmitted: (value) {
                            if (formKey.currentState!.validate()) {
                              ShopLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Your Password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                            condition: state is! ShopLoginLoadingState,
                            builder: (context) => defultElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      ShopLoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  },
                                  text: 'Login',
                                ),
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator())),
                        Row(
                          children: [
                            const Text('Don\'t have an account?'),
                            deflutTextButton(
                              onPressed: () {
                                navigatTo(context, ShopRegisterScreen());
                              },
                              text: 'Register',
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
