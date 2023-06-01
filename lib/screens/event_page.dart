import 'package:calender/model/event_model.dart';
import 'package:calender/provider/event_provider.dart';
import 'package:calender/screens/add_event_page.dart';
import 'package:calender/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventPage extends ConsumerWidget {
  final Event event;
  const EventPage({super.key, required this.event});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CloseButton(
          color: Colors.black,
        ),
        actions: [
          MaterialButton(
            minWidth: 0,
            height: 0,
            padding: EdgeInsets.zero,
            child: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => AddEventPage(
                    event: event,
                  ),
                ),
              );
            },
          ),
          MaterialButton(
            minWidth: 50,
            height: 0,
            padding: EdgeInsets.zero,
            child: const Icon(Icons.delete),
            onPressed: () {
              ref.watch(eventProvider).deleteEvent(event);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          Column(
            children: [
              buildDate('FROM', event.from),
              buildDate('TO', event.to),
            ],
          ),
          // const SizedBox(
          //   height: 30,
          // ),
          const Padding(
            padding: EdgeInsets.all(30),
            child: Divider(
              height: 2,
              thickness: 3,
              color: Color(0xFF8F9F8E),
            ),
          ),
          Text(
            event.title,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            event.description,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget buildDate(
    String title,
    DateTime date,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFD3F36B),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              Utils.toDateTime(date),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
