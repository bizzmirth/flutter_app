import 'package:flutter/material.dart';

class PackageItenaryDetails extends StatefulWidget {
  const PackageItenaryDetails({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PackageItenaryDetailsState createState() => _PackageItenaryDetailsState();
}

class _PackageItenaryDetailsState extends State<PackageItenaryDetails> {
  List<Map<String, String>> days = []; // Correct type
  List<Map<String, TextEditingController>> dayControllers = [];

  void _addDay() {
    setState(() {
      days.add({
        "title": "",
        "description": "",
        "meals": "",
        "transport": "",
      });

      dayControllers.add({
        "title": TextEditingController(),
        "description": TextEditingController(),
        "meals": TextEditingController(),
        "transport": TextEditingController(),
      });
    });
  }

  void _removeDay(int index) {
    setState(() {
      dayControllers[index]["title"]!.dispose();
      dayControllers[index]["description"]!.dispose();
      dayControllers[index]["meals"]!.dispose();
      dayControllers[index]["transport"]!.dispose();

      dayControllers.removeAt(index);
      days.removeAt(index);
    });
  }

  List<String> selectedHotelStars = [];
  List<String> selectedHotelStars1 = [];

  Map<String, String?> selectedFiles = {
    "Profile Picture": null,
    "ID Proof": null,
    "Bank Details": null,
  };

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
        child: SingleChildScrollView(
          // ✅ Makes the whole page scrollable
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Itinerary Details:",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text(
                    "This section will contain the information about the package that this product is offering.",
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                Text(
                    "NOTE : Number Of Days may look different on deletion of previous DAY, but Days will be listed from first to last in increasing order.",
                    style: TextStyle(fontSize: 14, color: Colors.redAccent)),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _addDay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child:
                      Text("Add Days", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 16),

                // ✅ Wrap ListView in a Column to prevent internal scrolling
                Column(
                  children: List.generate(days.length, (index) {
                    return _buildDayCard(index);
                  }),
                ),

                SizedBox(height: 16),

                // ✅ Bottom fields remain in view but still scroll if needed
                _buildMultilineTextField1("Inclusion *"),
                _buildMultilineTextField1("Exclusion *"),
                _buildMultilineTextField1("Remarks (If Any)"),

                SizedBox(height: 20), // Some padding at bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultilineTextField1(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: 5, // Allows multiple lines
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.blue.shade50,
        ),
      ),
    );
  }

  Widget _buildDayCard(int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Day: ${index + 1}", // Renumber dynamically
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _removeDay(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: Text("Remove", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildTextField("Title", index, "title"),
            _buildMultilineTextField("Description", index, "description"),
            Row(
              children: [
                Expanded(
                    child: _buildTextField("Meals Included", index, "meals")),
                SizedBox(width: 8),
                Expanded(
                    child: _buildTextField("Transport", index, "transport")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, int index, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: dayControllers[index][key], // ✅ Uses controller now
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.blue.shade50,
        ),
      ),
    );
  }

  Widget _buildMultilineTextField(String label, int index, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: dayControllers[index][key], // ✅ Uses controller now
        maxLines: 3,
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.blue.shade50,
        ),
      ),
    );
  }
}
