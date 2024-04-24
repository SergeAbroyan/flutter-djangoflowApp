import 'package:npua_project/middlewares/bloc/auth_bloc/auth_bloc.dart';
import 'package:npua_project/middlewares/bloc/auth_bloc/auth_event.dart';
import 'package:npua_project/middlewares/bloc/auth_bloc/auth_state.dart';
import 'package:npua_project/middlewares/enum/drawer_type_enum.dart';
import 'package:npua_project/middlewares/provider_injectors/provider_injector.dart';
import 'package:npua_project/middlewares/repositories/implementation/storage_repository_implement.dart';
import 'package:npua_project/screens/admin/admin_screen.dart';
import 'package:npua_project/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AuthBloc _authBloc;

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
        create: (context) =>
            _authBloc = AuthBloc(StorageRepositoryImp())..add(AppStartEvent()),
        child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) => MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routeInformationProvider:
                    AppRouter._router(state).routeInformationProvider,
                routeInformationParser:
                    AppRouter._router(state).routeInformationParser,
                routerDelegate: AppRouter._router(state).routerDelegate)));
  }
}

class AppRouter {
  static const root = '/';
  static const login = '/login';
  static String home([DrawerTypesEnum? type]) => '/${type?.name ?? ':type'}';

  static Widget _homePageRouteBuilder(
          BuildContext context, GoRouterState state) =>
      ProviderInjector(
          drawerTypes: GetDrawerType(state.params['type'] as String).type(),
          child: const AdminScreen());

  static Widget _loginScreenRouteBuilder(
          BuildContext context, GoRouterState state) =>
      const LoginScreen();

  static GoRouter _router(AuthState authState) {
    return GoRouter(routes: <GoRoute>[
      GoRoute(path: root, builder: _loginScreenRouteBuilder),
      GoRoute(path: login, builder: _loginScreenRouteBuilder),
      GoRoute(path: home(), builder: _homePageRouteBuilder)
    ]);
  }
}
