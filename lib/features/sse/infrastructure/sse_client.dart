import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mobile/features/sse/domain/models/sse_event.dart';

class SSEClient {
  final String url;
  http.Client? _client;
  StreamController<String>? _streamController;
  Timer? _reconnectionTimer;
  bool _isConnected = false;

  static const Duration reconnectDelay = Duration(seconds: 5);

  SSEClient(this.url);

  Stream<String> connect() {
    _streamController = StreamController<String>(
      onCancel: () {
        _disconnect();
      },
    );

    _establishConnection();

    return _streamController!.stream;
  }

  Future<void> _establishConnection() async {
    if (_isConnected) return;

    try {
      _client = http.Client();
      final request = http.Request('GET', Uri.parse(url))
        ..headers['Accept'] = 'text/event-stream'
        ..headers['Cache-Control'] = 'no-cache';

      final response = await _client!.send(request);
      _isConnected = true;

      response.stream.transform(StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          final String event = String.fromCharCodes(data);
          if (event.trim().isNotEmpty) {
            sink.add(event);
          }
        },
      )).listen(
        (dynamic event) {
          try {
            final sseEvent = SSEEvent.fromString(event);
            _streamController?.add(sseEvent as String);
          } catch (e) {
            _handleError('Failed to parse SSE event: $e');
          }
        },
        onError: (error) {
          _handleError(error);
        },
        onDone: () {
          _handleDisconnection();
        },
        cancelOnError: true,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(dynamic error) {
    _isConnected = false;
    _scheduleReconnection();
  }

  void _handleDisconnection() {
    _isConnected = false;
    _scheduleReconnection();
  }

  void _scheduleReconnection() {
    _reconnectionTimer?.cancel();
    _reconnectionTimer = Timer(reconnectDelay, () {
      if (!_isConnected && !(_streamController?.isClosed ?? true)) {
        _establishConnection();
      }
    });
  }

  void _disconnect() {
    _isConnected = false;
    _client?.close();
    _client = null;
    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;
    _streamController?.close();
    _streamController = null;
  }

  void dispose() {
    _disconnect();
  }
}
