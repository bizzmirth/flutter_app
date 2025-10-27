import 'package:bizzmirth_app/controllers/tc_controller/tc_markup_controller.dart';
import 'package:bizzmirth_app/models/tc_models/tc_markup/tc_markup_model.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TcProductMarkupDataSource extends DataTableSource {
  final List<TcMarupModel> data;
  final BuildContext context;

  // ✅ Store a controller for each row
  final List<TextEditingController> controllers = [];

  // ✅ Store row loading state
  final Map<int, bool> _rowLoading = {};

  TcProductMarkupDataSource(this.data, this.context) {
    for (var item in data) {
      controllers.add(TextEditingController(
        text: item.markup?.toStringAsFixed(0) ?? '0',
      ));
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final order = data[index];

    return DataRow(
      cells: [
        DataCell(Text(order.packageId ?? 'N/A')),
        DataCell(Text(order.packageName ?? 'N/A')),
        DataCell(Text(order.packageType ?? 'N/A')),
        DataCell(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Adult Price: ₹ ${order.adultPrice?.toInt() ?? 0}/PAX'),
            const SizedBox(height: 3),
            Text('Child Price: ₹ ${order.childPrice?.toInt() ?? 0}/PAX'),
          ],
        )),
        DataCell(Text('₹ ${order.commission?.toInt() ?? 0}/PAX')),

        // ✅ Editable field with persistent controller
        DataCell(_buildEditablePriceField(controllers[index])),

        DataCell(Text('₹ ${order.sellingPrice?.toInt() ?? 0}')),

        // ✅ Add button with row-wise loader
        DataCell(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _rowLoading[index] == true
                ? null
                : () async {
                    final enteredValue =
                        int.tryParse(controllers[index].text) ?? 0;

                    final controller =
                        Provider.of<TcMarkupController>(context, listen: false);

                    _rowLoading[index] = true;
                    notifyListeners();

                    await controller.apiUpdateMarkUp(
                      order.packageId!,
                      enteredValue.toString(),
                      order.adultPrice.toString(),
                      order.childPrice.toString(),
                    );

                    order.markup = enteredValue.toDouble();
                    controllers[index].text = enteredValue.toString();

                    _rowLoading[index] = false;
                    notifyListeners();

                    // Show SnackBar
                    if (context.mounted) {
                      ToastHelper.showSuccessToast(
                          title: 'Markup updated: $enteredValue');
                    }

                    Logger.success(
                        'Updated markup for index $index: ₹$enteredValue');
                  },
            child: _rowLoading[index] == true
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildEditablePriceField(TextEditingController controller) {
    return Row(
      children: [
        const Text('₹ '),
        SizedBox(
          width: 100,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              final int? enteredValue = int.tryParse(value);
              if (enteredValue != null && enteredValue > 2000) {
                controller.text = '2000';
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
              }
            },
          ),
        ),
        const SizedBox(width: 5),
        const Text('/ Package'),
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
