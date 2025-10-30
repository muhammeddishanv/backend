import 'package:ed_tech/app/modules/on_boarding/controllers/category.controller.dart';
import 'package:ed_tech/app/modules/on_boarding/views/sub_category.view.dart';
import 'package:ed_tech/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CategoryView extends GetResponsiveView<CategoryController> {
  CategoryView({super.key});

  // Local reactive state to track selections without assuming controller fields.
  final RxString _selected = "".obs;

  final List<_CategoryOption> _options = const [
    _CategoryOption(label: 'KTET', icon: Icons.school_outlined),
    _CategoryOption(label: 'LP/UP', icon: Icons.menu_book_outlined),
    _CategoryOption(label: 'HSA', icon: Icons.account_balance_outlined),
    _CategoryOption(label: 'NET', icon: Icons.science_outlined),
    _CategoryOption(label: 'Digital Academy', icon: Icons.computer_outlined),
    _CategoryOption(label: 'Crash Course', icon: Icons.timer_outlined),
  ];

  @override
  Widget? phone() {
    return _buildCategoryContent();
  }

  @override
  Widget? tablet() {
    return _buildCategoryContent();
  }

  @override
  Widget? desktop() {
    return _buildCategoryContent();
  }

  Widget _buildCategoryContent() {
    return Scaffold(
      // appBar: AppBar(title: const Text('CategoryView'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Your Category',
                style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a category to list your\ncategories',
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Colors.black.withValues(alpha: 0.5),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              // Grid of categories
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.05,
                  ),
                  itemCount: _options.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final option = _options[index];
                    // Rebuild only this tile when selection set changes.
                    return Obx(() {
                      final isSelected = _selected.value == option.label;
                      return _CategoryCard(
                        option: option,
                        selected: isSelected,
                        onTap: () {
                          // Toggle single selection
                          _selected.value = isSelected ? "" : option.label;
                        },
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Bottom Continue button
              SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: _selected.value.isEmpty
                          ? null
                          : () {
                              Get.to(
                                SubCategoryView(),
                                arguments: _selected.value,
                                routeName: Routes.SUB_CATEGORY,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.theme.primaryColor,
                        foregroundColor: Get.theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryOption {
  final String label;
  final IconData icon;
  const _CategoryOption({required this.label, required this.icon});
}

class _CategoryCard extends StatelessWidget {
  final _CategoryOption option;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Get.theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? Get.theme.primaryColor : Colors.black12,
              width: 1.4,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: selected
                      ? Get.theme.colorScheme.primary.withOpacity(0.1)
                      : Colors.black12.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  option.icon,
                  size: 34,
                  color: selected
                      ? Get.theme.colorScheme.primary
                      : Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                option.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
