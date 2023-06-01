import 'package:calender/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../model/event_data_source.dart';
import 'tasks.dart';

class Calendar extends ConsumerWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final events = ref.watch(eventProvider).events;
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFF7F6F0),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              blurRadius: 30.0,
              offset: Offset(-28, -28),
              color: Colors.white,
            ),
            BoxShadow(
              blurRadius: 30.0,
              offset: Offset(28, 28),
              color: Color(0xFFA7A9AF),
            )
          ]),
      child: SfCalendar(
        headerStyle: const CalendarHeaderStyle(
            textStyle: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
            backgroundColor: Colors.transparent),
        headerHeight: 60,
        view: CalendarView.month,
        dataSource: EventDataSource(events),
        initialDisplayDate: DateTime.now(),
        cellBorderColor: Colors.transparent,
        onLongPress: (details) {
          final provider = ref.read(eventProvider);
          provider.setDate(details.date!);

          showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              context: context,
              builder: (context) {
                return const Tasks();
              });
        },
      ),
    );
  }
}
