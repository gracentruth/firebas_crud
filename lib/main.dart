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
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var _todoController = TextEditingController();

  @override
  void dispoase() {
    _todoController.dispose();
    super.dispose();
  }

  Widget _buildItemWidget(Todo todo) {
    //final todo =Todo(doc['title'],isDone:doc['isdone']);

    return ListTile(
      onTap: () {
        _toggleTodo(todo);
      },
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          _deleteTodo(todo);
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
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: _items.map((todo){ //map()은 foreach 돌리는 것과 같다.
                  return _buildItemWidget(todo);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTodo(Todo todo) {
    firestore.collection('todo').add({
      'name': todo.name,
      'isdone': todo.isDone,
    });
    // setState(() {
    //   _items.add(todo);
    //   _todoController.clear();
    // });
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      _items.remove(todo);
    });
  }

  void _toggleTodo(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }
}
