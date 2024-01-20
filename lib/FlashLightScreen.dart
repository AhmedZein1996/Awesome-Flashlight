import 'dart:developer';

import 'package:awesome_flashlight/services/audio_service.dart';
import 'package:awesome_flashlight/services/flash_service.dart';
import 'package:awesome_flashlight/utils/enum.dart';
import 'package:awesome_flashlight/utils/extensions.dart';
import 'package:awesome_flashlight/utils/pull_rope_custom_paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

class FlashLightScreen extends StatefulWidget {
  const FlashLightScreen({
    super.key,
  });

  @override
  State<FlashLightScreen> createState() => _FlashLightScreenState();
}

class _FlashLightScreenState extends State<FlashLightScreen>
    with SingleTickerProviderStateMixin {
  final _springDescription =
      const SpringDescription(mass: 1.0, stiffness: 500.0, damping: 15.0);

  // for Spring Simulation at X axis
  late SpringSimulation _springSimX;

  // for Spring Simulation at Y axis
  late SpringSimulation _springSimY;

  //For smooth execution of animations
  Ticker? _ticker;

  // For Thumb position
  Offset thumbOffsets = const Offset(0, 100.0);

  // For Anchor Position
  Offset anchorOffsets = Offset.zero;

  // For State change
  FlashLightState _flashLightState = FlashLightState.off;

  // when anchor is stretch
  void _onPanStart(DragStartDetails details) {
    endSpring();
  }

  // Update between the event
  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      thumbOffsets += details.delta;
    });
  }

  // When Anchor is Stretch off
  void _onPanEnd(DragEndDetails details) {
    startSpring();
    setState(() {
      if (thumbOffsets.dy >= 0.0) {
        log("${thumbOffsets.dy}");
        _flashLightState == FlashLightState.on
            ? FlashService.lightOff()
            : FlashService.lightOn();
        if (_flashLightState == FlashLightState.on) {
          _flashLightState = FlashLightState.off;
        } else {
          _flashLightState = FlashLightState.on;
        }
        _flashLightState == FlashLightState.off
            ? AudioService.play('assets/audio/classic-click.mp3')
            : AudioService.play('assets/audio/classic-click.mp3');
      }
    });
  }

  // When Spring return to original Position
  void endSpring() {
    if (_ticker != null) {
      _ticker!.stop();
    }
  }

  // When Spring is Start
  void startSpring() {
    _springSimX = SpringSimulation(
        _springDescription, thumbOffsets.dx, anchorOffsets.dx, 0);

    _springSimY =
        SpringSimulation(_springDescription, thumbOffsets.dy, 100, 100);

    _ticker ??= createTicker(_onTick);
    _ticker!.start();
  }

  void _onTick(Duration elapsedTime) {
    final elapsedSecondFraction = elapsedTime.inMilliseconds / 1000.0;
    setState(() {
      thumbOffsets = Offset(_springSimX.x(elapsedSecondFraction),
          _springSimY.x(elapsedSecondFraction));
    });

    if (_springSimY.isDone(elapsedSecondFraction) &&
        _springSimX.isDone(elapsedSecondFraction)) {
      endSpring();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _flashLightState != FlashLightState.on,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: _flashLightState != FlashLightState.on
                ? const Color.fromRGBO(247, 247, 247, 1)
                : const Color.fromRGBO(255, 224, 125, 1),
          ),
          body: GestureDetector(
            onTap: () {},
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            // Stack is used here
            child: Container(
              color: _flashLightState != FlashLightState.on
                  ? const Color.fromRGBO(247, 247, 247, 1)
                  : const Color.fromRGBO(255, 224, 125, 1),
              width: context.screenWidth(),
              height: context.screenHeight(),
              child: Column(
                children: <Widget>[
                  // Position of Text
                  const Spacer(
                    flex: 1,
                  ),
                  Text(
                    'Amazing FlashLight',
                    style: GoogleFonts.lemon(
                      fontSize: 22,
                      color: _flashLightState != FlashLightState.on
                          ? const Color.fromRGBO(148, 145, 145, 1)
                          : const Color.fromRGBO(110, 96, 184, 1),
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  // Position of image
                  _flashLightState != FlashLightState.on
                      ? Image.asset(
                          'assets/images/light-off-128px.png',
                          height: 100,
                        )
                      : Image.asset(
                          'assets/images/light-on-128px.png',
                          height: 100,
                        ),
                  // Position of Rope
                  CustomPaint(
                    foregroundPainter: PullRopeCustomPaint(
                      _flashLightState != FlashLightState.on
                          ? const Color.fromRGBO(148, 145, 145, 1)
                          : const Color.fromRGBO(110, 96, 184, 1),
                      anchorOffset: anchorOffsets,
                      springOffset: thumbOffsets,
                    ),
                  ),
                  // Position of rope bottom circle
                  Transform.translate(
                    offset: Offset(thumbOffsets.dx, thumbOffsets.dy - 1.4),
                    child: Icon(
                      Icons.circle,
                      size: 14,
                      color: _flashLightState != FlashLightState.on
                          ? const Color.fromRGBO(148, 145, 145, 1)
                          : const Color.fromRGBO(110, 96, 184, 1),
                    ),
                  ),

                  const Spacer(
                    flex: 6,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
