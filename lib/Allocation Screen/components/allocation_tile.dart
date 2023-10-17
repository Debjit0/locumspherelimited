import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locumspherelimited/Models/allocation_model.dart';
import 'package:locumspherelimited/constants/colors.dart';

// ignore: must_be_immutable
class AllocationTile extends StatelessWidget {
  AllocationTile({
    required this.allocation,
  });

  TextEditingController controller = TextEditingController();
  Allocation allocation;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: primaryColorLight,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Date Requested : ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(DateFormat.yMMMEd().format(allocation.date)),
              ],
            ),
            
            
            
            Row(
              children: [
                Text(
                  "Unit name : ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(allocation.unitName),
              ],
            ),
            Row(
              children: [
                Text(
                  "Unit location : ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(allocation.unitName),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Container(
            //       color: Colors.green,
            //       child: GestureDetector(
            //         onTap: (){},
            //         child: Row(children: [
            //           Icon(Icons.check),
            //           Text("Accept")
            //         ],),
            //       ),
            //     ),
            //     Container(
            //       color: Colors.red,
            //       child: GestureDetector(
            //         onTap: (){},
            //         child: Row(children: [
            //           Icon(Icons.close),
            //           Text("Reject")
            //         ],),
            //       ),
            //     ),
            //   ],
            // ),
            // Row(
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {},
            //       child: Text("View Details"),
            //     )
            //   ],
            // ),
          ],
        ));
  }
}
