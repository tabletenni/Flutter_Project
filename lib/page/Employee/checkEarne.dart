import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // ✅ ใช้ DateUtils.dateOnly() เพื่อให้ key ใน Map มีค่าเดียวกัน
  final Map<DateTime, List<int>> _events = {
    DateUtils.dateOnly(DateTime.utc(2025, 3, 1)): [1000, 200], // รวมได้ 300
    DateUtils.dateOnly(DateTime.utc(2025, 3, 5)): [50, 50],   // รวมได้ 100
    DateUtils.dateOnly(DateTime.utc(2025, 3, 10)): [120],     // รวมได้ 120
    DateUtils.dateOnly(DateTime.utc(2025, 3, 15)): [80, 20],  // รวมได้ 100
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Earning", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[600],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) =>
                _selectedDay != null && isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = DateUtils.dateOnly(selectedDay); // ✅ ตัดเวลาออก
                _focusedDay = focusedDay;
              });

              // ✅ Debug Log ตรวจสอบค่าที่เลือก
              print("เลือกวัน: $_selectedDay");
              print("วันทั้งหมดใน events: ${_events.keys}");
              print("containsKey: ${_events.containsKey(_selectedDay)}");
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  _selectedDay != null
                      ? "รายได้รวม วันที่: ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}"
                      : "กรุณาเลือกวัน",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    (_selectedDay != null && _events.containsKey(DateUtils.dateOnly(_selectedDay!)))
                        ? "${_events[DateUtils.dateOnly(_selectedDay!)]!.reduce((a, b) => a + b)}"
                        : "ไม่มีรายได้ในวันนี้",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}