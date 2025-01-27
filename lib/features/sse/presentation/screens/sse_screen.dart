import 'package:flutter/material.dart';
import '../../domain/models/sse_event.dart';
import '../../infrastructure/sse_client.dart';

class SSEScreen extends StatefulWidget {
  const SSEScreen({super.key});

  @override
  State<SSEScreen> createState() => _SSEScreenState();
}

class _SSEScreenState extends State<SSEScreen> {
  final SSEClient _sseClient = SSEClient('http://your-sse-endpoint/events');
  final List<SSEEvent> _events = [];
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToSSE();
  }

  void _connectToSSE() {
    setState(() => _isConnected = true);
    
    _sseClient.connect().listen(
      (eventString) {
        final event = SSEEvent.fromString(eventString);
        setState(() {
          _events.insert(0, event);
        });
      },
      onError: (error) {
        setState(() => _isConnected = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection error. Reconnecting...')),
        );
      },
      onDone: () {
        setState(() => _isConnected = false);
      },
    );
  }

  @override
  void dispose() {
    _sseClient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSE Events'),
        actions: [
          _isConnected
              ? const Icon(Icons.cloud_done, color: Colors.green)
              : const Icon(Icons.cloud_off, color: Colors.red),
        ],
      ),
      body: ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return ListTile(
            title: Text(event.event),
            subtitle: Text(event.data),
            trailing: Text(
              '${event.timestamp.hour}:${event.timestamp.minute}:${event.timestamp.second}',
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isConnected ? null : _connectToSSE,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
