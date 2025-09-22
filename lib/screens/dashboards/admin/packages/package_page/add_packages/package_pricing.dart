import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PackagePricingScreen extends StatefulWidget {
  const PackagePricingScreen({super.key});

  @override
  State<PackagePricingScreen> createState() =>
      _PackagePricingScreenScreenState();
}

class _PackagePricingScreenScreenState extends State<PackagePricingScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController adultPriceController = TextEditingController();
  TextEditingController childPriceController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController totalAdultController = TextEditingController();
  TextEditingController totalChildController = TextEditingController();
  TextEditingController totalpriceAdultController = TextEditingController();
  TextEditingController totalpriceChildController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController taController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController technocomController = TextEditingController();
  TextEditingController technoinsController = TextEditingController();
  TextEditingController bCcomController = TextEditingController();
  TextEditingController bCinsController = TextEditingController();
  TextEditingController bDMcomController = TextEditingController();
  TextEditingController bDMinsController = TextEditingController();
  TextEditingController bCMcomController = TextEditingController();
  TextEditingController bCMinsController = TextEditingController();

  void _calculateTotal() {
    final double adultPrice = double.tryParse(adultPriceController.text) ?? 0;
    final double childPrice = double.tryParse(childPriceController.text) ?? 0;
    final double gstPercentage = double.tryParse(gstController.text) ?? 0;

    final double adultTotal = adultPrice + (adultPrice * gstPercentage / 100);
    final double childTotal = childPrice + (childPrice * gstPercentage / 100);

    totalAdultController.text = adultTotal.toStringAsFixed(2);
    totalChildController.text = childTotal.toStringAsFixed(2);
  }

  void _calculateTotal1() {
    final double companyPrice = double.tryParse(companyController.text) ?? 0;
    final double taPrice = double.tryParse(taController.text) ?? 0;
    final double customerPrice = double.tryParse(customerController.text) ?? 0;

    final double adultPrice = double.tryParse(adultPriceController.text) ?? 0;
    final double childPrice = double.tryParse(childPriceController.text) ?? 0;

    double truncateToTwoDecimals(double num) {
      return (num * 100).truncateToDouble() / 100;
    }

    String formatNumber(double num) {
      if (num == num.toInt()) {
        return num.toInt()
            .toString(); // If it's a whole number, show without decimals
      } else {
        return num.toStringAsFixed(2); // Otherwise, show two decimal places
      }
    }

    final double teMarkup = truncateToTwoDecimals((taPrice * 50) / 100);
    final double teMarkupComm = truncateToTwoDecimals((teMarkup * 60) / 100);
    final double teMarkupIns = truncateToTwoDecimals((teMarkup * 40) / 100);

    final double bmMarkUp = truncateToTwoDecimals((teMarkupComm * 30) / 100);
    final double bmMarkUpComm = truncateToTwoDecimals((bmMarkUp * 80) / 100);
    final double bmMarkUpIns = truncateToTwoDecimals((bmMarkUp * 20) / 100);

    final double bdmMarkUp = truncateToTwoDecimals((bmMarkUpComm * 30) / 100);
    final double bdmMarkUpComm = truncateToTwoDecimals((bdmMarkUp * 80) / 100);
    final double bdmMarkUpIns = truncateToTwoDecimals((bdmMarkUp * 20) / 100);

    final double bcmMarkUp = truncateToTwoDecimals((bdmMarkUpComm * 30) / 100);
    final double bcmMarkUpComm = truncateToTwoDecimals((bcmMarkUp * 80) / 100);
    final double bcmMarkUpIns = truncateToTwoDecimals((bcmMarkUp * 20) / 100);

    technocomController.text = formatNumber(teMarkupComm);
    technoinsController.text = formatNumber(teMarkupIns);
    bCcomController.text = formatNumber(bmMarkUpComm);
    bCinsController.text = formatNumber(bmMarkUpIns);
    bDMcomController.text = formatNumber(bdmMarkUpComm);
    bDMinsController.text = formatNumber(bdmMarkUpIns);
    bCMcomController.text = formatNumber(bcmMarkUpComm);
    bCMinsController.text = formatNumber(bcmMarkUpIns);

    // ignore: unnecessary_null_comparison
    if (adultPrice != null && childPrice != null) {
      if (companyController.text.isNotEmpty &&
          taController.text.isNotEmpty &&
          customerController.text.isNotEmpty) {
        final double markupCalc = companyPrice +
            taPrice +
            customerPrice +
            teMarkupComm +
            teMarkupIns +
            bmMarkUpComm +
            bmMarkUpIns +
            bdmMarkUpComm +
            bdmMarkUpIns +
            bcmMarkUpComm +
            bcmMarkUpIns;

        final double totalPriceAdult = markupCalc + adultPrice;
        final double totalPriceChild = markupCalc + childPrice;

        totalpriceAdultController.text = formatNumber(totalPriceAdult);
        totalpriceChildController.text = formatNumber(totalPriceChild);
      }
    }
  }

