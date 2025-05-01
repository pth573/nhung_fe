import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/trip/ui/trip_screen.dart';
import '../features/alert/ui/alert_screen.dart';
import '../features/home/ui/home_screen.dart';
import '../features/main/presentation/model/tab_model.dart';
import '../features/main/presentation/provider/floating_bar_provider.dart';
import '../features/main/presentation/provider/tab_provider.dart';
import '../features/main/presentation/ui/bottom_bar_navigation.dart';
import '../features/main/presentation/ui/tab_component.dart';
import '../features/map/map_screen.dart';
import '../widgets/keep_alive_component.dart';
import '../widgets/tracking_system_bar.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<GlobalKey<NavigatorState>> listKey =
  List.generate(TabEnum.values.length, (index) => GlobalKey<NavigatorState>());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: TabEnum.values.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(tabProvider, (pre, next) => _tabController.animateTo(next.index));

    final isStatusBarVisible = ref.watch(floatingBarProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  TabComponent(tabKey: listKey[TabEnum.home.index], child: HomeScreen()),
                  TabComponent(tabKey: listKey[TabEnum.map.index], child: MapScreen()),
                  TabComponent(tabKey: listKey[TabEnum.alert.index], child: AlertScreen()),
                  TabComponent(tabKey: listKey[TabEnum.trip.index], child: TripScreen()),
                ],
              ),
              if (isStatusBarVisible)
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20,
                  child: TrackingSystemBar()
                ),
            ],
          ),
          bottomNavigationBar: const KeepAliveComponent(child: BottomBarNavigation()),
        ),
      ),
    );
  }
}

