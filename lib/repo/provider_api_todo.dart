import 'package:parse_server_sdk/parse_server_sdk.dart';

import '../model/api_response.dart';
import '../model/todo.dart';
import 'contract_provider_todo.dart';

class TodoProviderApi implements TodoProviderContract {
  TodoProviderApi();

  @override
  Future<ApiResponse> add(Todo item) async {
    return getApiResponse<Todo>(await item.save());
  }

  @override
  Future<ApiResponse> addAll(List<Todo> items) async {
    final List<Todo> responses = [];

    for (final Todo item in items) {
      final ApiResponse response = await add(item);

      if (!response.success) {
        return response;
      }

      response?.results?.forEach(responses.add);
    }

    return ApiResponse(true, 200, responses, null);
  }

  @override
  Future<ApiResponse> getAll() async {
    return getApiResponse<Todo>(await Todo().getAll());
  }

  @override
  Future<ApiResponse> getById(String id) async {
    return getApiResponse<Todo>(await Todo().getObject(id));
  }

  @override
  Future<ApiResponse> getNewerThan(DateTime date) async {
    final QueryBuilder<Todo> query = QueryBuilder<Todo>(Todo())
      ..whereGreaterThan(keyVarCreatedAt, date);
    return getApiResponse<Todo>(await query.query());
  }

  @override
  Future<ApiResponse> remove(Todo item) async {
    return getApiResponse<Todo>(await item.delete());
  }

  @override
  Future<ApiResponse> update(Todo item) async {
    return getApiResponse<Todo>(await item.save());
  }

  @override
  Future<ApiResponse> updateAll(List<Todo> items) async {
    final List<Todo> responses = [];

    for (final Todo item in items) {
      final ApiResponse response = await update(item);

      if (!response.success) {
        return response;
      }

      response?.results?.forEach(responses.add);
    }

    return ApiResponse(true, 200, responses, null);
  }
}
