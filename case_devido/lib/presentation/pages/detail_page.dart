import 'package:case_devido/data/models/data_model.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final DataModel? dataModel;
  DetailPage(this.dataModel);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text('${dataModel!.title}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            Text('${dataModel!.body}'),
          ],),
        ),
      ),
    );
  }
}