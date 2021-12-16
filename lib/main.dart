import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String name; // 현재 진행여부
  bool isDone; // 할일

  Todo(this.name, {this.isDone = false});
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
int i=0;
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ToDoListPage(),
    );
  }
}

class ToDoListPage extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  //리스트 저장 리스트
  final _items = <Todo>[];
  //FirebaseFirestore firestore = FirebaseFirestore.instance;

  var _todoController = TextEditingController();

  @override
  void dispoase() {
    _todoController.dispose();
    super.dispose();
  }

  Widget _buildItemWidget(DocumentSnapshot doc) {
    final todo =Todo(doc['name'],isDone:doc['isdone']);

    return ListTile(
      onTap: () {
        _toggleTodo(todo);
      },
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          _deleteTodo(doc);
        },
      ),
      title: Text(
        todo.name,
        style: todo.isDone
            ? TextStyle(
                decoration: TextDecoration.lineThrough,
                fontStyle: FontStyle.italic)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CRUD')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _todoController,
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    _addTodo(Todo(_todoController.text));
                  },
                  color: Colors.green,
                  child: Text(
                    '추가하기',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>( // Collection으로 부터 Query, snapshot을 통해 받아온 데이터 타입
              stream: FirebaseFirestore.instance.collection('todo').snapshots(), // snapshot() : real-time Read를 위한 Stream을 받아오는 함수,이 스트림의 데이터가 변경되면 ~
              builder: (context, snapshot) { //snapshot객체를 통해 데이터가 있는지 없는지 알 수 있다
               // print(snapshot);
               if(!snapshot.hasData){
                 return CircularProgressIndicator();
               }
                final documents=snapshot.data!.docs;
               // final documents=snapshot.data!.docs[i];
               // i=i+1;
               // print(documents['name']); 이렇게하면 특정 필드만 불러올 수 있음
               return Expanded(
                 child: ListView(
                   scrollDirection: Axis.vertical,
                   shrinkWrap: true,
                   children: documents.map((doc){ //map()은 foreach 돌리는 것과 같다.
                     return _buildItemWidget(doc);
                   }).toList(),
                 ),
              );
              }
            ),
          ],
        ),
      ),
    );
  }

  void _addTodo(Todo todo) {
    FirebaseFirestore.instance.collection('todo').add({
      'name': todo.name,
      'isdone': todo.isDone,
    });
    // setState(() {
    //   _items.add(todo);
    //   _todoController.clear();
    // });
  }

  void _deleteTodo(DocumentSnapshot doc) {
    // setState(() {
    //   _items.remove(todo);
    // });
   FirebaseFirestore.instance.collection('todo').doc(doc.id).delete();
  }

  void _toggleTodo(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }
}


