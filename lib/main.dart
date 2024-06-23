import 'package:eff_task/data/respositories/explore_repository.dart';
import 'package:eff_task/data/respositories/interface/IExplore_repository.dart';
import 'package:eff_task/ui/screens/home_navigators/home_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<IExploreRepository>(ExploreRepository());

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeNavigatorScreen(),
    );
  }
}
