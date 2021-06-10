import 'package:bloc/bloc.dart';
import 'package:case_devido/data/models/data_model.dart';
import 'package:case_devido/data/service/services.dart';
import 'package:meta/meta.dart';

part 'fetch_data_state.dart';

class FetchDataCubit extends Cubit<FetchDataState> {
  FetchDataCubit() : super(FetchDataInitial());

  int page = 1;

  void loadData() async {
    if (state is FetchDataLoading) return;

    final currentState = state;

    var oldPosts = <DataModel>[];
    if (currentState is FetchDataSuccess) {
      oldPosts = currentState.posts;
    }

    emit(FetchDataLoading(oldPosts, isFirstFetch: page == 1));

    try {
      List<DataModel> list = await ServiceApi().getGuest(page);

      page++;

      List<DataModel> posts = (state as FetchDataLoading).oldPosts;
      posts.addAll(list);

      if (posts.isNotEmpty) {
        emit(FetchDataSuccess(posts));
      } else {
        emit(FetchDataFailed('rial'));
      }
    } catch (e) {
      emit(FetchDataFailed('There Something Wrong'));
    }
  }
}
