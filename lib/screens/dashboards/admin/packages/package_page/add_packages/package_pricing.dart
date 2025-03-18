import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PackagePricingScreen extends StatefulWidget {
  const PackagePricingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PackagePricingScreenScreenState createState() =>
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
  TextEditingController CompanyController = TextEditingController();
  TextEditingController TaController = TextEditingController();
  TextEditingController CustomerController = TextEditingController();
  TextEditingController TechnocomController = TextEditingController();
  TextEditingController TechnoinsController = TextEditingController();
  TextEditingController BCcomController = TextEditingController();
  TextEditingController BCinsController = TextEditingController();
  TextEditingController BDMcomController = TextEditingController();
  TextEditingController BDMinsController = TextEditingController();
  TextEditingController BCMcomController = TextEditingController();
  TextEditingController BCMinsController = TextEditingController();

  void _calculateTotal() {
    double adultPrice = double.tryParse(adultPriceController.text) ?? 0;
    double childPrice = double.tryParse(childPriceController.text) ?? 0;
    double gstPercentage = double.tryParse(gstController.text) ?? 0;

    double adultTotal = adultPrice + (adultPrice * gstPercentage / 100);
    double childTotal = childPrice + (childPrice * gstPercentage / 100);

    totalAdultController.text = adultTotal.toStringAsFixed(2);
    totalChildController.text = childTotal.toStringAsFixed(2);
  }

  void _calculateTotal1() {
    double companyPrice = double.tryParse(CompanyController.text) ?? 0;
    double taPrice = double.tryParse(TaController.text) ?? 0;
    double customerPrice = double.tryParse(CustomerController.text) ?? 0;

    double adultPrice = double.tryParse(adultPriceController.text) ?? 0;
    double childPrice = double.tryParse(childPriceController.text) ?? 0;

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

    double teMarkup = truncateToTwoDecimals((taPrice * 50) / 100);
    double teMarkupComm = truncateToTwoDecimals((teMarkup * 60) / 100);
    double teMarkupIns = truncateToTwoDecimals((teMarkup * 40) / 100);

    double bmMarkUp = truncateToTwoDecimals((teMarkupComm * 30) / 100);
    double bmMarkUpComm = truncateToTwoDecimals((bmMarkUp * 80) / 100);
    double bmMarkUpIns = truncateToTwoDecimals((bmMarkUp * 20) / 100);

    double bdmMarkUp = truncateToTwoDecimals((bmMarkUpComm * 30) / 100);
    double bdmMarkUpComm = truncateToTwoDecimals((bdmMarkUp * 80) / 100);
    double bdmMarkUpIns = truncateToTwoDecimals((bdmMarkUp * 20) / 100);

    double bcmMarkUp = truncateToTwoDecimals((bdmMarkUpComm * 30) / 100);
    double bcmMarkUpComm = truncateToTwoDecimals((bcmMarkUp * 80) / 100);
    double bcmMarkUpIns = truncateToTwoDecimals((bcmMarkUp * 20) / 100);

    TechnocomController.text = formatNumber(teMarkupComm);
    TechnoinsController.text = formatNumber(teMarkupIns);
    BCcomController.text = formatNumber(bmMarkUpComm);
    BCinsController.text = formatNumber(bmMarkUpIns);
    BDMcomController.text = formatNumber(bdmMarkUpComm);
    BDMinsController.text = formatNumber(bdmMarkUpIns);
    BCMcomController.text = formatNumber(bcmMarkUpComm);
    BCMinsController.text = formatNumber(bcmMarkUpIns);

    // ignore: unnecessary_null_comparison
    if (adultPrice != null && childPrice != null) {
      if (CompanyController.text.isNotEmpty &&
          TaController.text.isNotEmpty &&
          CustomerController.text.isNotEmpty) {
        double markupCalc = companyPrice +
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

        double totalPriceAdult = markupCalc + adultPrice;
        double totalPriceChild = markupCalc + childPrice;

        totalpriceAdultController.text = formatNumber(totalPriceAdult);
        totalpriceChildController.text = formatNumber(totalPriceChild);
      }
    }
  }

// Default selection
  List<String> selectedHotelStars = [];
  List<String> selectedHotelStars1 = [];

  Map<String, String?> selectedFiles = {
    "Profile Picture": null,
    "ID Proof": null,
    "Bank Details": null,
  };

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: TextStyle(color: Colors.white),
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
                  Text("Pricing Details:",
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
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'NET Price for 1 Adult *',
                        labelStyle:
                            TextStyle(color: Colors.white.withOpacity(0.8)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
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
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'NET Price for 1 Child *',
                        labelStyle:
                            TextStyle(color: Colors.white.withOpacity(0.8)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
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
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'NET GST for Adult & Child : ',
                        labelStyle:
                            TextStyle(color: Colors.white.withOpacity(0.8)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: totalAdultController,
                      readOnly: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'NET Total for Adult : ',
                        labelStyle:
                            TextStyle(color: Colors.white.withOpacity(0.8)),
                        filled: true,
                        // ignore: deprecated_member_use
                        fillColor: Colors.white.withOpacity(0.2),
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
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'NET Total for Child : ',
                        labelStyle:
                            TextStyle(color: Colors.white.withOpacity(0.8)),
                        filled: true,
                        // ignore: deprecated_member_use
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: totalpriceAdultController,
                      readOnly: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Total Price for Adult : ',
                        labelStyle:
                            TextStyle(color: Colors.white.withOpacity(0.8)),
                        filled: true,
                        // ignore: deprecated_member_use
                        fillColor: Colors.white.withOpacity(0.2),
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
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Total Price for Child : ',
                        labelStyle:
                            TextStyle(color: Colors.white.withOpacity(0.8)),
                        filled: true,
                        // ignore: deprecated_member_use
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text("Mark-up Price Distribution",
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
                            controller: CompanyController,
                            keyboardType: TextInputType
                                .number, // ✅ Opens numeric keyboard
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (_) => _calculateTotal1(),
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Company *',
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                              filled: true,
                              // ignore: deprecated_member_use
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: TaController,
                            keyboardType: TextInputType
                                .number, // ✅ Opens numeric keyboard
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (_) => _calculateTotal1(),
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Travel Agent *',
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                              filled: true,
                              // ignore: deprecated_member_use
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: CustomerController,
                            keyboardType: TextInputType
                                .number, // ✅ Opens numeric keyboard
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (_) => _calculateTotal1(),
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Customer *',
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                              filled: true,
                              // ignore: deprecated_member_use
                              fillColor: Colors.white.withOpacity(0.2),
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
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text("Techno Enterprise",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Center(
                          child: Text("Business Consultant",
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
                            controller: TechnocomController,
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Commission',
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                              filled: true,
                              // ignore: deprecated_member_use
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: BCcomController,
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Commission',
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                              filled: true,
                              // ignore: deprecated_member_use
                              fillColor: Colors.white.withOpacity(0.2),
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
                            controller: TechnoinsController,
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Incentive',
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                              filled: true,
                              // ignore: deprecated_member_use
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: BCinsController,
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Incentive',
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                              filled: true,
                              // ignore: deprecated_member_use
                              fillColor: Colors.white.withOpacity(0.2),
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
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text("Business Development Manager",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Center(
                          child: Text("Business Channel Manager",
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
                            controller: BDMcomController,
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Commission',
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                              filled: true,
                              // ignore: deprecated_member_use
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: BCMcomController,
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Commission',
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                              filled: true,
                              // ignore: deprecated_member_use
                              fillColor: Colors.white.withOpacity(0.2),
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
                            controller: BDMinsController,
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Incentive',
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                              filled: true,
                              // ignore: deprecated_member_use
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: BCMinsController,
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Incentive',
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                              filled: true,
                              // ignore: deprecated_member_use
                              fillColor: Colors.white.withOpacity(0.2),
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
                  SizedBox(height: 40),
                  _buildTextField('30+ Days Before Travel (%)'),
                  SizedBox(height: 15),
                  _buildTextField('15-30 Days Before Travel (%)'),
                  SizedBox(height: 15),
                  _buildTextField('Less Than 15 Days Before Travel (%)'),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
