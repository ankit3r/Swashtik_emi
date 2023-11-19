import 'package:intl/intl.dart';

class SubscriptionHelper {
  static int calculateRemainingDays(String endDate) {
    DateTime currentDate = DateTime.now();
    DateTime endDateTime = DateFormat('yyyy-MM-dd').parse(endDate);

    // Calculate the difference in days
    int remainingDays = endDateTime.difference(currentDate).inDays;

    // Return the remaining days
    return remainingDays;
  }
}
