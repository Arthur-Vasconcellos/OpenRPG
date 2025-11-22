import '../models/enums.dart';
import '../services/json_loader_service.dart';
import '../models/magic_item.dart';

class MagicItemRepository {
  static const String _assetPath = 'assets/magic_items.json';
  static const String _arrayKey = 'magicItems';

  Future<List<MagicItem>> loadAllMagicItems() async {
    try {
      final List<dynamic> jsonArray = await JsonLoaderService.loadJsonArrayAsset(_assetPath);

      print('Processing ${jsonArray.length} items');
      return jsonArray.map((json) => MagicItem.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error in loadAllMagicItems: $e');
      throw Exception('Failed to load magic items: $e');
    }
  }

  Future<MagicItem?> getMagicItemById(String id) async {
    final allItems = await loadAllMagicItems();
    return allItems.firstWhere((item) => item.id == id);
  }

  Future<List<MagicItem>> getMagicItemsByCategory(MagicItemCategory category) async {
    final allItems = await loadAllMagicItems();
    return allItems.where((item) => item.category == category).toList();
  }

  Future<List<MagicItem>> getMagicItemsByRarity(Rarity rarity) async {
    final allItems = await loadAllMagicItems();
    return allItems.where((item) => item.rarity == rarity).toList();
  }

  Future<List<MagicItem>> searchMagicItems(String query) async {
    final allItems = await loadAllMagicItems();
    final lowerQuery = query.toLowerCase();

    return allItems.where((item) {
      return item.id.toLowerCase().contains(lowerQuery) ||
          item.nameKey.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}