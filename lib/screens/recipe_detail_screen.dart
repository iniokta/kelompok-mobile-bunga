import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../widgets/loading_error.dart';
import 'recipe_form_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final RecipeService _service = RecipeService();

  bool _loading = false;
  String? _error;
  Recipe? _recipe;

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
      final r = await _service.getRecipeById(widget.recipeId);
      setState(() => _recipe = r);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus resep?"),
        content: const Text("Aksi ini tidak bisa dibatalkan."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await _service.deleteRecipe(widget.recipeId);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal hapus: $e")));
    }
  }

  Future<void> _edit() async {
    if (_recipe == null) return;
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => RecipeFormScreen(existing: _recipe)),
    );
    if (changed == true) {
      _fetch();
      if (!mounted) return;
      // memberi sinyal ke list screen bahwa ada perubahan
      // tapi kita tetap pop dengan true hanya kalau user balik
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Resep"),
        actions: [
          IconButton(onPressed: _fetch, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: _edit, icon: const Icon(Icons.edit)),
          IconButton(onPressed: _delete, icon: const Icon(Icons.delete)),
        ],
      ),
      body: Builder(
        builder: (_) {
          if (_loading || _error != null) {
            return LoadingError(isLoading: _loading, error: _error, onRetry: _fetch);
          }
          final r = _recipe!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.network(
                    r.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.black12, child: const Center(child: Icon(Icons.image))),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(r.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text("${r.category} • ${r.timeMinutes} menit", style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),

              Text("Bahan-bahan", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...r.ingredients.map((x) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("• "),
                        Expanded(child: Text(x)),
                      ],
                    ),
                  )),

              const SizedBox(height: 16),
              Text("Langkah-langkah", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...r.steps.asMap().entries.map((e) {
                final idx = e.key + 1;
                final step = e.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$idx. ", style: const TextStyle(fontWeight: FontWeight.w700)),
                      Expanded(child: Text(step)),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
