import 'dart:collection';

import 'database.dart';
import 'dao.dart';
import '../../domain/models/adhkar/custom_adhkar_model.dart';

class InMemoryAppDao implements AppDao {
  final List<CustomAdhkarEntity> _store = [];

  @override
  Future<void> deleteAllCustomAdhkar(List<CustomAdhkarEntity> list) async {
    final set = HashSet<String>.from(list.map((e) => e.dhikr));
    _store.removeWhere((e) => set.contains(e.dhikr));
  }

  @override
  Future<void> delDhikrByDhikrText(String dhikr) async {
    _store.removeWhere((e) => e.dhikr == dhikr);
  }

  @override
  Future<List<CustomAdhkarEntity>> getAllCustomAdhkar() async {
    return List<CustomAdhkarEntity>.unmodifiable(_store);
  }

  @override
  Future<CustomAdhkarEntity?> getDhikrByDhikrText(String dhikr) async {
    try {
      return _store.firstWhere((e) => e.dhikr == dhikr);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> insertDhikr(CustomAdhkarEntity dhikr) async {
    await updateDhikr(dhikr);
  }

  @override
  Future<void> updateDhikr(CustomAdhkarEntity dhikr) async {
    await delDhikrByDhikrText(dhikr.dhikr);
    _store.add(dhikr);
  }
}

class InMemoryAppDatabase extends AppDatabase {
  final InMemoryAppDao _dao = InMemoryAppDao();

  @override
  AppDao get appDao => _dao;
}
