part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LoadPostsEvent extends PostEvent {
  const LoadPostsEvent({
    this.refresh = false,
    required this.range,
    required this.userId,
    required this.lat,
    required this.long,
  });

  final bool refresh;
  final double range;
  final String userId;
  final double lat;
  final double long;

  @override
  List<Object> get props => [refresh, range, userId, lat, long];
}

class CreatePostEvent extends PostEvent {
  const CreatePostEvent({
    required this.userId,
    required this.title,
    required this.description,
    required this.images,
    required this.lat,
    required this.long,
  });

  final String userId;
  final String title;
  final String description;
  final List<XFile> images;
  final double lat;
  final double long;

  @override
  List<Object> get props => [userId, title, description, images, lat, long];
}

class UpdatePostEvent extends PostEvent {
  const UpdatePostEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
  });
  final String id;
  final String title;
  final String description;
  final List<XFile> images;

  @override
  List<Object> get props => [
        id,
        title,
        description,
        images,
      ];
}

class SearchPostEvent extends PostEvent {
  const SearchPostEvent({
    required this.name,
    required this.userId,
    required this.lat,
    required this.long,
  });

  final String name;
  final String userId;
  final double lat;
  final double long;
  @override
  List<Object> get props => [name, userId, lat, long];
}

class BlessPostEvent extends PostEvent {
  const BlessPostEvent({required this.postId, required this.userId});

  final String postId;
  final String userId;
  @override
  List<Object> get props => [postId, userId];
}

class GetPostEvent extends PostEvent {
  const GetPostEvent({required this.postId});

  final String postId;
  @override
  List<Object> get props => [postId];
}

class DeletePostEvent extends PostEvent {
  const DeletePostEvent({required this.postId});

  final String postId;
  @override
  List<Object> get props => [postId];
}
