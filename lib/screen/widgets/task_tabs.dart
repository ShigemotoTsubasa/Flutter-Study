import 'package:first_app/services/task_categories_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskTabs extends ConsumerWidget {
  const TaskTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskCategories = ref.watch(taskCategoriesServiceProvider);

    return taskCategories.when(
      data: (categories) {
        return SizedBox(
          height: 50.0,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(category.categoryName),
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
