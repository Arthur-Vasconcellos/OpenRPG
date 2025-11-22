import 'package:flutter/material.dart';
import '../data/magic_item_repository.dart';
import '../models/enums.dart';
import '../models/magic_item.dart';
import '../models/localization_keys.dart';
import 'magic_item_detail_screen.dart';

class MagicItemListScreen extends StatefulWidget {
  const MagicItemListScreen({super.key});

  @override
  State<MagicItemListScreen> createState() => _MagicItemListScreenState();
}

class _MagicItemListScreenState extends State<MagicItemListScreen> {
  final MagicItemRepository _repository = MagicItemRepository();
  List<MagicItem> _allItems = []; // NEW: Store all loaded items
  List<MagicItem> _filteredItems = []; // Filtered subset to display
  final TextEditingController _searchController = TextEditingController();
  Rarity? _selectedRarity;
  MagicItemCategory? _selectedCategory;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterItems);
    _loadItems();
  }

  // NEW: Load items from JSON
  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final items = await _repository.loadAllMagicItems();
      setState(() {
        _allItems = items; // Store all items
        _filteredItems = items; // Initially show all items
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load magic items: $e';
        _isLoading = false;
      });
      print('Error loading items: $e'); // Add this for debugging
    }
  }

  // UPDATED: Filter from _allItems instead of _filteredItems
  void _filterItems() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredItems = _allItems.where((item) {
        final name = LocalizationService.getString(item.nameKey).toLowerCase();
        final matchesSearch = query.isEmpty || name.contains(query);
        final matchesRarity = _selectedRarity == null || item.rarity == _selectedRarity;
        final matchesCategory = _selectedCategory == null || item.category == _selectedCategory;

        return matchesSearch && matchesRarity && matchesCategory;
      }).toList();
    });
  }

  // UPDATED: Clear filters and reset to all items
  void _clearFilters() {
    setState(() {
      _selectedRarity = null;
      _selectedCategory = null;
      _searchController.clear();
    });
    _filterItems(); // Re-filter from all items
  }

  // Add this method to show loading/error states
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading items',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadItems,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return _filteredItems.isEmpty ? _buildEmptyState() : _buildItemsList();
  }

  // Update your build method to use _buildContent()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('D&D Magic Items'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadItems,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filters
          _buildFiltersSection(),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${_filteredItems.length} items found',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                if (_selectedRarity != null || _selectedCategory != null || _searchController.text.isNotEmpty)
                  TextButton(
                    onPressed: _clearFilters,
                    child: const Text('Clear Filters'),
                  ),
              ],
            ),
          ),

          // Items List - UPDATED: Use _buildContent()
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search magic items...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Filter Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Rarity Filter
                FilterChip(
                  label: Text(_selectedRarity != null
                      ? LocalizationService.getRarity(_selectedRarity!)
                      : 'All Rarities'),
                  selected: _selectedRarity != null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedRarity = selected ? Rarity.uncommon : null;
                      _filterItems();
                    });
                  },
                ),

                // Category Filter
                FilterChip(
                  label: Text(_selectedCategory != null
                      ? LocalizationService.getCategory(_selectedCategory!)
                      : 'All Categories'),
                  selected: _selectedCategory != null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? MagicItemCategory.weapon : null;
                      _filterItems();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _filteredItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return _buildItemCard(item);
      },
    );
  }

  Widget _buildItemCard(MagicItem item) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          _showItemDetails(item);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Item Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getRarityColor(item.rarity).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getRarityColor(item.rarity).withOpacity(0.3),
                  ),
                ),
                child: Icon(
                  _getCategoryIcon(item.category),
                  color: _getRarityColor(item.rarity),
                ),
              ),

              const SizedBox(width: 16),

              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocalizationService.getString(item.nameKey),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      children: [
                        Chip(
                          label: Text(
                            LocalizationService.getRarity(item.rarity),
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: _getRarityColor(item.rarity).withOpacity(0.2),
                          side: BorderSide.none,
                        ),
                        Chip(
                          label: Text(
                            LocalizationService.getCategory(item.category),
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          side: BorderSide.none,
                        ),
                        if (item.requiresAttunement)
                          Chip(
                            label: const Text(
                              'Requires Attunement',
                              style: TextStyle(fontSize: 12),
                            ),
                            backgroundColor: Colors.orange.withOpacity(0.2),
                            side: BorderSide.none,
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Chevron
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No magic items found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _clearFilters,
            child: const Text('Clear All Filters'),
          ),
        ],
      ),
    );
  }

  void _showItemDetails(MagicItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MagicItemDetailScreen(item: item),
      ),
    );
  }

  Color _getRarityColor(Rarity rarity) {
    switch (rarity) {
      case Rarity.common:
        return Colors.grey;
      case Rarity.uncommon:
        return Colors.green;
      case Rarity.rare:
        return Colors.blue;
      case Rarity.veryRare:
        return Colors.purple;
      case Rarity.legendary:
        return Colors.orange;
      case Rarity.artifact:
        return Colors.red;
    }
  }

  IconData _getCategoryIcon(MagicItemCategory category) {
    switch (category) {
      case MagicItemCategory.weapon:
        return Icons.gavel;
      case MagicItemCategory.armor:
        return Icons.security;
      case MagicItemCategory.potion:
        return Icons.local_drink;
      case MagicItemCategory.ring:
        return Icons.lens;
      case MagicItemCategory.rod:
        return Icons.straighten;
      case MagicItemCategory.staff:
        return Icons.forest;
      case MagicItemCategory.wand:
        return Icons.auto_awesome;
      case MagicItemCategory.wondrousItem:
        return Icons.auto_awesome_mosaic;
      case MagicItemCategory.scroll:
        return Icons.description;
      case MagicItemCategory.ammunition:
        return Icons.arrow_circle_right;
    }
  }
}