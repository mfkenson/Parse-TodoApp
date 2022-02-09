import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:todo_app/ui/todo_screen.dart';

import 'constants.dart';
import 'repo/contract_provider_todo.dart';
import 'repo/provider_api_todo.dart';

void main() {
  runApp(TodoApp());
}

final TodoProviderContract api_todo = TodoProviderApi();

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoScreen(api_todo),
    );
  }
}
