import 'package:flutter/material.dart';
import '../domain/models/overlay_item.dart';

class OverlayManager {
  static final OverlayManager _instance = OverlayManager._internal();
  factory OverlayManager() => _instance;
  OverlayManager._internal();

  final Map<String, OverlayEntry> _entries = {};
  final List<OverlayItem> _items = [];
  OverlayState? _overlayState;

  void initialize(BuildContext context) {
    _overlayState = Overlay.of(context);
  }

  void show(OverlayItem item) {
    if (_entries.containsKey(item.id)) {
      return;
    }

    final entry = OverlayEntry(
      builder: (context) => _buildOverlayWidget(item),
    );

    _items.add(item);
    _entries[item.id] = entry;
    _sortAndUpdateOverlay();
  }

  void hide(String id) {
    final entry = _entries[id];
    if (entry != null) {
      entry.remove();
      _entries.remove(id);
      _items.removeWhere((item) => item.id == id);
    }
  }

  void hideAll() {
    for (final entry in _entries.values) {
      entry.remove();
    }
    _entries.clear();
    _items.clear();
  }

  void updateOverlay(String id, OverlayItem newItem) {
    hide(id);
    show(newItem);
  }

  Widget _buildOverlayWidget(OverlayItem item) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          if (item.isDismissible)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                hide(item.id);
                item.onDismiss?.call();
              },
              child: Container(color: Colors.transparent),
            ),
          item.child,
        ],
      ),
    );
  }

  void _sortAndUpdateOverlay() {
    if (_overlayState == null) return;

    // Sort items by z-index
    _items.sort((a, b) => a.zIndex.compareTo(b.zIndex));

    // Remove all entries
    for (final entry in _entries.values) {
      entry.remove();
    }

    // Add entries back in sorted order
    for (final item in _items) {
      final entry = _entries[item.id];
      if (entry != null) {
        _overlayState!.insert(entry);
      }
    }
  }
}
