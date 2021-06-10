part of 'fetch_data_cubit.dart';

@immutable
abstract class FetchDataState {}

class FetchDataInitial extends FetchDataState {}

class FetchDataLoading extends FetchDataState {
   final List<DataModel> oldPosts;
  final bool isFirstFetch;

  FetchDataLoading(this.oldPosts, {this.isFirstFetch=false});
}

class FetchDataSuccess extends FetchDataState {
final List<DataModel> posts;

  FetchDataSuccess(this.posts);
}

class FetchDataFailed extends FetchDataState {
  final String message;

  FetchDataFailed(this.message);
}
