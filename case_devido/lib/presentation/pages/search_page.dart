import 'package:case_devido/data/models/data_model.dart';
import 'package:case_devido/domain/cubit/fetch_data_cubit.dart';
import 'package:case_devido/presentation/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<DataModel> list = [];
  List<DataModel> listsearch = [];
  bool isNotHaveData = true;

  TextEditingController searchController = TextEditingController();

  oncari(String text) async {
    listsearch.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    list.forEach((element) {
      if (element.title.contains(text.toLowerCase()) ||
          element.body.contains(text.toLowerCase())) {
        listsearch.add(element);
      }
      setState(() {});
    });
  }

  late int index;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: searchController,
              onChanged: oncari,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                filled: true,
                hintText: 'Cari Item',
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.greenAccent),
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ),
          body: BlocBuilder<FetchDataCubit, FetchDataState>(
            builder: (context, state) {
              if (state is FetchDataLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is FetchDataSuccess) {
                list = state.posts;
              }
              return listsearch.length == 0 || searchController.text.isEmpty
                  ? Center(
                      child: Text(
                        'Search item',
                        style: GoogleFonts.poppins(
                            color: Colors.black54, fontSize: 25.0),
                      ),
                    )
                  : Container(
                      child: ListView.builder(
                        itemCount: listsearch.length,
                        itemBuilder: (context, index) {
                          final list = listsearch[index];
                          return _post(list,context);
                        },
                      ),
                    );
            },
          )),
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
