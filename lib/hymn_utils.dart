import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:open_leaves/models/models.dart';
import 'package:open_leaves/screens/hymn_single_screen.dart';

/// Single place to load and cache hymns from assets.
class HymnRepository {
  HymnRepository._();
  static final HymnRepository _instance = HymnRepository._();

  factory HymnRepository() => _instance;

  List<Hymn>? _cache;

  Future<List<Hymn>> loadHymns() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/hymns.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    _cache = decoded.map((hymn) => Hymn.fromJson(hymn)).toList();
    return _cache!;
  }

  Future<List<Hymn>> search(String query) async {
    final hymns = await loadHymns();
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return hymns;
    return hymns
        .where((hymn) =>
            hymn.hymnNo.toLowerCase().contains(term) ||
            hymn.content.toLowerCase().contains(term))
        .toList();
  }

  Hymn? random() {
    final list = _cache;
    if (list == null || list.isEmpty) return null;
    final rnd = Random();
    return list[rnd.nextInt(list.length)];
  }
}

void searchHYMN(BuildContext context) {
  showSearch(
    context: context,
    delegate: SearchHYMNDelegate(HymnRepository()),
  );
}

class SearchHYMNDelegate extends SearchDelegate<Hymn?> {
  SearchHYMNDelegate(this._repository);

  final HymnRepository _repository;

  @override
  String get searchFieldLabel => 'Search hymns';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
        tooltip: 'Clear search',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
      tooltip: 'Back',
    );
  }

  Widget _buildEmpty(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildResultTile(BuildContext context, Hymn hymn) {
    final preview = hymn.content.split('\n').take(2).join(' ').trim();
    return ListTile(
      title: Text('Hymn ${hymn.hymnNo}',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        preview,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade100,
        child: Text(hymn.hymnNo),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => HymnSingle(hymn: hymn),
        ));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Hymn>>(
      future: _repository.search(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final results = snapshot.data ?? [];
        if (results.isEmpty) {
          return _buildEmpty(
              "No hymn matches \"$query\". Try a hymn number or a lyric word.");
        }
        return ListView.separated(
          itemCount: results.length,
          itemBuilder: (context, idx) => _buildResultTile(
            context,
            results[idx],
          ),
          separatorBuilder: (_, __) => const Divider(height: 1),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Hymn>>(
      future: _repository.search(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final results = snapshot.data ?? [];
        if (results.isEmpty) {
          return _buildEmpty("Search hymns by number or lyric.");
        }
        return ListView.separated(
          itemCount: results.length,
          itemBuilder: (context, idx) => _buildResultTile(
            context,
            results[idx],
          ),
          separatorBuilder: (_, __) => const Divider(height: 1),
        );
      },
    );
  }
}
