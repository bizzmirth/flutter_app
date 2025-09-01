import 'package:flutter/material.dart';

class EnhancedProgressTracker extends StatefulWidget {
  final int totalSteps;
  final int currentStep;
  final String goal;
  final Color progressColor;
  final IconData? goalIcon;

  const EnhancedProgressTracker({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    required this.goal,
    this.progressColor = Colors.blueAccent,
    this.goalIcon,
  });

  @override
  _EnhancedProgressTrackerState createState() =>
      _EnhancedProgressTrackerState();
}

class _EnhancedProgressTrackerState extends State<EnhancedProgressTracker>
    with TickerProviderStateMixin {
  int animatedStep = 0;
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _startStepAnimation();

    if (widget.currentStep >= widget.totalSteps) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant EnhancedProgressTracker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _startStepAnimation();

      if (widget.currentStep >= widget.totalSteps) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  void _startStepAnimation() async {
    _progressController.reset();
    setState(() {
      animatedStep = 0;
    });

    for (int i = 0; i <= widget.currentStep; i++) {
      await Future.delayed(Duration(milliseconds: 200));
      if (mounted) {
        setState(() {
          animatedStep = i;
        });
        _progressController.forward();
      }
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate width based on number of steps
    final width = widget.totalSteps * 60.0 +
        180.0; // 60px per step + 180px for goal container

    return Container(
      width: width,
      child: Column(
        children: [
          // Main progress line with dots - lowered by adding top padding
          Container(
            height: 100, // Increased height to accommodate lower positioning
            padding:
                EdgeInsets.only(top: 0), // Added padding to lower the tracker
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align items to top
              children: [
                // Progress dots section
                Expanded(
                  flex: 8,
                  child: Stack(
                    children: [
                      // Background line - positioned lower
                      Positioned(
                        top: 30, // Lowered the line
                        left: 16,
                        right: 16,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      // Animated progress line - positioned lower
                      Positioned(
                        top: 30, // Lowered the line
                        left: 16,
                        right: 16,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double totalWidth = constraints.maxWidth;
                            double segmentWidth =
                                totalWidth / widget.totalSteps;
                            double progressWidth = segmentWidth * animatedStep;

                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: progressWidth,
                              height: 4,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    widget.progressColor,
                                    widget.progressColor.withOpacity(0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        widget.progressColor.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Progress dots - positioned lower
                      Row(
                        children: List.generate(widget.totalSteps, (index) {
                          bool isCompleted = index < animatedStep;
                          bool isCurrent =
                              index == animatedStep - 1 && animatedStep > 0;

                          return Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                    height: 23), // Added space to lower dots
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  width: isCompleted || isCurrent ? 24 : 16,
                                  height: isCompleted || isCurrent ? 24 : 16,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isCompleted
                                        ? widget.progressColor
                                        : isCurrent
                                            ? widget.progressColor
                                                .withOpacity(0.3)
                                            : Colors.white,
                                    border: Border.all(
                                      color: isCompleted || isCurrent
                                          ? widget.progressColor
                                          : Colors.grey[300]!,
                                      width: isCompleted ? 0 : 3,
                                    ),
                                    boxShadow: (isCompleted || isCurrent)
                                        ? [
                                            BoxShadow(
                                              color: widget.progressColor
                                                  .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: Offset(0, 2),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: isCompleted
                                      ? Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        )
                                      : isCurrent
                                          ? Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: widget.progressColor,
                                              ),
                                            )
                                          : null,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isCompleted || isCurrent
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isCompleted || isCurrent
                                        ? widget.progressColor
                                        : Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                // Arrow - aligned with the goal button
                Padding(
                  padding: EdgeInsets.only(
                      top: 30,
                      right:
                          8), // Adjusted top padding to align with goal button
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: animatedStep >= widget.totalSteps
                          ? widget.progressColor
                          : Colors.grey[400],
                      size: 24,
                    ),
                  ),
                ),

                // Goal container
                Padding(
                  padding: EdgeInsets.only(
                      top: 20), // Adjusted top padding to align with arrow
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      bool isGoalReached = animatedStep >= widget.totalSteps;
                      return Transform.scale(
                        scale: isGoalReached ? _pulseAnimation.value : 1.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: isGoalReached
                                ? LinearGradient(
                                    colors: [
                                      widget.progressColor,
                                      widget.progressColor.withOpacity(0.8),
                                    ],
                                  )
                                : null,
                            color: isGoalReached ? null : Colors.grey[100],
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                              color: isGoalReached
                                  ? Colors.transparent
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                            boxShadow: isGoalReached
                                ? [
                                    BoxShadow(
                                      color:
                                          widget.progressColor.withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.goalIcon ??
                                    (isGoalReached
                                        ? Icons.star
                                        : Icons.star_outline),
                                color: isGoalReached
                                    ? Colors.white
                                    : Colors.green[600],
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                widget.goal,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isGoalReached
                                      ? Colors.white
                                      : Colors.green[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
