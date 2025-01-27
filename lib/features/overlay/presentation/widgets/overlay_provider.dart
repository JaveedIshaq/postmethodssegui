import 'package:flutter/material.dart';
import '../../infrastructure/overlay_manager.dart';

class OverlayProvider extends StatefulWidget {
  final Widget child;

  const OverlayProvider({
    super.key,
    required this.child,
  });

  @override
  State<OverlayProvider> createState() => _OverlayProviderState();
}

class _OverlayProviderState extends State<OverlayProvider> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    OverlayManager().initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
