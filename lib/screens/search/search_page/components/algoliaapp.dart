import 'package:algolia/algolia.dart';

class AlgoliaApplication {
  static final Algolia algolia = Algolia.init(
      applicationId: "WIWBUCDVQU", apiKey: "e7ca504c2fcece8c291c9e4f15057c0a");
  static final Algolia writeAlgolia = Algolia.init(
      applicationId: "WIWBUCDVQU", apiKey: "3d68237da594be56c0e05b17a1d55422");
}
