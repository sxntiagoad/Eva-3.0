import 'package:eva/presentation/admin/screens/admin_panel_screen.dart';
import 'package:eva/presentation/admin/screens/car_management_page.dart';
import 'package:go_router/go_router.dart';

import '../../models/preoperacional.dart';
import '../../presentation/forgot_password/screens/forgot_password_screen.dart';
import '../../presentation/home/screens/home_screen.dart';
import '../../presentation/is_authenticated/screen/is_authenticated.dart';
import '../../presentation/list_preoperacionales.dart/screens/list_preoperacionales_screen.dart';
import '../../presentation/login/screens/login_screen.dart';
import '../../presentation/new_preoperacional/screens/new_preoperacional_scree.dart';
import '../../presentation/preoperacional/screens/preoperacional_screen.dart';
import '../../presentation/register/screens/register_screen.dart';
import '../../presentation/user_data/screens/user_data_screen.dart';
import '../../presentation/admin/screens/admin_cars.dart';

final appRouter = GoRouter(
  initialLocation: '/${IsAuthenticated.name}',
  routes: [
    GoRoute(
      path: '/${ListPreoperacionalesScreen.name}',
      name: ListPreoperacionalesScreen.name,
      builder: (context, state) => const ListPreoperacionalesScreen(),
    ),
    GoRoute(
      path: '/${IsAuthenticated.name}',
      name: IsAuthenticated.name,
      builder: (context, state) => const IsAuthenticated(),
    ),
    GoRoute(
      path: '/${LoginScreen.name}',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/${RegisterScreen.name}',
      name: RegisterScreen.name,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/${ForgotPasswordScreen.name}',
      name: ForgotPasswordScreen.name,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/${HomeScreen.name}',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/${UserDataScreen.name}',
      name: UserDataScreen.name,
      builder: (context, state) => const UserDataScreen(),
    ),

    GoRoute(
      path: '/${NewPreoperacionalScree.name}',
      name: NewPreoperacionalScree.name,
      builder: (context, state) => const NewPreoperacionalScree(),
    ),

    GoRoute(
      path: '/${PreoperacionalScreen.name}',
      name: PreoperacionalScreen.name,
      builder: (context, state) {
        final preoperacional = state.extra as Preoperacional;
        return PreoperacionalScreen(
          preoperacional: preoperacional,
        );
      },
    ),
    GoRoute(
      path: '/${AdminPanelScreen.name}',
      name: AdminPanelScreen.name,
      builder: (context, state) => const AdminPanelScreen(),
    ),
    GoRoute(
      path: '/${AdminCars.name}',
      name: AdminCars.name,
      builder: (context, state) => const AdminCars(),
    ),
    GoRoute(
      path: '/${CarManagementPage.name}',
      name: CarManagementPage.name,
      builder: (context, state) => const CarManagementPage(),
    ),

  ],
);
