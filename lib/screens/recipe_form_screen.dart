import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

class RecipeFormScreen extends StatefulWidget {
  final Recipe? existing;
  const RecipeFormScreen({super.key, this.existing});

  @override
  State<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends State<RecipeFormScreen> {
  final RecipeService _service = RecipeService();

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _title;
  late final TextEditingController _category;
  late final TextEditingController _timeMinutes;
  late final TextEditingController _imageUrl;
  late final TextEditingController _ingredients;
  late final TextEditingController _steps;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(text: e?.title ?? "");
    _category = TextEditingController(text: e?.category ?? "Main Dish");
    _timeMinutes = TextEditingController(text: (e?.timeMinutes ?? 10).toString());
    _imageUrl = TextEditingController(
      text: e?.imageUrl ?? "https://picsum.photos/seed/recipe/400/300",
    );

    // ingredients & steps kita simpen dalam textarea (dipisah baris)
    _ingredients = TextEditingController(text: (e?.ingredients ?? []).join("\n"));
    _steps = TextEditingController(text: (e?.steps ?? []).join("\n"));
  }

  @override
  void dispose() {
    _title.dispose();
    _category.dispose();
    _timeMinutes.dispose();
    _imageUrl.dispose();
    _ingredients.dispose();
    _steps.dispose();
    super.dispose();
  }

  List<String> _lines(String raw) {
    return raw
        .split("\n")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final time = int.tryParse(_timeMinutes.text.trim()) ?? 0;

    final recipe = Recipe(
      id: widget.existing?.id ?? "",
      title: _title.text.trim(),
      category: _category.text.trim(),
      timeMinutes: time,
      imageUrl: _imageUrl.text.trim(),
      ingredients: _lines(_ingredients.text),
      steps: _lines(_steps.text),
      createdAt: widget.existing?.createdAt,
      updatedAt: DateTime.now(),
    );

    try {
      if (widget.existing == null) {
        await _service.createRecipe(recipe);
      } else {
        await _service.updateRecipe(widget.existing!.id, recipe);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal simpan: $e")));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Resep" : "Tambah Resep")),
      body: AbsorbPointer(
        absorbing: _saving,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: "Judul Resep",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? "Judul wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _category,
                decoration: const InputDecoration(
                  labelText: "Kategori",
                  hintText: "Main Dish / Dessert / Drink",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? "Kategori wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _timeMinutes,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Waktu (menit)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final n = int.tryParse(v?.trim() ?? "");
                  if (n == null || n <= 0) return "Isi angka menit yang valid";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrl,
                decoration: const InputDecoration(
                  labelText: "Image URL",
                  hintText: "https://...",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? "Image URL wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ingredients,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: "Bahan-bahan (1 baris = 1 bahan)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => _lines(v ?? "").isEmpty ? "Minimal 1 bahan" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _steps,
                maxLines: 7,
                decoration: const InputDecoration(
                  labelText: "Langkah (1 baris = 1 langkah)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => _lines(v ?? "").isEmpty ? "Minimal 1 langkah" : null,
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: _submit,
                icon: _saving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save),
                label: Text(_saving ? "Menyimpan..." : "Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}
