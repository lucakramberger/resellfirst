import 'package:flutter/material.dart';

class RFDatePicker extends StatefulWidget {
  const RFDatePicker({Key? key}) : super(key: key);

  @override
  _RFDatePickerState createState() => _RFDatePickerState();
}

class _RFDatePickerState extends State<RFDatePicker> {
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              selectedDate.day.toString() +
                  '.' +
                  selectedDate.month.toString() +
                  '.' +
                  selectedDate.year.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.grey[700]),
            ),
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[200],
          )),
    );
  }
}
