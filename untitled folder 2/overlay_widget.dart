import 'package:flutter/material.dart';

mixin DropDownOverlay<T extends StatefulWidget> on State<T> {
  OverlayEntry? _overlayEntry;
  OverlayEntry? _overlayEntryIcon;

  @override
  void dispose() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    if (_overlayEntryIcon != null) {
      _overlayEntryIcon?.remove();
      _overlayEntryIcon = null;
    }
    super.dispose();
  }

  void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _overlayEntry?.dispose();
  }

  void removeOverlayIcon() {
    _overlayEntryIcon?.remove();
    _overlayEntryIcon = null;
    _overlayEntryIcon?.dispose();
  }

  void showOverlayIcon({
    required Widget child,
    required Rect rect,
  }) {
    _overlayEntryIcon = OverlayEntry(builder: (BuildContext context) {
      return Positioned(
        width: rect.width,
        height: rect.height,
        top: rect.top,
        left: rect.left,
        child: Material(type: MaterialType.transparency, child: child),
      );
    });

    final _overlayEntryMessage = _overlayEntryIcon;
    if (_overlayEntryMessage != null) {
      Overlay.of(context).insert(_overlayEntryMessage);
    }
  }

  void showOverlay(
      {required Widget child,
      required Rect rect,
      double? width,
      double? height,
      double? left,
      double? top,
      bool? addTransparency = true}) {
    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return Positioned(
          width: width ?? rect.width,
          height: height ?? rect.height,
          top: top ?? rect.top,
          left: left ?? rect.left,
          child: addTransparency == true
              ? Material(type: MaterialType.transparency, child: child)
              : Material(
                  color: Colors.transparent,
                  type: MaterialType.transparency,
                  child: child));
    });

    final _overlayEntryMessage = _overlayEntry;
    if (_overlayEntryMessage != null) {
      Overlay.of(context).insert(_overlayEntryMessage);
    }
  }
}
