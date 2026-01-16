import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../widgets/loading_error.dart';
import '../widgets/recipe_card.dart';
import 'recipe_form_screen.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final RecipeService _service = RecipeService();

  bool _loading = false;
  String? _error;
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _service.getRecipes();
      setState(() => _recipes = data);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _goAdd() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const RecipeFormScreen()),
    );
    if (created == true) _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resep Masakan"),
        actions: [
          IconButton(
            onPressed: _fetch,
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goAdd,
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
      ),
      body: Builder(
        builder: (_) {
          if (_loading || _error != null) {
            return LoadingError(isLoading: _loading, error: _error, onRetry: _fetch);
          }
          if (_recipes.isEmpty) {
            return const Center(child: Text("Belum ada resep. Tambah dulu ya!"));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: _recipes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final r = _recipes[i];
              return RecipeCard(
                recipe: r,
                onTap: () async {
                  final changed = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipeId: r.id)),
                  );
                  if (changed == true) _fetch();
                },
              );
            },
          );
        },
      ),
    );
  }
  
}
