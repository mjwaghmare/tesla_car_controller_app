import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesla/components/batter_status.dart';
import 'package:tesla/components/bottom_nav_bar.dart';
import 'package:tesla/components/door_lock.dart';
import 'package:tesla/constraints.dart';
import 'package:tesla/home_controller.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final HomeController _controller = HomeController();

  AnimationController _batteryAnimationController;
  Animation<double> _animationBattery;
  Animation<double> _animationBatteryStatus;

  void setupBatterAnimation() {
    _batteryAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _animationBattery = CurvedAnimation(
      parent: _batteryAnimationController,

      ///this animation start at 0 and ends at half i.e 300 milliseconds
      ///total duration is 600 milliseconds
      curve: Interval(0.0, 0.5),
    );

    _animationBatteryStatus = CurvedAnimation(
      parent: _batteryAnimationController,

      ///this animation start at 0.6 and ends at 1 i.e 600 milliseconds
      ///total duration is 600 milliseconds
      curve: Interval(0.6, 1),
    );
  }

  @override
  void initState() {
    super.initState();
    setupBatterAnimation();
  }

  @override
  void dispose() {
    super.dispose();
    _batteryAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([_controller, _batteryAnimationController]),
        builder: (ctx, _) {
          return Scaffold(
            bottomNavigationBar: TeslaBottomNavBar(
              onTap: (int value) {
                if (value == 1)
                  _batteryAnimationController.forward();
                else if (_controller.selectedTab == 1 && value != 1)
                  _batteryAnimationController.reverse(from: 0.7);
                _controller.onTabChanged(value);
              },
              selectedTab: _controller.selectedTab,
            ),
            body: SafeArea(
              child: LayoutBuilder(builder: (context, constrains) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: constrains.maxHeight * 0.1),
                      child: SvgPicture.asset(
                        "assets/icons/Car.svg",
                        width: double.infinity,
                      ),
                    ),
                    //right door lock
                    AnimatedPositioned(
                      duration: defaultDuration,
                      right: _controller.selectedTab == 0
                          ? constrains.maxWidth * 0.05
                          : constrains.maxWidth / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isRightDoorLock,
                          press: _controller.updateRightDoorLock,
                        ),
                      ),
                    ),
                    //left door lock
                    AnimatedPositioned(
                      duration: defaultDuration,
                      left: _controller.selectedTab == 0
                          ? constrains.maxWidth * 0.05
                          : constrains.maxWidth / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isLeftDoorLock,
                          press: _controller.updateLeftDoorLock,
                        ),
                      ),
                    ),
                    //bonnet lock
                    AnimatedPositioned(
                      duration: defaultDuration,
                      top: _controller.selectedTab == 0
                          ? constrains.maxWidth * 0.13
                          : constrains.maxHeight / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isBonnetLock,
                          press: _controller.updateBonnetLock,
                        ),
                      ),
                    ),
                    //trunk lock
                    AnimatedPositioned(
                      duration: defaultDuration,
                      bottom: _controller.selectedTab == 0
                          ? constrains.maxHeight * 0.17
                          : constrains.maxHeight / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isTrunkLock,
                          press: _controller.updateTrunkDoorLock,
                        ),
                      ),
                    ),
                    //Battery
                    Opacity(
                      opacity: _animationBattery.value,
                      child: SvgPicture.asset(
                        'assets/icons/Battery.svg',
                        width: constrains.maxWidth * 0.45,
                      ),
                    ),
                    //Battery Status
                    Positioned(
                      top: 60 * (1 - _animationBatteryStatus.value),
                      height: constrains.maxHeight,
                      width: constrains.maxWidth,
                      child: Opacity(
                        opacity: _animationBatteryStatus.value,
                        child: BatteryStatus(
                          constraints: constrains,
                        ),
                      ),
                    )
                  ],
                );
              }),
            ),
          );
        });
  }
}
