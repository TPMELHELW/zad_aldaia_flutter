 import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zad_aldaia/core/routing/routes.dart';
import 'package:zad_aldaia/features/categories/data/models/category.dart';

class CategoryGridWidget extends StatefulWidget {
  final Category category;
  final int itemCount;
  final VoidCallback? onTap;
  final Function(Category)? onMoveUp;
  final Function(Category)? onMoveDown;

  const CategoryGridWidget({
    super.key,
    required this.category,
    required this.itemCount,
    this.onTap,
    this.onMoveUp,
    this.onMoveDown,
  });

  @override
  State<CategoryGridWidget> createState() => _CategoryGridWidgetState();
}

class _CategoryGridWidgetState extends State<CategoryGridWidget> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  double _scale = 1.0;
  double _elevation = 6.0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        _isHovered = true;
        _scale = 1.05;
        _elevation = 16.0;
      }),
      onExit: (_) => setState(() {
        _isHovered = false;
        _scale = 1.0;
        _elevation = 6.0;
      }),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 200),
          child: AnimatedOpacity(
            opacity: widget.category.isActive ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 300),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(_isHovered ? -0.08 : 0.0)
                    ..rotateY(_isHovered ? 0.05 : 0.0)
                    ..translate(0.0, _animation.value * 20, 0.0),
                  alignment: FractionalOffset.center,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.shade300.withOpacity(0.8),
                          blurRadius: _elevation * 1.5,
                          spreadRadius: _elevation / 3,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: widget.onTap,
                        splashColor: Colors.green.withOpacity(0.3),
                        highlightColor: Colors.green.withOpacity(0.1),
                        child: Stack(
                          children: [
                            // Animated gradient background
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: _isHovered
                                      ? [
                                          Colors.green.shade100,
                                          Colors.white,
                                          Colors.green.shade50,
                                        ]
                                      : [
                                          Colors.green.shade50,
                                          Colors.white,
                                          Colors.green.shade100,
                                        ],
                                ),
                              ),
                            ),

                            // Glossy overlay effect
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withOpacity(0.2),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Border with animation
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: _isHovered
                                      ? Colors.green.shade800
                                      : Colors.green.shade700,
                                  width: _isHovered ? 3 : 2,
                                ),
                              ),
                            ),

                            // Content
                            Positioned.fill(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      widget.category.title ?? '-',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.black,
                                            fontFamily: 'Exo',
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                color: Colors.white.withOpacity(0.9),
                                                blurRadius: 8,
                                                offset: const Offset(1, 1),
                                              ),
                                            ],
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                                                    Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade800.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '${widget.itemCount} items',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (Supabase.instance.client.auth.currentUser != null)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: AnimatedOpacity(
                                  opacity: _isHovered ? 1.0 : 0.7,
                                  duration: const Duration(milliseconds: 200),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(24),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, -2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: Colors.amber.shade800),
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                              MyRoutes.addCategoryScreen,
                                              arguments: {"id": widget.category.id},
                                            );
                                          },
                                        ),
                                        IconButton(
                                          onPressed: () =>
                                              widget.onMoveUp?.call(widget.category),
                                          icon: Icon(Icons.arrow_circle_up,
                                              color: Colors.green.shade800),
                                        ),
                                        IconButton(
                                          onPressed: () => widget.onMoveDown
                                              ?.call(widget.category),
                                          icon: Icon(Icons.arrow_circle_down,
                                              color: Colors.green.shade800),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}