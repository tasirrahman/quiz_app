import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quiz_app/app/routes/navigate.dart';
import 'package:quiz_app/utils/app_colors.dart';
import 'package:quiz_app/view/create_quiz_screen.dart';
import 'package:quiz_app/view/quiz_screen.dart';
import 'package:quiz_app/widgets/card/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Data Structures', 'icon': Icons.storage, 'color': Colors.blue},
    {'name': 'Algorithms', 'icon': Icons.timeline, 'color': Colors.deepPurple},
    {'name': 'Computer Networks', 'icon': Icons.router, 'color': Colors.green},
    {'name': 'Operating Systems', 'icon': Icons.memory, 'color': Colors.teal},
    {
      'name': 'Database Systems',
      'icon': Icons.storage_rounded,
      'color': Colors.indigo,
    },
    {
      'name': 'Software Engineering',
      'icon': Icons.engineering,
      'color': Colors.orange,
    },
    {'name': 'Web Development', 'icon': Icons.web, 'color': Colors.cyan},
    {
      'name': 'Mobile App Dev',
      'icon': Icons.phone_android,
      'color': Colors.lightBlue,
    },
    {'name': 'Cyber Security', 'icon': Icons.security, 'color': Colors.red},
    {
      'name': 'Machine Learning',
      'icon': Icons.auto_graph,
      'color': Colors.purple,
    },
    {
      'name': 'Artificial Intelligence',
      'icon': Icons.smart_toy,
      'color': Colors.pinkAccent,
    },
    {'name': 'Cloud Computing', 'icon': Icons.cloud, 'color': Colors.blueGrey},
    {
      'name': 'Programming Concepts',
      'icon': Icons.code,
      'color': Colors.deepOrange,
    },
    {
      'name': 'Version Control (Git)',
      'icon': Icons.merge_type,
      'color': Colors.brown,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Text('QUIZ APP', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              _showCategoryBottomSheet(context);
            },
            icon: Icon(Icons.add_circle_outline_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a Category',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 3,
                  mainAxisSpacing: 16,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(3, 1, 3, 3),
                    child: CategoryCard(
                      name: _categories[index]['name'],
                      icon: _categories[index]['icon'],
                      color: _categories[index]['color'],
                      onTap: () {
                        Navigate.to(
                          context,
                          QuizScreen(category: _categories[index]['name']),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.add_circle_outline, color: AppColors.appColor),
                      const SizedBox(width: 12),
                      Text(
                        'Create Quiz',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Select a category for your new quiz',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.appColor,
                            child: Icon(
                              _categories[index]['icon'],
                              color: Colors.white,
                            ),
                          ),
                          title: Text(_categories[index]['name']),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.pop(context);
                            Navigate.to(
                              context,
                              CreateQuizScreen(
                                category: _categories[index]['name'],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
