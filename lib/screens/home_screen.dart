import 'package:flutter/material.dart';
import 'package:open_leaves/hymn_utils.dart';
import 'package:open_leaves/models/models.dart';
import 'package:open_leaves/screens/hymns_list_screen.dart';
import 'package:open_leaves/screens/hymn_single_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key, this.onOpenSettings}) : super(key: key);

  final HymnRepository _repository = HymnRepository();
  final VoidCallback? onOpenSettings;

  Future<void> _openRandomHymn(BuildContext context) async {
    final hymns = await _repository.loadHymns();
    if (hymns.isEmpty) return;
    final hymn = _repository.random() ?? hymns.first;
    _openHymn(context, hymn);
  }

  void _openHymn(BuildContext context, Hymn hymn) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HymnSingle(hymn: hymn),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: FutureBuilder<List<Hymn>>(
          future: _repository.loadHymns(),
          builder: (context, snapshot) {
            final hymns = snapshot.data ?? [];
            final randomHymn =
                hymns.isNotEmpty ? (_repository.random() ?? hymns.first) : null;
            final topPicks = hymns.take(3).toList();

            return Stack(
              children: [
                SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(onOpenSettings: onOpenSettings),
                      const SizedBox(height: 18),
                      _SearchStrip(onTap: () => searchHYMN(context)),
                      const SizedBox(height: 16),
                      // _StatRow(hymnCount: hymns.length),
                      const SizedBox(height: 16),
                      if (randomHymn != null)
                        _FeaturedCard(
                          hymn: randomHymn,
                          onOpen: () => _openHymn(context, randomHymn),
                        ),
                      const SizedBox(height: 16),
                      _ActionGrid(
                        onBrowse: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const HymsList(),
                          ),
                        ),
                        onRandom: () => _openRandomHymn(context),
                        onSettings: onOpenSettings,
                      ),
                      const SizedBox(height: 24),
                      // Center(
                      //   child: Text(
                      //     "F.E.A.C. Hymns v1.0.5",
                      //     style: TextStyle(
                      //       color: Colors.grey.shade600,
                      //       fontWeight: FontWeight.w600,
                      //       letterSpacing: 0.2,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Positioned.fill(
                    child: IgnorePointer(
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onOpenSettings});

  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "F.E.A.C. Hymns",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.4,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Your hymnal, on any device.",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
          ],
        ),
        IconButton(
          tooltip: "Settings",
          onPressed: onOpenSettings,
          icon: const Icon(Icons.tune_rounded),
        ),
      ],
    );
  }
}

class _SearchStrip extends StatelessWidget {
  const _SearchStrip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: const [
            Icon(Icons.search, color: Color(0xFF0F766E)),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "Search hymn by number or words...",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.hymnCount});

  final int hymnCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            SizedBox(
              width: itemWidth,
              child: _PillStat(
                label: "Offline hymns",
                value: hymnCount.toString(),
                icon: Icons.music_note_rounded,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _PillStat(
                label: "Ready to sing",
                value: "All set",
                icon: Icons.waves_rounded,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PillStat extends StatelessWidget {
  const _PillStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F766E).withOpacity(.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF0F766E)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.hymn, required this.onOpen});

  final Hymn hymn;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final preview = hymn.content.split('\n').take(3).join(' ').trim();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF0EA5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.star_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "Featured hymn",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Hymn ${hymn.hymnNo}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            preview,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(.9),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0F766E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onOpen,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text(
              "Open hymn",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({
    required this.onBrowse,
    required this.onRandom,
    required this.onSettings,
  });

  final VoidCallback onBrowse;
  final VoidCallback onRandom;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                title: "Offline library",
                subtitle: "Full collection on your device.",
                icon: Icons.library_books_rounded,
                onTap: onBrowse,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                title: "Random hymn",
                subtitle: "Let chance pick for you.",
                icon: Icons.shuffle_rounded,
                onTap: onRandom,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // _ActionCard(
        //   title: "Settings & themes",
        //   subtitle: "Light/dark mode, about, support.",
        //   icon: Icons.tune_rounded,
        //   onTap: onSettings,
        // ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F766E).withOpacity(.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF0F766E)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

class _ListTileCard extends StatelessWidget {
  const _ListTileCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
