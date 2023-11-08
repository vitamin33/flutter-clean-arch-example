import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cleanarch_example/src/config/router/app_router.dart';
import 'package:flutter_cleanarch_example/src/config/themes/app_theme.dart';
import 'package:flutter_cleanarch_example/src/domain/repositories/api_repository.dart';
import 'package:flutter_cleanarch_example/src/domain/repositories/database_repository.dart';
import 'package:flutter_cleanarch_example/src/locator.dart';
import 'package:flutter_cleanarch_example/src/presentation/cubits/local_articles/local_articles_cubit.dart';
import 'package:flutter_cleanarch_example/src/presentation/cubits/remote_articles/remote_articles_cubit.dart';
import 'package:flutter_cleanarch_example/src/utils/constants/strings.dart';
import 'package:oktoast/oktoast.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocalArticlesCubit(
            locator<DatabaseRepository>(),
          )..getAllSavedArticles(),
        ),
        BlocProvider(
          create: (context) => RemoteArticlesCubit(
            locator<ApiRepository>(),
          )..getBreakingNewsArticles(),
        )
      ],
      child: OKToast(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerDelegate: appRouter.delegate(),
          routeInformationParser: appRouter.defaultRouteParser(),
          title: appTitle,
          theme: AppTheme.light,
        ),
      ),
    );
  }
}
