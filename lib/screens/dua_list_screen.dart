import 'package:flutter/material.dart';
import 'package:islamic_duas_app/models/dua.dart';
import 'package:islamic_duas_app/services/dua_service.dart';

class DuaListScreen extends StatefulWidget {
  final String? category;

  const DuaListScreen({super.key, this.category});

  @override
  _DuaListScreenState createState() => _DuaListScreenState();
}

class _DuaListScreenState extends State<DuaListScreen> {
  late Future<List<Dua>> _allDuasFuture;
  List<Dua> _displayedDuas = [];
  List<String> _categories = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadData();
  }

  @override
  void didUpdateWidget(covariant DuaListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.category != oldWidget.category) {
      _loadData();
    }
  }

  void _loadData() async {
    if (widget.category == null) {
      _allDuasFuture = DuaService().loadDuas().then((allDuas) {
        _categories = allDuas.map((dua) => dua.categoryMyanmar).toSet().toList();
        _displayedDuas = allDuas; // Initialize with all duas for search
        return allDuas;
      });
    } else {
      _allDuasFuture = DuaService().loadDuas().then((allDuas) {
        final categoryDuas = allDuas.where((dua) => dua.categoryMyanmar == widget.category).toList();
        _displayedDuas = categoryDuas; // Initialize with category duas for search
        return categoryDuas;
      });
    }
    setState(() {}); // Trigger rebuild after data is loaded
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  List<Dua> _filterDuas(List<Dua> allDuas) {
    if (_searchQuery.isEmpty) {
      return allDuas;
    }
    return allDuas.where((dua) {
      final query = _searchQuery.toLowerCase();
      if (dua.titleMyanmar.toLowerCase().contains(query)) {
        return true;
      }
      for (final supplication in dua.supplications) {
        if (supplication.arabicText.toLowerCase().contains(query) ||
            supplication.virtueMyanmar.toLowerCase().contains(query)) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category == null ? 'Islamic Duas Categories' : widget.category!,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
        bottom: widget.category != null
            ? PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Duas...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: FutureBuilder<List<Dua>>(
        future: _allDuasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No duas found.'));
          } else {
            if (widget.category == null) {
              // Display categories
              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.2,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return Card(
                    color: Theme.of(context).cardColor,
                    elevation: Theme.of(context).cardTheme.elevation,
                    shape: Theme.of(context).cardTheme.shape,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DuaListScreen(category: category),
                          ),
                        );
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            category,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              // Display duas for the selected category, filtered by search query
              final filteredDuas = _filterDuas(snapshot.data!);
              if (filteredDuas.isEmpty) {
                return const Center(child: Text('No matching duas found.'));
              }
              return ListView.builder(
                itemCount: filteredDuas.length,
                itemBuilder: (context, index) {
                  Dua dua = filteredDuas[index];
                  return Card(
                    color: Theme.of(context).cardColor,
                    elevation: Theme.of(context).cardTheme.elevation,
                    shape: Theme.of(context).cardTheme.shape,
                    margin: Theme.of(context).cardTheme.margin,
                    child: ListTile(
                      title: Text(
                        dua.titleMyanmar,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        dua.categoryMyanmar,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/duaDetail',
                          arguments: dua,
                        );
                      },
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}