import 'dart:async';
import 'package:bizzmirth_app/controllers/admin_controller/admin_busniess_mentor_controller.dart';
import 'package:bizzmirth_app/data_source/admin_data_sources/bm_data_source/admin_reg_bm_data_source.dart';
import 'package:bizzmirth_app/data_source/bm_data_sources/bm_pending_business_mentors.dart';
import 'package:bizzmirth_app/entities/pending_business_mentor/pending_business_mentor_model.dart';
import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/screens/dashboards/admin/business_mentor/add_business_mentor.dart';
import 'package:bizzmirth_app/services/isar_servies.dart';
import 'package:bizzmirth_app/services/widgets_support.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:bizzmirth_app/widgets/filter_bar.dart';
import 'package:flutter/material.dart';

class BusinessMentorPage extends StatefulWidget {
  const BusinessMentorPage({super.key});

  @override
  State<BusinessMentorPage> createState() => _BusinessMentorPageState();
}

class _BusinessMentorPageState extends State<BusinessMentorPage> {
  int _rowsPerPage = 5; // Default rows per page
  int _rowsPerPage1 = 5; // Default rows per page
  static const double dataRowHeight = 50.0;
  static const double headerHeight = 56.0;
  static const double paginationHeight = 60.0;
  List<PendingBusinessMentorModel> pendingBusinessMentor = [];
  final IsarService isarService = IsarService();
  bool isLoading = false;
  late StreamSubscription<void> _pendingBusinessMentor;
  final AdminBusniessMentorController adminBusniessMentorController =
      AdminBusniessMentorController();
  @override
  void initState() {
    super.initState();
    _pendingBusinessMentor =
        isarService.watchCollection<PendingBusinessMentorModel>().listen((_) {
      getBusniessMenotrs();
    });
    getBusniessMenotrs();
    loadBusniessMenotrs();
  }

  @override
  void dispose() {
    _pendingBusinessMentor.cancel();
    super.dispose();
  }

  Future<void> loadBusniessMenotrs() async {
    try {
      setState(() {
        isLoading = true;
      });
      await adminBusniessMentorController.fetchAndSavePendingBusinessMentor();

      await getBusniessMenotrs();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      Logger.error('Error fetching pending business mentors : $e');
    }
  }

  Future<void> getBusniessMenotrs() async {
    try {
      final getBusmiessMentors =
          await isarService.getAll<PendingBusinessMentorModel>();
      setState(() {
        pendingBusinessMentor = getBusmiessMentors;
      });
    } catch (e) {
      Logger.error('Error fetching pending business mentors : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Business Mentorsss',
          style: Appwidget.poppinsAppBarTitle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Divider(thickness: 1, color: Colors.black26),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'All Pending Business Mentor List:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.black26),
                    const FilterBar(),

                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        height: (_rowsPerPage * dataRowHeight) +
                            headerHeight +
                            paginationHeight,
                        child: PaginatedDataTable(
                          columnSpacing: 35,
                          dataRowMinHeight: 40,
                          columns: const [
                            DataColumn(label: Text('Image')),
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Full Name')),
                            DataColumn(label: Text('Ref. ID')),
                            DataColumn(label: Text('Ref. Name')),
                            DataColumn(label: Text('Joining Date')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Action'))
                          ],
                          source: BMPendingBusinessMentors(
                              context, pendingBusinessMentor),
                          rowsPerPage: _rowsPerPage,
                          availableRowsPerPage: const [5, 10, 15, 20, 25],
                          onRowsPerPageChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _rowsPerPage = value;
                              });
                            }
                          },
                          arrowHeadColor: Colors.blue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),
                    const Divider(thickness: 1, color: Colors.black26),
                    // Upcoming Events Section
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'All Registered Business Mentor List:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.black26),

                    const FilterBar(),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        height: (_rowsPerPage1 * dataRowHeight) +
                            headerHeight +
                            paginationHeight,
                        child: PaginatedDataTable(
                          columnSpacing: 35,
                          dataRowMinHeight: 40,
                          columns: const [
                            DataColumn(label: Text('           ')),
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Full Name')),
                            DataColumn(label: Text('Ref. ID')),
                            DataColumn(label: Text('Ref. Name')),
                            DataColumn(label: Text('Joining Date')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Action'))
                          ],
                          source: AdminRegBMDataSource(orders1BM),
                          rowsPerPage: _rowsPerPage1,
                          availableRowsPerPage: const [5, 10, 15, 20, 25],
                          onRowsPerPageChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _rowsPerPage1 = value;
                              });
                            }
                          },
                          arrowHeadColor: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ), //AddViewTEPage
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddbmPage()),
          ).then((value) {
            loadBusniessMenotrs();
          });
        },
        backgroundColor: const Color.fromARGB(255, 153, 198, 250),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        tooltip: 'Add New Mentor',
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