// Default selection
  List<String> selectedHotelStars = [];
  List<String> selectedHotelStars1 = [];

  Map<String, String?> selectedFiles = {
    'Profile Picture': null,
    'ID Proof': null,
    'Bank Details': null,
  };

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        // ignore: deprecated_member_use
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        filled: true,
        // ignore: deprecated_member_use
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blueAccent.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pricing Details:',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: adultPriceController,
                      keyboardType:
                          TextInputType.number, // ✅ Opens numeric keyboard
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => _calculateTotal(),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'NET Price for 1 Adult *',
                        labelStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: childPriceController,
                      keyboardType:
                          TextInputType.number, // ✅ Opens numeric keyboard
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => _calculateTotal(),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'NET Price for 1 Child *',
                        labelStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: gstController,
                      keyboardType:
                          TextInputType.number, // ✅ Opens numeric keyboard
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => _calculateTotal(),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'NET GST for Adult & Child : ',
                        labelStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: totalAdultController,
                      readOnly: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'NET Total for Adult : ',
                        labelStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8)),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: totalChildController,
                      readOnly: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'NET Total for Child : ',
                        labelStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8)),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: totalpriceAdultController,
                      readOnly: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Total Price for Adult : ',
                        labelStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8)),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: totalpriceChildController,
                      readOnly: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Total Price for Child : ',
                        labelStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8)),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text('Mark-up Price Distribution',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: companyController,
                            keyboardType: TextInputType
                                .number, // ✅ Opens numeric keyboard
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (_) => _calculateTotal1(),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Company *',
                              labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8)),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: taController,
                            keyboardType: TextInputType
                                .number, // ✅ Opens numeric keyboard
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (_) => _calculateTotal1(),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Travel Agent *',
                              labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8)),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: customerController,
                            keyboardType: TextInputType
                                .number, // ✅ Opens numeric keyboard
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (_) => _calculateTotal1(),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Customer *',
                              labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8)),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text('Techno Enterprise',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Center(
                          child: Text('Business Consultant',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: technocomController,
                            readOnly: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Commission',
                              labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8)),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: bCcomController,
                            readOnly: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Commission',
                              labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8)),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: technoinsController,
                            readOnly: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Incentive',
                              labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8)),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: bCinsController,
                            readOnly: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Incentive',
                              labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8)),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text('Business Development Manager',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Center(
                          child: Text('Business Channel Manager',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: bDMcomController,
                            readOnly: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Commission',
                              labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8)),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: bCMcomController,
                            readOnly: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Commission',
                              labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8)),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: bDMinsController,
                            readOnly: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Incentive',
                              labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8)),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: bCMinsController,
                            readOnly: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Incentive',
                              labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8)),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildTextField('30+ Days Before Travel (%)'),
                  const SizedBox(height: 15),
                  _buildTextField('15-30 Days Before Travel (%)'),
                  const SizedBox(height: 15),
                  _buildTextField('Less Than 15 Days Before Travel (%)'),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
