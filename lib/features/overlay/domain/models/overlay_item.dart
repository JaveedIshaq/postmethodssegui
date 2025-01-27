import 'package:flutter/material.dart';

class OverlayItem {
  final Widget child;
  final int zIndex;
  final String id;
  final bool isDismissible;
  final VoidCallback? onDismiss;

  const OverlayItem({
    required this.child,
    required this.id,
    this.zIndex = 0,
    this.isDismissible = true,
    this.onDismiss,
  });

  OverlayItem copyWith({
    Widget? child,
    int? zIndex,
    String? id,
    bool? isDismissible,
    VoidCallback? onDismiss,
  }) {
    return OverlayItem(
      child: child ?? this.child,
      zIndex: zIndex ?? this.zIndex,
      id: id ?? this.id,
      isDismissible: isDismissible ?? this.isDismissible,
      onDismiss: onDismiss ?? this.onDismiss,
    );
  }
}
