import 'package:flutter/material.dart';
import 'package:movie_app/Components/text_head.dart';

class TimeSelector extends StatefulWidget {
  final Function(String) onTimeSelected;
  const TimeSelector({
    super.key,
    required this.onTimeSelected,
  });

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

List<String> times = ["5:00 PM", "7:00 PM", "9:00 PM"];
int? selectedIndex;

class _TimeSelectorState extends State<TimeSelector> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const TextHead(
            text: "Select a time",
          ),
          const SizedBox(height: 10),
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.withOpacity(0.2),
            ),
            child: ListView.builder(
              itemCount: times.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index; // Cập nhật chỉ mục khi chọn
                  });
                  widget.onTimeSelected(times[index]); // Gọi callback
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: buildCategory(index)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCategory(int index) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.onPrimary,
            style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(16),
        color: selectedIndex == index
            ? Theme.of(context).colorScheme.primary
            : Colors.grey.withOpacity(0.2),
      ),
      child: Text(
        times[index],
        style: TextStyle(
            fontSize: 16,
            color: selectedIndex == index
                ? Colors.white // Màu chữ khi được chọn
                : Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
