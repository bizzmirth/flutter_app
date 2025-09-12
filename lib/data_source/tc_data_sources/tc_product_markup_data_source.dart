import 'package:flutter/material.dart';

class TcProductMarkupDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  TcProductMarkupDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order["id"]?.toString() ?? "N/A")),
        DataCell(Text(order["pname"]?.toString() ?? "N/A")),
        DataCell(Text("₹ ${order["price"]?.toString() ?? "N/A"}")),
        DataCell(Text("₹ ${order["com"]?.toString() ?? "N/A"}")),
        DataCell(
            _buildEditablePriceField(order, index)), // Editable Price Field
        DataCell(Text("₹ ${order["sprice"]?.toString() ?? "N/A"}")),
        // DataCell(_buildActionMenu()),
        DataCell(ElevatedButton(
          onPressed: () {
            // Your add action here
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text("Add", style: TextStyle(color: Colors.white)),
        ))
      ],
    );
  }

  Widget _buildEditablePriceField(Map<String, dynamic> order, int index) {
    TextEditingController _controller = TextEditingController(text: "0");

    return Row(
      children: [
        Text("₹ "), // Rupee Symbol
        SizedBox(
          width: 50,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              int? enteredValue = int.tryParse(value);
              if (enteredValue != null) {
                if (enteredValue > 2000) {
                  _controller.text = "2000"; // Force max 2000
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _controller.text.length),
                  );
                }
              }
            },
          ),
        ),
        SizedBox(width: 5),
        Text("/ Package"),
      ],
    );
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
