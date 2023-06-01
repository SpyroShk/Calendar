import 'package:calender/notifier/event_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventProvider = ChangeNotifierProvider(
  (ref) => EventNotifier(),
);
