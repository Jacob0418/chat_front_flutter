import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import '../../core/models.dart';

class ChatRepository {
  final ApiClient _apiClient = ApiClient();

  Future<String> ask(String message, List<Message> history) async {
    final payload = {
      "message": message,
      "history": history.map((m) => m.toJson()).toList(),
    };

    try {
      final res = await _apiClient.post('/chat', payload);
      if (res.statusCode == 200) {
        final data = res.data;
        if (data is Map) return (data['answer'] ?? '').toString();
        if (data is String) {
          final parsed = jsonDecode(data);
          return (parsed['answer'] ?? '').toString();
        }
        return '';
      } else {
        throw Exception('Error del servidor: ${res.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Stream<String> askStream(String message, List<Message> history) async* {
    final payload = {
      "message": message,
      "history": history.map((m) => m.toJson()).toList(),
    };

    try {
      final response = await _apiClient.dio.post<ResponseBody>(
        '/chat',
        data: payload,
        options: Options(responseType: ResponseType.stream),
      );

      final stream = response.data!.stream;
      String buffer = '';

      await for (final chunk in utf8.decoder.bind(stream)) {
        buffer += chunk;

        while (true) {
          try {
            final parsed = jsonDecode(buffer);
            if (parsed is Map && parsed.containsKey('answer')) {
              yield parsed['answer'].toString();
            } else {
              yield buffer;
            }
            buffer = '';
            break;
          } catch (_) {
            final nl = buffer.indexOf('\n');
            if (nl == -1) break;
            final line = buffer.substring(0, nl).trim();
            buffer = buffer.substring(nl + 1);
            if (line.isEmpty) continue;

            var content = line;
            if (content.startsWith('data:')) {
              content = content.substring(5).trim();
              if (content == '[DONE]') continue;
            }

            try {
              final parsedLine = jsonDecode(content);
              if (parsedLine is Map && parsedLine.containsKey('answer')) {
                yield parsedLine['answer'].toString();
              } else {
                yield content;
              }
            } catch (_) {
              yield content;
            }
          }
        }
      }

      if (buffer.isNotEmpty) {
        try {
          final parsed = jsonDecode(buffer);
          if (parsed is Map && parsed.containsKey('answer')) {
            yield parsed['answer'].toString();
          } else {
            yield buffer;
          }
        } catch (_) {
          yield buffer;
        }
      }
    } on DioException catch (e) {
      throw Exception("Error de red (stream): ${e.message}");
    } catch (e) {
      throw Exception("Error inesperado (stream): $e");
    }
  }
}