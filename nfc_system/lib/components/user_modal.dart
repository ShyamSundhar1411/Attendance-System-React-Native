import 'package:flutter/material.dart';
import 'package:nfc_system/models/AttendanceModel.dart';
import 'package:nfc_system/providers/AttendanceProvider.dart';
import 'package:provider/provider.dart';
import '../providers/MeetingProvider.dart';
import '../models/NFCUserModel.dart';
import '../models/MeetingModel.dart';

class UserModal extends StatefulWidget {
  final NFCUser user;
  UserModal(this.user);

  @override
  State<UserModal> createState() => _UserModalState();
}

class _UserModalState extends State<UserModal> {
  String? selectedMeeting;
  @override
  Widget build(BuildContext context) {
    final meetingContainer = Provider.of<MeetingProvider>(context);
    final meetings = meetingContainer.getMeetings;
    final attendanceContainer = Provider.of<AttendanceProvider>(context);

    return SingleChildScrollView(
        child: Column(
      children: [
        Center(
            child: Container(
          padding: const EdgeInsets.all(20),
          child: CircleAvatar(
            radius: 40,
            child: Text(
              widget.user.userName.substring(0, 1),
              style: const TextStyle(
                fontSize: 50,
              ),
            ),
          ),
        )),
        ListTile(
          leading: const Icon(Icons.account_circle_outlined),
          title: Text(widget.user.userName),
        ),
        ListTile(
          leading: const Icon(Icons.mail_lock_outlined),
          title: Text(widget.user.email),
        ),
        ListTile(
          leading: const Icon(Icons.account_circle_outlined),
          title: Text(widget.user.regNumber),
        ),
        ListTile(
          leading: const Icon(Icons.account_circle_outlined),
          title: Text(widget.user.facultyRegistered),
        ),
        Container(
            padding: const EdgeInsets.all(5),
            child: DropdownButton<String>(
              elevation: 5,
              value: selectedMeeting,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMeeting = newValue;
                });
              },
              items: meetings.map<DropdownMenuItem<String>>((Meeting meeting) {
                return DropdownMenuItem<String>(
                  value: meeting.name,
                  child: Text(meeting.name),
                );
              }).toList(),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                final meetingId = meetings
                    .firstWhere((element) => element.name == selectedMeeting)
                    .id;
                final createdAttendance = Attendance(
                    meetingId, widget.user.id, "Present", DateTime.now());
                attendanceContainer.createAttendance(createdAttendance);
              },
              child: const Text('Present'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                 final meetingId = meetings
                    .firstWhere((element) => element.name == selectedMeeting)
                    .id;
                final createdAttendance = Attendance(
                    meetingId, widget.user.id, "Absent", DateTime.now());
                attendanceContainer.createAttendance(createdAttendance);
              },
              child: const Text('Absent'),
            ),
          ],
        ),
      ],
    ));
  }
}
