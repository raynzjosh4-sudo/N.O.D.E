import 'package:flutter/material.dart';
import '../widgets/node_toast.dart';

class NodeToastManager {
  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    required String title,
    String? message,
    NodeToastStatus status = NodeToastStatus.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    _currentEntry?.remove();
    _currentEntry = null;

    final overlay = Overlay.of(context, rootOverlay: true);
    
    _currentEntry = OverlayEntry(
      builder: (context) => _NodeToastOverlay(
        title: title,
        message: message,
        status: status,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
        onDismiss: () {
          _currentEntry?.remove();
          _currentEntry = null;
        },
      ),
    );

    overlay.insert(_currentEntry!);
  }
}

class _NodeToastOverlay extends StatefulWidget {
  final String title;
  final String? message;
  final NodeToastStatus status;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration duration;
  final VoidCallback onDismiss;

  const _NodeToastOverlay({
    required this.title,
    this.message,
    required this.status,
    this.actionLabel,
    this.onAction,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_NodeToastOverlay> createState() => _NodeToastOverlayState();
}

class _NodeToastOverlayState extends State<_NodeToastOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _controller.forward();

    // Auto dismiss
    Future.delayed(widget.duration, () {
      if (mounted) _dismiss();
    });
  }

  void _dismiss() {
    _controller.reverse().then((_) => widget.onDismiss());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _offsetAnimation,
          child: NodeToast(
            title: widget.title,
            message: widget.message,
            status: widget.status,
            actionLabel: widget.actionLabel,
            onAction: () {
              widget.onAction?.call();
              _dismiss();
            },
            onClose: _dismiss,
          ),
        ),
      ),
    );
  }
}
