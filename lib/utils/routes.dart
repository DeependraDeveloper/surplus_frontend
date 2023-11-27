import 'package:go_router/go_router.dart';
import 'package:surplus/bloc/auth/authentication_bloc.dart';
import 'package:surplus/data/models/chat.dart';
import 'package:surplus/data/models/post.dart';
import 'package:surplus/data/models/user.dart';
import 'package:surplus/views/chat/chat_screen.dart';
import 'package:surplus/views/chat/message_screen.dart';
import 'package:surplus/views/friend/friend_screen.dart';
import 'package:surplus/views/navigation_screen.dart';
import 'package:surplus/views/home/post_detail_screen.dart';
import 'package:surplus/views/profile/update_post.dart';
import 'package:surplus/views/initial/initial_screen.dart';
import 'package:surplus/views/login/login_screen.dart';
import 'package:surplus/views/login/reset_password_screen.dart';
import 'package:surplus/views/login/signup_screen.dart';
import 'package:surplus/views/profile/update_profile.dart';

class AppRouter {
  AppRouter({required this.authBloc}) {
    _router = GoRouter(
      routes: [
        GoRoute(
          path: '/initial_screen',
          name: 'initial_screen',
          builder: (context, state) => const InitialScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
          routes: [
            GoRoute(
              path: 'signUp',
              name: 'signUp',
              builder: (context, state) => const SignUpScreen(),
            ),
            GoRoute(
              path: 'reset_password',
              name: 'reset_password',
              builder: (context, state) => const ResetPasswordScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const NavigationPage(),
          routes: [
            GoRoute(
              path: 'detail',
              name: 'detail',
              builder: (context, state) => PostDetail(
                // post: state.extra as Post,
              ),
            ),
            GoRoute(
              path: 'chat',
              name: 'chat',
              builder: (context, state) => ChatScreen(
                chat: state.extra as Chat,
              ),
            ),
            GoRoute(
              path: 'message',
              name: 'message',
              builder: (context, state) => const MessageScreen(),
            ),
            GoRoute(
              path: 'friend',
              name: 'friend',
              builder: (context, state) => FriendProfile(
                friend: state.extra as User,
              ),
            ),
            GoRoute(
              path: 'updatePost',
              name: 'updatePost',
              builder: (context, state) => UpdatePostScreen(
                model: state.extra as Post,
              ),
            ),
            GoRoute(
              path: 'editProfile',
              name: 'editProfile',
              builder: (context, state) => UpdateProfileScreen(
                model: state.extra as User,
              ),
            ),
          ],
        ),
      ],
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: authBloc,
      routerNeglect: true,
      redirect: (context, state) {
        final bool isSignInRoute = state.matchedLocation.startsWith('/login');

        final bool isAuthenticated =
            authBloc.state == AuthenticationState.authenticated;
        if (isSignInRoute && isAuthenticated) {
          return '/';
        } else if (!isSignInRoute && !isAuthenticated) {
          return '/initial_screen';
        }
        return null;

        // if (!isAuthenticated && !isSignInRoute) {
        //   return '/login';
        // } else if (isAuthenticated && isSignInRoute) {
        //   return '/';
        // }
        // return null;
      },
    );
  }

  final AuthenticationBloc authBloc;
  late final GoRouter _router;
  GoRouter get router => _router;
}
