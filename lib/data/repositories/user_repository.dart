import 'dart:io';

import 'package:surplus/data/models/json_response.dart';
import 'package:surplus/data/services/user_service.dart';

abstract class UserRepository {
  Future<JsonResponse> signIn({
    required int phone,
    required String password,
    required double lat,
    required double long,
  });

  Future<JsonResponse> signUp({
    required double lat,
    required double long,
    required String name,
    required String email,
    required String password,
    required int phone,
  });

  Future<JsonResponse> resetPassword({
    required int phone,
    required String password,
    required String reEnteredPassword,
  });

  Future<JsonResponse> updatePost(
    String title,
    String id,
    String description,
    List<File> images,
  );
  Future<JsonResponse> posts({
    int page = 0,
    required double lat,
    required double long,
    required String userId,
    required double range,
  });

  Future<JsonResponse> createPost(String userId, String title,
      String description, List<File> images, double lat, double long);

  Future<JsonResponse> updateProfile(
    String userId,
    String name,
    String email,
    int phone,
    File? image,
  );

  Future<JsonResponse> searchPost(
      String name, String userId, double lat, double long);

  Future<JsonResponse> getUserPosts({required String userId});

  Future<JsonResponse> getChats({required String userId});

  Future<JsonResponse> connectChat(
      {required String from, required String post, required String to});

  // blessPost
  Future<JsonResponse> blessPost({
    required String postId,
    required String userId,
  });

  // get post
  Future<JsonResponse> getPost({required String postId});
  Future<JsonResponse> getProfile({required String userId});
  Future<JsonResponse> deletePost({required String postId});
}

class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl({required this.service});

  final UserService service;

  @override
  Future<JsonResponse> signIn({
    required int phone,
    required String password,
    required double lat,
    required double long,
  }) {
    return service.signIn(
      phone: phone,
      password: password,
      lat: lat,
      long: long,
    );
  }

  @override
  Future<JsonResponse> signUp({
    required double lat,
    required double long,
    required String name,
    required String email,
    required String password,
    required int phone,
  }) {
    return service.signUp(
      lat: lat,
      long: long,
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
  }

  @override
  Future<JsonResponse> resetPassword({
    required int phone,
    required String password,
    required String reEnteredPassword,
  }) {
    return service.resetPassword(
      phone: phone,
      password: password,
      reEnteredPassword: reEnteredPassword,
    );
  }

  @override
  Future<JsonResponse> posts({
    int page = 0,
    required double lat,
    required double long,
    required String userId,
    required double range,
  }) =>
      service.posts(
          page: page, lat: lat, long: long, userId: userId, range: range);

  @override
  Future<JsonResponse> createPost(
    String userId,
    String title,
    String description,
    List<File> images,
    double lat,
    double long,
  ) =>
      service.createPost(
        userId: userId,
        title: title,
        description: description,
        images: images,
        lat: lat,
        long: long,
      );

  @override
  Future<JsonResponse> updatePost(
          String title, String id, String description, List<File> images) =>
      service.updatePost(title, id, description, images);

  @override
  Future<JsonResponse> searchPost(
          String name, String userId, double lat, double long) =>
      service.searchPost(name: name, userId: userId, lat: lat, long: long);

  @override
  Future<JsonResponse> getUserPosts({
    required String userId,
  }) =>
      service.getUserPosts(userId: userId);
  @override
  Future<JsonResponse> getChats({
    required String userId,
  }) =>
      service.getUserChats(userId: userId);

  @override
  Future<JsonResponse> updateProfile(
    String userId,
    String name,
    String email,
    int phone,
    File? image,
  ) =>
      service.updateProfile(
        userId,
        name,
        email,
        phone,
        image,
      );
  @override
  Future<JsonResponse> connectChat(
          {required String from, required String post, required String to}) =>
      service.connectChat(from: from, post: post, to: to);

  @override
  Future<JsonResponse> blessPost(
          {required String postId, required String userId}) =>
      service.blessPost(postId: postId, userId: userId);

  @override
  Future<JsonResponse> getPost({required String postId}) =>
      service.getPost(postId: postId);
  @override
  Future<JsonResponse> getProfile({required String userId}) =>
      service.getProfile(userId: userId);
  @override
  Future<JsonResponse> deletePost({required String postId}) =>
      service.deletePost(postId: postId);
}
