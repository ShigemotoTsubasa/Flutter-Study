import 'package:first_app/services/selected_task_category_service.dart';
import 'package:first_app/services/task_categories_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskTabs extends ConsumerWidget {
  const TaskTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskCategories = ref.watch(taskCategoriesServiceProvider);
    final selectedIndex = ref.watch(selectedTaskCategoryServiceProvider);

    return taskCategories.when(
      data: (categories) {
        return SizedBox(
          height: 50.0,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            ref
                                .read(
                                  selectedTaskCategoryServiceProvider.notifier,
                                )
                                .selectCategory(0);
                          },
                          child: Chip(
                            label: const Text('すべて'),
                            backgroundColor: selectedIndex == 0
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surfaceVariant,
                            labelStyle: TextStyle(
                              color: selectedIndex == 0
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      );
                    }
                    final category = categories[index - 1];
                    final isSelected = category.categoryId == selectedIndex;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          ref
                              .read(
                                selectedTaskCategoryServiceProvider.notifier,
                              )
                              .selectCategory(category.categoryId);
                        },
                        child: Chip(
                          label: Text(category.categoryName),
                          backgroundColor: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surfaceVariant,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
