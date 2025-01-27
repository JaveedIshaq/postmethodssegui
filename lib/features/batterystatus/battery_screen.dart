import 'package:flutter/material.dart';
import 'battery_platform_service.dart';
import 'battery_state.dart';

class BatteryStatusScreen extends StatefulWidget {
  const BatteryStatusScreen({super.key});

  @override
  State<BatteryStatusScreen> createState() => _BatteryStatusScreenState();
}

class _BatteryStatusScreenState extends State<BatteryStatusScreen> {
  final BatteryPlatformService _batteryService = BatteryPlatformService();
  BatteryState? _batteryState;

  @override
  void initState() {
    super.initState();
    _updateBatteryStatus();
  }

  Future<void> _updateBatteryStatus() async {
    final batteryData = await _batteryService.getBatteryStatus();
    setState(() {
      _batteryState = BatteryState.fromMap(batteryData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battery Status'),
      ),
      body: Center(
        child: _batteryState == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _batteryState!.isCharging
                        ? Icons.battery_charging_full
                        : Icons.battery_full,
                    size: 100,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Battery Level: ${_batteryState!.level}%',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Status: ${_batteryState!.status}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Charging: ${_batteryState!.isCharging ? 'Yes' : 'No'}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateBatteryStatus,
                    child: const Text('Refresh'),
                  ),
                ],
              ),
      ),
    );
  }
}
