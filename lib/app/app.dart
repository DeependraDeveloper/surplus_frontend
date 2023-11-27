import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surplus/bloc/auth/authentication_bloc.dart';
import 'package:surplus/bloc/chat/chat_bloc.dart';
import 'package:surplus/bloc/friend/friend_posts_bloc.dart';
import 'package:surplus/bloc/location/location_bloc.dart';
import 'package:surplus/bloc/post/post_bloc.dart';
import 'package:surplus/bloc/profile_posts/profile_posts_bloc.dart';
import 'package:surplus/bloc/user/user_bloc.dart';
import 'package:surplus/data/repositories/location_repositry.dart';
import 'package:surplus/data/repositories/user_repository.dart';
import 'package:surplus/data/services/location_service.dart';
import 'package:surplus/data/services/user_service.dart';
import 'package:surplus/utils/routes.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationBloc>(
          lazy: false,
          create: (context) => LocationBloc(
            locationRepository: LocationRepositoryImpl(
              locationService: LocationService(),
            ),
          )
            ..add(LocationPermissionEvent())
            ..add(RequestLocationPermissionEvent())
            ..add(CurrentLocationEvent()),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(
            authBloc: BlocProvider.of<AuthenticationBloc>(context),
            repository: UserRepositoryImpl(
              service: UserService(
                dio: Dio(),
              ),
            ),
          ),
        ),
        BlocProvider<ProfilePostsBloc>(
          create: (context) => ProfilePostsBloc(
            repository: UserRepositoryImpl(
              service: UserService(
                dio: Dio(),
              ),
            ),
          )..add(UserPostLoadEvent(
              userId: BlocProvider.of<UserBloc>(context).state.user.id ?? '')),
        ),
        BlocProvider<PostBloc>(
          create: (context) => PostBloc(
            repository: UserRepositoryImpl(
              service: UserService(
                dio: Dio(),
              ),
            ),
          ),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(
            userBloc: BlocProvider.of<UserBloc>(context),
            repository: UserRepositoryImpl(
              service: UserService(
                dio: Dio(),
              ),
            ),
          )..add(const LoadChatsEvent()),
        ),
        BlocProvider<FriendPostsBloc>(
          create: (context) => FriendPostsBloc(
            repository: UserRepositoryImpl(
              service: UserService(
                dio: Dio(),
              ),
            ),
          ),
        ),
      ],
      child: BlocBuilder<UserBloc, UserState>(
        buildWhen: (p, c) => p.user.id != c.user.id,
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter(
              authBloc: context.read<AuthenticationBloc>(),
            ).router,
          );
        },
      ),
    );
  }
}
