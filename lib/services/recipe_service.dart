import '../core/app_config.dart';
import '../models/recipe.dart';
import 'api_client.dart';

class RecipeService {
  final ApiClient _client = ApiClient(baseUrl: AppConfig.baseUrl);

  Future<List<Recipe>> getRecipes() async {
    final json = await _client.getJson("/recipes");
    final list = (json["data"] as List<dynamic>? ?? []);
    return list.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Recipe> getRecipeById(String id) async {
    final json = await _client.getJson("/recipes/$id");
    return Recipe.fromJson(json["data"] as Map<String, dynamic>);
  }

  Future<Recipe> createRecipe(Recipe recipe) async {
    final json = await _client.postJson("/recipes", recipe.toJsonForCreateUpdate());
    return Recipe.fromJson(json["data"] as Map<String, dynamic>);
  }

  Future<Recipe> updateRecipe(String id, Recipe recipe) async {
    final json = await _client.putJson("/recipes/$id", recipe.toJsonForCreateUpdate());
    return Recipe.fromJson(json["data"] as Map<String, dynamic>);
  }

  Future<void> deleteRecipe(String id) async {
    await _client.delete("/recipes/$id");
  }
}
