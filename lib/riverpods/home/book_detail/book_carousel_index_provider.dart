import 'package:hooks_riverpod/hooks_riverpod.dart';

final bookCarouselIndexProvider =
    StateProvider.family<int, int>((ref, startingIndex) {
  return startingIndex;
});
