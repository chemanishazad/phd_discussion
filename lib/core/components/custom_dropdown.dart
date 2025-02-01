import 'package:flutter/material.dart';

class AnimatedDropDown extends StatefulWidget {
  final List<String> items;
  final Function(String)? onSelectionChanged;
  final String? title;
  final IconData icon;
  final Color? iconColor;
  final String? initialValue;
  final double dropdownWidth;
  final double dropdownHeight;
  final Color? backgroundColor;

  const AnimatedDropDown({
    super.key,
    required this.items,
    this.onSelectionChanged,
    this.title,
    this.icon = Icons.keyboard_arrow_down_rounded,
    this.iconColor,
    this.initialValue,
    this.dropdownWidth = 180,
    this.dropdownHeight = 50,
    this.backgroundColor,
  });

  @override
  State<AnimatedDropDown> createState() => _AnimatedDropDownState();
}

class _AnimatedDropDownState extends State<AnimatedDropDown>
    with SingleTickerProviderStateMixin {
  String? _selectedItem;
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250), // Smooth animation
    );

    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _toggleDropdown() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _selectItem(String value) {
    setState(() {
      _selectedItem = value;
      _isOpen = false;
    });
    widget.onSelectionChanged?.call(value);
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Dropdown Button
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            width: widget.dropdownWidth,
            height: widget.dropdownHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.5),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedItem ?? widget.title ?? 'Select Option',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                // Icon(
                //   widget.icon,
                //   color: widget.iconColor ?? theme.colorScheme.primary,
                //   size: 24,
                // ),
              ],
            ),
          ),
        ),

        // Animated Dropdown Menu
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _isOpen
              ? FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      width: widget.dropdownWidth,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: widget.backgroundColor ?? theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: widget.items.map((String value) {
                          return InkWell(
                            onTap: () => _selectItem(value),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              child: Text(
                                value,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
