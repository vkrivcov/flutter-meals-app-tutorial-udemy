import 'package:flutter_meals_app_tutorial_udemy/data/dummy_dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider is good for static data
final mealsProvider = Provider((ref) {
  // dummy return for provider
  return dummyMeals;
});
