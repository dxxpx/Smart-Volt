import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const CustomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    if (widget.value) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSwitch(bool value) {
    if (value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _toggleSwitch(!widget.value),
      child: Container(
        width: 130,
        height: 50,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: widget.value ? Colors.green : Colors.red,
        ),
        child: Stack(
          alignment: Alignment.center, // Center the content
          children: [
            // Text for "Off" state
            Positioned(
              left: 20, // Adjust the position slightly from the edges
              child: Opacity(
                opacity: 1.0 - _animation.value,
                child: Text(
                  'Off',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Text for "On" state
            Positioned(
              right: 20, // Adjust the position slightly from the edges
              child: Opacity(
                opacity: _animation.value,
                child: Text(
                  'On',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Circular moving part
            Positioned(
              left: widget.value ? 80 : 0, // Control position based on state
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(80 * _animation.value, 0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          widget.value ? Icons.check : Icons.close,
                          color: widget.value ? Colors.green : Colors.red,
                          size: 24, // Adjust icon size to fit within the circle
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
