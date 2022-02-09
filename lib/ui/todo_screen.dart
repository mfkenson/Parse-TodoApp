import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/network_utils/todo_utils.dart';
import 'package:todo_app/repo/contract_provider_todo.dart';

import '../constants.dart';
import '../model/api_response.dart';

class TodoScreen extends StatefulWidget {
  TodoScreen(this.api_todo);
  TodoProviderContract api_todo;

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TextEditingController _taskController = TextEditingController();

  Future<void> initParse() async {
    await Parse().initialize(
      kParseApplicationId,
      keyParseServerUrl,
      clientKey: keyParseClientKey,
      debug: true,
    );
  }

  @override
  void initState() {
    super.initState();
    initParse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("#TODO"),
      ),
      body: Container(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              List<Todo> todoList = snapshot.data;
              return ListView.builder(
                itemBuilder: (_, position) {
                  return ListTile(
                    title: Text(todoList[position].task),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showUpdateDialog(todoList[position]);
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              deleteTodo(todoList[position].objectId);
                            })
                      ],
                    ),
                  );
                },
                itemCount: todoList.length,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          future: getTodoListParse(),

          //future: getTodoList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTodoDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void showUpdateDialog(Todo todo) {
    _taskController.text = todo.task;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                width: double.maxFinite,
                child: TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    labelText: "Enter updated task",
                  ),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      todo.task = _taskController.text;
                      updateTodo(todo);
                    },
                    child: Text("Update")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
              ],
            ));
  }

  Future<List<Todo>> getTodoListParse() async {
    List<Todo> todoList = [];
    ApiResponse res = await widget.api_todo.getAll();
    print(res);
    return todoList;
  }

  Future<List<Todo>> getTodoList() async {
    List<Todo> todoList = [];

    Response response = await TodoUtils.getTodoList();
    print("Code is ${response.statusCode}");
    print("Response is ${response.body}");

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var results = body["results"];

      for (var todo in results) {
        todoList.add(Todo.fromJson(todo));
      }
    } else {
      //Handle error
    }

    return todoList;
  }

  void showAddTodoDialog() {
    _taskController.text = "";
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                width: double.maxFinite,
                child: TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    labelText: "Enter task",
                  ),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      addTodo();
                    },
                    child: Text("Add")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
              ],
            ));
  }

  void addTodo() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: <Widget>[
          Text("Adding task"),
          CircularProgressIndicator(),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      duration: Duration(minutes: 1),
    ));

    Todo todo = Todo(task: _taskController.text);

    TodoUtils.addTodo(todo).then((res) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      Response response = res;
      if (response.statusCode == 201) {
        //Successful
        _taskController.text = "";

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Saved!"),
          duration: Duration(seconds: 1),
        ));

        setState(() {});
      }
    });
  }

  void updateTodo(Todo todo) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: <Widget>[
          Text("Updating"),
          CircularProgressIndicator(),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      duration: Duration(minutes: 1),
    ));

    TodoUtils.updateTodo(todo).then((res) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Response response = res;
      if (response.statusCode == 200) {
        setState(() {
          _taskController.text = "";
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Updated!"),
            duration: Duration(seconds: 1),
          ));
        });
      } else {
        //Handle error
      }
    });
  }

  void deleteTodo(String objectId) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: <Widget>[
          Text("Deleting"),
          CircularProgressIndicator(),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      duration: Duration(minutes: 1),
    ));

    TodoUtils.deleteTodo(objectId).then((res) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (res.statusCode == 200) {
        //Successfully Deleted
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Deleted!"),
            duration: Duration(seconds: 1),
          ));
        });
      } else {
        //Handle error
      }
    });
  }
}
