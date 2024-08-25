import 'dart:io';

import 'package:dio/dio.dart';
import 'dart:convert';

class APIProvider {
  // APIProvider._();
  final Dio _dio = Dio();
  static String base_URL =
      "https://flutter-app-6af61-default-rtdb.firebaseio.com/";

  APIProvider() {
    _dio.options = BaseOptions(
      baseUrl: base_URL,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      contentType: 'application/json',
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      },
    );
    _dio.interceptors
        .add(LogInterceptor(requestBody: true, responseBody: true));
  }
  Future<Response<dynamic>> post<T>(String endPoint,
      {required Object data, Options? options}) async {
    try {
      Response response =
          await _dio.post(endPoint, data: json.encode(data), options: options);
      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      // Handle other exceptions
      rethrow;
    }
  }

  Future<dynamic> get<T>(
    String endPoint,
  ) async {
    try {
      Response response = await _dio.get(endPoint);
      return response.data;
    } on DioException {
      rethrow;
    } catch (e) {
      // rethrow;
    }
  }

  Future<dynamic> getWithQuery<T>(
      String endPoint, Map<String, dynamic> queryParams) async {
    try {
      // Remove parameters with empty string values
      queryParams.removeWhere(
          (key, value) => (value is String && value.isEmpty) || value == null);
      Response response =
          await _dio.get(endPoint, queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      // rethrow;
    }
  }

  Future<dynamic> put<T>(String endPoint,
      {required Object data, Options? options}) async {
    try {
      Response response =
          await _dio.put(endPoint, data: json.encode(data), options: options);

      return response.data;
    } on DioException catch (e) {
      // Dio error handling
      // You can customize this part based on your requirements
      rethrow;
    } on SocketException catch (e) {
      // Socket exception handling
      rethrow;
    } catch (e) {
      // Handle other exceptions
      rethrow;
    }
  }

  Future<dynamic> patch<T>(String endPoint,
      {required Object data, Options? options}) async {
    try {
      Response response =
          await _dio.patch(endPoint, data: json.encode(data), options: options);

      return response.data;
    } on DioException catch (e) {
      // Dio error handling
      // You can customize this part based on your requirements
      rethrow;
    } on SocketException catch (e) {
      // Socket exception handling
      rethrow;
    } catch (e) {
      // Handle other exceptions
      rethrow;
    }
  }

  Future<dynamic> delete<T>(String endPoint,
      {Object? data, Options? options}) async {
    try {
      Response response = await _dio.delete(endPoint,
          data: json.encode(data), options: options);
      return response.data;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      // Handle other exceptions
      rethrow;
    }
  }
}
