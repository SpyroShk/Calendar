import 'package:calender/provider/event_provider.dart';
import 'package:calender/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../model/event_model.dart';

class AddEventPage extends ConsumerStatefulWidget {
  final Event? event;
  const AddEventPage({super.key, this.event});

  @override
  ConsumerState<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends ConsumerState<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  late DateTime from;
  late DateTime to;

  @override
  void initState() {
    super.initState();
    if (widget.event == null) {
      from = DateTime.now();
      to = DateTime.now().add(const Duration(hours: 2));
    } else {
      final event = widget.event!;
      titleController.text = event.title;
      descController.text = event.description;
      from = event.from;
      to = event.to;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CloseButton(
          color: Colors.black,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: const Color(0xFFD3F36B),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => saveForm(),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              textfield(
                text: 'Add Title',
                validator: (title) => title != null && title.isEmpty
                    ? 'Title cannot be Empty.'
                    : null,
                controller: titleController,
                maxline: 1,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              DateTimePicker(),
              const SizedBox(
                height: 10,
              ),
              textfield(
                text: 'Add Description',
                controller: descController,
                maxline: 8,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textfield({
    required String text,
    String? Function(String?)? validator,
    TextEditingController? controller,
    required int maxline,
    required TextStyle? style,
  }) =>
      TextFormField(
        style: style,
        maxLines: maxline,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: text,
        ),
        onFieldSubmitted: (_) => saveForm(),
        validator: validator,
        controller: controller,
      );

  // ignore: non_constant_identifier_names
  Widget DateTimePicker() => Column(
        children: [
          buildfrom(),
          buildto(),
        ],
      );

  Widget buildfrom() => buildHeader(
        header: 'FROM',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: customDropdownField(
                text: Utils.toDate(from),
                onClicked: () => pickFromDateTime(pickDate: true),
              ),
            ),
            Expanded(
              child: customDropdownField(
                text: Utils.toTime(from),
                onClicked: () => pickFromDateTime(pickDate: false),
              ),
            )
          ],
        ),
      );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(from, pickDate: pickDate);
    if (date == null) return;
    if (date.isAfter(to)) {
      to = DateTime(date.year, date.month, date.day, to.hour);
    }
    setState(() {
      from = date;
    });
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      to,
      pickDate: pickDate,
      firstDate: pickDate ? from : null,
    );
    if (date == null) return;
    setState(() {
      to = date;
    });
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2013, 1),
        lastDate: DateTime(2101),
      );
      if (date == null) return null;
      final time = Duration(
        hours: initialDate.hour,
        minutes: initialDate.minute,
      );
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (timeOfDay == null) return null;
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

  Widget customDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({
    required String header,
    required Row child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              header,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          child,
        ],
      );

  Widget buildto() => buildHeader(
        header: 'TO',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: customDropdownField(
                text: Utils.toDate(to),
                onClicked: () => pickToDateTime(pickDate: true),
              ),
            ),
            Expanded(
              child: customDropdownField(
                text: Utils.toTime(to),
                onClicked: () => pickToDateTime(pickDate: false),
              ),
            )
          ],
        ),
      );

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final event = Event(
        title: titleController.text,
        description: descController.text,
        from: from,
        to: to,
      );
      final isEditing = widget.event != null;

      final provider = ref.read(eventProvider);
      if (isEditing) {
        provider.editEvent(event, widget.event!);
        Navigator.pop(context);
      } else {
        provider.addEvent(event);
      }
      Navigator.of(context).pop();
      flutterLocalNotificationsPlugin.show(
        0,
        "Calendar App",
        "Event Added.",
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              importance: Importance.high,
              color: Colors.green,
              playSound: true,
              icon: '@mipmap/ic_launcher'),
        ),
      );
    }
  }
}
