import '../model/api_response.dart';
import '../model/todo.dart';

abstract class TodoProviderContract {
  Future<ApiResponse> add(Todo item);

  Future<ApiResponse> addAll(List<Todo> items);

  Future<ApiResponse> update(Todo item);

  Future<ApiResponse> updateAll(List<Todo> items);

  Future<ApiResponse> remove(Todo item);

  Future<ApiResponse> getById(String id);

  Future<ApiResponse> getAll();

  Future<ApiResponse> getNewerThan(DateTime date);
}
