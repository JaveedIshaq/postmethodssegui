class SSEEvent {
  final String id;
  final String event;
  final String data;
  final DateTime timestamp;

  SSEEvent({
    required this.id,
    required this.event,
    required this.data,
    required this.timestamp,
  });

  factory SSEEvent.fromString(String rawEvent) {
    final lines = rawEvent.split('\n');
    String id = '';
    String event = 'message';
    String data = '';

    for (var line in lines) {
      if (line.startsWith('id:')) {
        id = line.substring(3).trim();
      } else if (line.startsWith('event:')) {
        event = line.substring(6).trim();
      } else if (line.startsWith('data:')) {
        data = line.substring(5).trim();
      }
    }

    return SSEEvent(
      id: id,
      event: event,
      data: data,
      timestamp: DateTime.now(),
    );
  }
}
