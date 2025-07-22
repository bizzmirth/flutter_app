import 'package:bizzmirth_app/entities/pending_business_mentor/pending_business_mentor_model.dart';
import 'package:bizzmirth_app/entities/pending_employee/pending_employee_model.dart';
import 'package:bizzmirth_app/entities/pending_techno_enterprise/pending_techno_enterprise_model.dart';
import 'package:bizzmirth_app/entities/registered_employee/registered_employee_model.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// Base interface for all Isar models
abstract class IsarModel {
  Id? get id;
}

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  // open the Isar local database
  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      // Logger.success("Initializing Isar Database in project...");
      final isar = await Isar.open(
        [
          PendingEmployeeModelSchema,
          RegisteredEmployeeModelSchema,
          PendingTechnoEnterpriseModelSchema,
          PendingBusinessMentorModelSchema
        ],
        inspector: true,
        directory: dir.path,
      );
      // Logger.success("✅ Isar initialized successfully! Inspector should appear.");
      return isar;
    }

    // Logger.warning("⚠️ Isar is already running: ${Isar.instanceNames}");
    return Future.value(Isar.getInstance()!);
  }

  // Generic get all entities
  Future<List<T>> getAll<T>() async {
    final isar = await db;
    return await isar.collection<T>().where().findAll();
  }

  Stream<void> watchCollection<T>() async* {
    final isar = await db;
    yield* isar.collection<T>().watchLazy();
  }

  Future<void> save<T>(T entity) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.collection<T>().put(entity);
    });
  }

  Future<void> delete<T>(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.collection<T>().delete(id);
    });
  }

  Future<bool> update<T>(T entity, int id) async {
    final isar = await db;
    try {
      bool updated = false;
      await isar.writeTxn(() async {
        final existingEntity = await isar.collection<T>().get(id);
        if (existingEntity != null) {
          await isar.collection<T>().put(entity);
          Logger.success("Updated the employee with id:: $id");
          updated = true;
        }
      });
      return updated;
    } catch (e) {
      Logger.error("Error updating ${T.toString()}: $e");
      return false;
    }
  }

  Future<bool> updateStatus<T>(int id, int newStatus) async {
    final isar = await db;
    bool updated = false;

    try {
      await isar.writeTxn(() async {
        final entity = await isar.collection<T>().get(id);
        if (entity != null) {
          // Use reflection to dynamically set the status field
          final instance = entity as dynamic;
          if (instance != null) {
            try {
              instance.status = newStatus;
              await isar.collection<T>().put(instance);
              Logger.success(
                  "Updated status to '$newStatus' for ${T.toString()} with id: $id");
              updated = true;
            } catch (e) {
              Logger.error("Failed to set status: $e");
            }
          }
        } else {
          Logger.warning("No ${T.toString()} found with id: $id");
        }
      });
      return updated;
    } catch (e) {
      Logger.error("Error updating status for ${T.toString()}: $e");
      return false;
    }
  }

  Future<void> clearAll<T>() async {
    try {
      final isar = await db;

      await isar.writeTxn(() async {
        await isar.collection<T>().clear();
      });

      Logger.success('Successfully cleared all ${T.toString()} records');
    } catch (e) {
      Logger.error('Error clearing ${T.toString()} records: $e');
      // throw Exception('Failed to clear ${T.toString()} records');
    }
  }

  Future<Isar> getDatabase() async {
    return await db;
  }
}
