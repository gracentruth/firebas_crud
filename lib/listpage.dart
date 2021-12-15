import 'package:flutter/material.dart';
import 'mainfirst';



class listPage extends StatefulWidget {
  const listPage({Key? key}) : super(key: key);

  @override
  _listPageState createState() => _listPageState();
}

class _listPageState extends State<listPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'd',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Favorite Hotels'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },

            ),


          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 20.0,
              ),
              child: _buildSuggestions(),
            ),
          ),
      ),
    );
  }
}


Widget _buildSuggestions() {
  return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: databaselist.length,
      itemBuilder: /*1*/ (context, i) {
          return _buildRow(databaselist[i]['name'],databaselist[i]['title']);
      });
}

Widget _buildRow(String name,String title) {
  //  final alreadySaved=_saved.contains(pair);
  return Column(
    children: [
      Text(name),
      Text(title),
    ],
  );
}


