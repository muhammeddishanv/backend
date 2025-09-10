import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'performance.controller.dart';

class PerformanceView extends GetResponsiveView<PerformanceController> {
  PerformanceView({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget? phone() => _buildScaffold(maxContentWidth: 900);

  @override
  Widget? tablet() {
    return phone();
  }

  @override
  Widget? desktop() {
    return phone();
  }

  Scaffold _buildScaffold({required double maxContentWidth}) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('User Progress'),
            centerTitle: true,
            pinned: true,
            backgroundColor: Get.theme.colorScheme.primary,
            foregroundColor: Get.theme.colorScheme.onPrimary,
            elevation: 0,
            toolbarHeight: 80,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(bottom: false, child: Container()),
            ),
          ),
          SliverToBoxAdapter(
            child: PerformanceContent(maxContentWidth: maxContentWidth),
          ),
        ],
      ),
    );
  }
}

class PerformanceContent extends StatelessWidget {
  const PerformanceContent({super.key, required this.maxContentWidth});
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),
                Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRankCard(scheme),
                const SizedBox(height: 24),
                Text(
                  'Performance Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                _buildStatsGrid(scheme),
                Text(
                  'Course Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                _buildCourseProgressList(scheme),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankCard(ColorScheme scheme) {
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 19),
      child: Stack(
        children: [
          Positioned(
            left: -10,
            top: 0,
            bottom: 0,
            child: Center(
              child: Icon(
                Icons.emoji_events,
                size: 108,
                color: scheme.primary.withAlpha(32),
              ),
            ),
          ),

          Positioned(
            right: 9,
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: scheme.secondaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.emoji_events, size: 17, color: scheme.primary),
                  const SizedBox(width: 5),
                  Text(
                    "Excellent",
                    style: TextStyle(
                      color: scheme.onSecondaryContainer,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.only(left: 98, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    'Your Ranking',
                    style: TextStyle(
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '#1',
                      style: TextStyle(
                        color: scheme.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 38,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'Rank',
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: 34,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Out Of 300 Students',
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(ColorScheme scheme) {
    final stats = <_StatItem>[
      _StatItem(
        icon: Icons.fact_check_outlined,
        title: 'Test Taken',
        value: '25',
      ),
      _StatItem(
        icon: Icons.star_border_rounded,
        title: 'Avg Test Score',
        value: '35',
      ),
      _StatItem(
        icon: Icons.emoji_events_outlined,
        title: 'Highest Test Score',
        value: '50',
      ),
      _StatItem(
        icon: Icons.school_outlined,
        title: 'Course Completed',
        value: '5',
      ),
      _StatItem(icon: Icons.access_time, title: 'Avg Watch Time', value: '75'),
      _StatItem(
        icon: Icons.menu_book_outlined,
        title: 'Chapters Completed',
        value: '21',
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => _buildStatTile(stats[index], scheme),
    );
  }

  Widget _buildStatTile(_StatItem item, ColorScheme scheme) {
    return Container(
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 4, right: 4, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: scheme.onSecondaryContainer, size: 20),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: scheme.onSecondaryContainer,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              item.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.onSecondaryContainer,
                fontWeight: FontWeight.w900,
                fontSize: 44,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseProgressList(ColorScheme scheme) {
    final items = <_CourseItem>[
      _CourseItem(
        icon: Icons.biotech_outlined,
        title: 'Biology',
        percent: 0.45,
      ),
      _CourseItem(
        icon: Icons.science_outlined,
        title: 'Chemistry',
        percent: 0.45,
      ),
      _CourseItem(icon: Icons.speed_outlined, title: 'Physics', percent: 0.45),
      _CourseItem(
        icon: Icons.agriculture_outlined,
        title: 'Agriculture',
        percent: 0.45,
      ),
      _CourseItem(
        icon: Icons.menu_book_outlined,
        title: 'Paper Writing',
        percent: 0.45,
      ),
    ];

    return Column(
      children: items.map((item) => _buildCourseTile(item, scheme)).toList(),
    );
  }

  Widget _buildCourseTile(_CourseItem item, ColorScheme scheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              decoration: BoxDecoration(
                color: scheme.secondaryContainer,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: scheme.shadow.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,

                    backgroundColor: scheme.background,
                    child: Icon(
                      item.icon,
                      size: 30,
                      color: scheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 18),
          _buildCircularPercent(item.percent, scheme),
        ],
      ),
    );
  }

  Widget _buildCircularPercent(double percent, ColorScheme scheme) {
    final size = 44.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: percent,
            strokeWidth: 4,
            backgroundColor: scheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
          ),
          Text(
            '${(percent * 100).round()}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  const _StatItem({
    required this.icon,
    required this.title,
    required this.value,
  });
  final IconData icon;
  final String title;
  final String value;
}

class _CourseItem {
  const _CourseItem({
    required this.icon,
    required this.title,
    required this.percent,
  });
  final IconData icon;
  final String title;
  final double percent;
}
