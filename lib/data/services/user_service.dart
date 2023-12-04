import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:surplus/data/models/chat.dart';
import 'package:surplus/data/models/json_response.dart';
import 'package:surplus/data/models/post.dart';
import 'package:surplus/data/models/user.dart';
import 'package:surplus/utils/constants.dart';
import 'package:path/path.dart' show basename;

class UserService {
  UserService({required this.dio}) {
    dio.options.baseUrl = kURL;
    dio.options.sendTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.responseType = ResponseType.json;
    dio.options.contentType = Headers.jsonContentType;
    dio.interceptors.add(LogInterceptor(
        // requestBody: true,
        // responseBody: true,
        ));
  }

  final Dio dio;

  Future<JsonResponse> signIn({
    required int phone,
    required String password,
    required double lat,
    required double long,
  }) async {
    try {
      final data = <String, dynamic>{
        'phone': phone,
        'password': password,
        'lat': lat,
        'long': long
      };

      if (!kIsWeb) {
        final deviceToken = await FirebaseMessaging.instance.getToken();
        if (deviceToken != null) {
          data['deviceToken'] = deviceToken;
        }
      }

      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final info = await deviceInfoPlugin.deviceInfo;

      if (info is AndroidDeviceInfo) {
        data['deviceType'] = 'android';
        data['deviceName'] = info.model;
        data['deviceVersion'] = '${info.version.sdkInt}';
        data['deviceManufacturer'] = info.manufacturer;
        data['deviceBrand'] = info.brand;
        data['deviceIsPhysical'] = '${info.isPhysicalDevice}';
      } else if (info is IosDeviceInfo) {
        data['deviceType'] = 'ios';
        data['deviceName'] = info.model;
        data['deviceVersion'] = info.systemVersion;
        data['deviceManufacturer'] = info.utsname.machine;
        data['deviceBrand'] = info.utsname.machine;
        data['deviceIsPhysical'] = '${info.isPhysicalDevice}';
      } else if (info is WebBrowserInfo) {
        data['deviceType'] = 'web';
        data['deviceName'] = info.userAgent ?? 'unknown';
        data['deviceVersion'] = info.userAgent ?? 'unknown';
        data['deviceManufacturer'] = 'unknown';
        data['deviceBrand'] = 'unknown';
        data['deviceIsPhysical'] = 'true';
      }

      final response = await dio.post(
        kAuth,
        data: data,
      );

      if (response.statusCode == 200) {
        final data = User.fromJson(response.data ?? <String, dynamic>{});

        return JsonResponse.success(
          message: 'Signed In Successfully!',
          data: data,
        );
      } else if (response.statusCode == 422) {
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: 'Validation error: ',
        );
      } else {
        final error = response.data?["message"]?.toString();
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: error ?? 'something went wrong!',
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data?["message"]?.toString();
      return JsonResponse.failure(
        message: error.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } on Exception catch (_) {
      return JsonResponse.failure(
        message: 'Something went wrong!',
      );
    }
  }

  Future<JsonResponse> signUp({
    required double lat,
    required double long,
    required String name,
    required String email,
    required String password,
    required int phone,
  }) async {
    try {
      var data = {
        'lat': lat,
        'long': long,
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      };

      if (!kIsWeb) {
        final deviceToken = await FirebaseMessaging.instance.getToken();
        if (deviceToken != null) {
          data['deviceToken'] = deviceToken;
        }
      }

      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final info = await deviceInfoPlugin.deviceInfo;

      if (info is AndroidDeviceInfo) {
        data['deviceType'] = 'android';
        data['deviceName'] = info.model;
        data['deviceVersion'] = '${info.version.sdkInt}';
        data['deviceManufacturer'] = info.manufacturer;
        data['deviceBrand'] = info.brand;
        data['deviceIsPhysical'] = '${info.isPhysicalDevice}';
      } else if (info is IosDeviceInfo) {
        data['deviceType'] = 'ios';
        data['deviceName'] = info.model;
        data['deviceVersion'] = info.systemVersion;
        data['deviceManufacturer'] = info.utsname.machine;
        data['deviceBrand'] = info.utsname.machine;
        data['deviceIsPhysical'] = '${info.isPhysicalDevice}';
      } else if (info is WebBrowserInfo) {
        data['deviceType'] = 'web';
        data['deviceName'] = info.userAgent ?? 'unknown';
        data['deviceVersion'] = info.userAgent ?? 'unknown';
        data['deviceManufacturer'] = 'unknown';
        data['deviceBrand'] = 'unknown';
        data['deviceIsPhysical'] = 'true';
      }

      final response = await dio.post(kSignUp, data: data);

      if (response.statusCode == 201) {
        final data = User.fromJson(response.data ?? <String, dynamic>{});
        return JsonResponse.success(
          message: 'Signed Up Successfully!',
          data: data,
        );
      } else if (response.statusCode == 422) {
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: 'Validation error: ',
        );
      } else {
        final error = response.data?["message"]?.toString();
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: error ?? 'something went wrong!',
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data["message"]?.toString();
      return JsonResponse.failure(
        message: error.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } on Exception catch (_) {
      return JsonResponse.failure(
        message: 'Something went wrong!',
      );
    }
  }

  Future<JsonResponse> resetPassword({
    required String password,
    required String reEnteredPassword,
    required int phone,
  }) async {
    try {
      final response = await dio.post(kResetPassword, data: {
        'password': password,
        'reEnteredPassword': reEnteredPassword,
        'phone': phone,
      });

      if (response.statusCode == 200) {
        final data = User.fromJson(response.data ?? <String, dynamic>{});
        return JsonResponse.success(
          message: 'Resetted Password Successfully!',
          data: data,
        );
      } else if (response.statusCode == 422) {
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: 'Validation error: ',
        );
      } else {
        final error = response.data?["message"]?.toString();
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: error ?? 'something went wrong!',
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data["message"]?.toString();
      return JsonResponse.failure(
        message: error.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } on Exception catch (_) {
      return JsonResponse.failure(
        message: 'Something went wrong!',
      );
    }
  }

  Future<JsonResponse> updateProfile(
    String userId,
    String name,
    String email,
    int phone,
    File? image,
  ) async {
    try {
      final formdata = FormData.fromMap({
        "userId": userId,
        "name": name,
        "email": email,
        "phone": phone,
        'image': image == null
            ? null
            : await MultipartFile.fromFile(
                image.path,
                filename: basename(image.path),
              ),
      }..removeWhere((key, value) => value == null || value == ''));

      final response = await dio.post(
        kUpdateProfile,
        data: formdata,
      );

      if (response.statusCode == 200) {
        final data = User.fromJson(response.data ?? <String, dynamic>{});
        return JsonResponse.success(
          message: 'Profile updated successfully!.',
          data: data,
        );
      } else {
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: 'Failed to Update Profile!',
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data?["message"]?.toString();
      return JsonResponse.failure(
        message: error.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } on Exception catch (_) {
      return JsonResponse.failure(
        message: 'Something went wrong!',
      );
    }
  }

  Future<JsonResponse> posts(
      {int page = 0,
      required double lat,
      required double long,
      required String userId,
      required double range}) async {
    try {
      final response = await dio.get(kPosts, queryParameters: {
        'page': page,
        'lat': lat,
        'long': long,
        'userId': userId,
        'range': range
      });

      if (response.statusCode == 200) {
        final List<Post> posts =
            List<Post>.from(response.data.map((item) => Post.fromJson(item)));

        return JsonResponse.success(
          message: 'Posts Founds..!',
          data: <Post>[...posts],
        );
      } else {
        final error =
            response.data?['message']?.toString() ?? 'Something went wrong!';
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: error,
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data["message"]?.toString();
      return JsonResponse.failure(
        message: error.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } on Exception catch (_) {
      return JsonResponse.failure(
        message: 'Something went wrong!',
      );
    }
  }

  Future<JsonResponse> createPost(
      {String? userId,
      String? title,
      String? description,
      List<File>? images,
      double? lat,
      double? long}) async {
    try {
      final formdata = FormData.fromMap({
        "userId": userId,
        "title": title,
        "description": description,
        'images': [
          for (File image in images ?? [])
            await MultipartFile.fromFile(
              image.path,
              filename: basename(image.path),
            ),
        ],
        "lat": lat,
        "long": long
      });

      final response = await dio.post(
        kCreatePost,
        data: formdata,
      );

      print('-------------->>> $response');

      if (response.statusCode == 201) {
        final data = response.data;
        return JsonResponse.success(
          message: 'Created Post successful!',
          data: data,
        );
      } else {
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: 'Failed to Create Post!',
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data?["message"]?.toString();

      return JsonResponse.failure(
        message: error.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } on Exception catch (_) {
      return JsonResponse.failure(
        message: 'Something went wrong!',
      );
    }
  }

  Future<JsonResponse> updatePost(
    String id,
    String title,
    String description,
    List<File> images,
  ) async {
    try {
      final formdata = FormData.fromMap({
        "postId": id,
        "title": title,
        "description": description,
        'images': [
          for (File image in images)
            await MultipartFile.fromFile(
              image.path,
              filename: basename(image.path),
            ),
        ],
      });

      final response = await dio.post(
        kUpdatePost,
        data: formdata,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return JsonResponse.success(
          message: 'Post Updated Successfully!.',
          data: data,
        );
      } else {
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: 'Failed to Update Post!',
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data?["message"]?.toString();
      return JsonResponse.failure(
        message: error.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } on Exception catch (_) {
      return JsonResponse.failure(
        message: 'Something went wrong!',
      );
    }
  }

  Future<JsonResponse> searchPost(
      {required String name,
      required String userId,
      required double lat,
      required double long}) async {
    try {
      final data = {
        "name": name,
        "userId": userId,
        "lat": lat,
        "long": long,
      };

      final response = await dio.get(kSearchPost, queryParameters: data);

      if (response.statusCode == 200) {
        final List<Post> posts =
            List<Post>.from(response.data.map((item) => Post.fromJson(item)));

        return JsonResponse.success(
          message: '', // post searched
          data: posts,
        );
      } else {
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: 'Failed to Update NewsLetter!',
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data?["message"]?.toString();
      return JsonResponse.failure(
        message: error.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } on Exception catch (_) {
      return JsonResponse.failure(message: 'something went worng');
    }
  }

  Future<JsonResponse> getUserPosts({required String userId}) async {
    try {
      final data = {
        "userId": userId,
      };

      final response = await dio.get(kGetUserPosts, queryParameters: data);

      if (response.statusCode == 200) {
        final List<Post> posts = List<Post>.from(
            response.data['posts'].map((item) => Post.fromJson(item)));

        return JsonResponse.success(
          message: '', // Posts Seached successfully!
          data: posts,
        );
      } else {
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: 'Failed to Get User Posts!',
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data?["message"]?.toString();
      return JsonResponse.failure(
        message: error.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } on Exception catch (_) {
      return JsonResponse.failure(message: 'something went worng');
    }
  }

  Future<JsonResponse> getUserChats({required String userId}) async {
    try {
      final data = {
        "user": userId,
      };

      // api - /get/chats
      final response = await dio.get(kGetChats, queryParameters: data);

      if (response.statusCode == 200) {
        // "list.from" method is of array class to make a list || array elements from any json or normal data.

        // NOTE * HERE IN WE CAN AGAIN DO SO LOGIC WITH INCOMING REPOSNE OF API. [FILTER,SORT,MANIPULATE] WITH DATA.

        // HERE WE COVERSTED EACH OF JSON ELEMENT INTO CHAT CLASS USING ITS CONSTRTOR
        final List<Chat> chats =
            List<Chat>.from(response.data.map((item) => Chat.fromJson(item)));

        return JsonResponse.success(
          message: 'Chats Found..!',
          data: chats,
        );
      } else {
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: 'Failed to Load Chats!',
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data?["message"]?.toString();
      return JsonResponse.failure(
        message: error.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } on Exception catch (_) {
      return JsonResponse.failure(message: 'something went worng');
    }
  }

  Future<JsonResponse> connectChat(
      {required String from, required String post, required String to}) async {
    try {
      final data = {"from": from, "post": post, "to": to};

      // api - /get/chats
      final response = await dio.post(kConnect, data: data);

      if (response.statusCode == 201) {
        return JsonResponse.success(
          message: 'Chats Initiated..!',
        );
      } else {
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: 'Failed to Initiate Chat!',
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data?["message"]?.toString();
      return JsonResponse.failure(
        message: error.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } on Exception catch (_) {
      return JsonResponse.failure(message: 'something went worng');
    }
  }

  Future<JsonResponse> blessPost({
    required String postId,
    required String userId,
  }) async {
    try {
      final data = {
        "postId": postId,
        "userId": userId,
      };

      final response = await dio.post(kBlessPost, data: data);

      if (response.statusCode == 200) {
        return JsonResponse.success(
          message: 'Blessed!.',
        );
      } else {
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: 'Failed to Bless!.',
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data?["message"]?.toString();
      return JsonResponse.failure(
        message: error.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } on Exception catch (_) {
      return JsonResponse.failure(message: 'something went worng');
    }
  }

  // getPost
  Future<JsonResponse> getPost({
    required String postId,
  }) async {
    try {
      final data = {
        "postId": postId,
      };

      final response = await dio.get(kGetPost, queryParameters: data);

      if (response.statusCode == 200) {
        final Post post = Post.fromJson(response.data);

        return JsonResponse.success(
          data: post,
          message: 'Feteched post successfully!.',
        );
      } else {
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: 'Failed to fetch post!.',
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data?["message"]?.toString();
      return JsonResponse.failure(
        message: error.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } on Exception catch (_) {
      return JsonResponse.failure(message: 'something went worng');
    }
  }

  //getProfile
  Future<JsonResponse> getProfile({
    required String userId,
  }) async {
    try {
      final data = <String, dynamic>{
        'userId': userId,
      };

      final response = await dio.get(
        kUserProfile,
        queryParameters: data,
      );

      if (response.statusCode == 200) {
        final data = User.fromJson(response.data ?? <String, dynamic>{});

        return JsonResponse.success(
          message: 'Fetched profile successfully!',
          data: data,
        );
      } else if (response.statusCode == 422) {
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: 'Validation error: ',
        );
      } else {
        final error = response.data?["message"]?.toString();
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: error ?? 'something went wrong!',
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data?["message"]?.toString();
      return JsonResponse.failure(
        message: error.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } on Exception catch (_) {
      return JsonResponse.failure(
        message: 'Something went wrong!',
      );
    }
  }

  // deletePost
  Future<JsonResponse> deletePost({required String postId}) async {
    try {
      final data = {
        "postId": postId,
      };

      // api - /get/chats
      final response = await dio.delete(kDeletePost, data: data);

      if (response.statusCode == 200) {
        return JsonResponse.success(
          message: 'Post Deleted Succesfully!',
        );
      } else {
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: 'Failed to Delete Post!',
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data?["message"]?.toString();

      return JsonResponse.failure(
        message: error.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } on Exception catch (_) {
      return JsonResponse.failure(message: 'something went worng');
    }
  }
}
