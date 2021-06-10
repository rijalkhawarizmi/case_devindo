import 'package:case_devido/data/models/data_model.dart';
import 'package:dio/dio.dart';

class ServiceApi {
  Dio _dio = Dio();
  Response? response;
  Future<List<DataModel>> getGuest(int page) async {
    int limit = 5;
    var url =
        'https://jsonplaceholder.typicode.com/posts?_limit=$limit&_page=$page';
    try {
      List<DataModel> list = [];
      response = await _dio.get(url);
      if (response!.statusCode == 200) {
        for (Map i in response!.data) {
          list.add(DataModel.fromJson(i));
        }
      }
      return list;
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        throw e.response!;
      } else {
        throw e;
      }
    }
  }
}
