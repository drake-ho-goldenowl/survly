import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:survly/src/features/authentication/logic/login_bloc.dart';
import 'package:survly/src/features/authentication/logic/sign_up_bloc.dart';
import 'package:survly/src/features/home/logic/home_bloc.dart';
import 'package:survly/src/router/router.dart';
import 'package:survly/src/theme/colors.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = GetIt.I<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignUpBloc(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
          ),
          fontFamily: "Quicksand",
          splashColor: Colors.black45
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
