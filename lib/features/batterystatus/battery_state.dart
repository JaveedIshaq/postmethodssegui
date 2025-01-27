class BatteryState {
  final int level;
  final bool isCharging;
  final String status;

  BatteryState({
    required this.level,
    required this.isCharging,
    required this.status,
  });

  factory BatteryState.fromMap(Map<String, dynamic> map) {
    return BatteryState(
      level: map['level'] ?? 0,
      isCharging: map['isCharging'] ?? false,
      status: map['status'] ?? 'unknown',
    );
  }
}
