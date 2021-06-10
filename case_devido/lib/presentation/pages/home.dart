import 'dart:async';

import 'package:case_devido/data/models/data_model.dart';
import 'package:case_devido/domain/cubit/fetch_data_cubit.dart';
import 'package:case_devido/presentation/pages/detail_page.dart';
import 'package:case_devido/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  final scrollController = ScrollController();

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          BlocProvider.of<FetchDataCubit>(context).loadData();
        }
      }
    });
  }

  List<DataModel> listSearch = [];
  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    BlocProvider.of<FetchDataCubit>(context).loadData();

    return Scaffold(
      appBar: AppBar(
        title: Text("Case Devindo"),
      ),
      body: _postList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchPage();
          }));
        },
      ),
    );
  }

  Widget _postList() {
    return BlocBuilder<FetchDataCubit, FetchDataState>(
        builder: (context, state) {
      if (state is FetchDataLoading && state.isFirstFetch) {
        return _loadingIndicator();
      } else if (state is FetchDataFailed) {
        return Text('${state.message}');
      }

      List<DataModel?> posts = [];
      bool isLoading = false;
      if (state is FetchDataLoading) {
        posts = state.oldPosts;
        isLoading = true;
      } else if (state is FetchDataSuccess) {
        posts = state.posts;
        listSearch = state.posts;
      }

      return ListView.separated(
        controller: scrollController,
        itemCount: posts.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < posts.length)
            return _post(posts[index], context);
          else {
            Timer(Duration(milliseconds: 30), () {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            });

            return _loadingIndicator();
          }
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey[400],
          );
        },
      );
    });
  }

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _post(DataModel? dataModel, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailPage(dataModel);
        }));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${dataModel!.id}. ${dataModel.title}",
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(dataModel.body)
          ],
        ),
      ),
    );
  }
}
