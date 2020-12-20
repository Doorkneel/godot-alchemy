extends Control

# Debug flag which checks all 
export var run_checker: bool

var ingredient_info
var recipes

func _ready():
	# load recipes and ingredient info from JSON files
	var ing_file = File.new()
	ing_file.open("res://data/ingredient_info.json", File.READ)
	ingredient_info = parse_json(ing_file.get_as_text())
	ing_file.close()
	
	var recipe_file = File.new()
	recipe_file.open("res://data/recipes.json", File.READ)
	recipes = parse_json(recipe_file.get_as_text())
	recipe_file.close()
	
	print(check_recipe(["Ash", "NewtEye"], "DISTILLER"))

func check_recipe(ingredients: Array, equipment: String):
	for recipe in recipes:
		# simple exit cases
		if recipe["equipment"] != equipment: continue
		
		var recipe_ings = recipe["ingredients"]
		var recipe_props = recipe["ingredient_props"]
		if (recipe_ings + recipe_props).size() != ingredients.size(): continue
		
		var can_cont := false
		for ingredient in recipe_ings:
			can_cont = can_cont or not ingredient in ingredients
		if can_cont: continue
		
		# things are simple without properties
		if recipe_props.size() == 0:
			ingredients.sort()
			recipe_ings.sort()
			if ingredients == recipe_ings: return recipe["results"]
			else: continue
		
		# for each recipe property, obtain list of input ingredients matching it
		var matches := []
		can_cont = false
		
		for prop in recipe_props:
			var prop_matches := []
			for ingredient in ingredients:
				if prop in ingredient_info[ingredient]["known_properties"] or \
						prop in ingredient_info[ingredient]["unknown_properies"]:
					prop_matches.append(ingredient)
			can_cont = can_cont or prop_matches.size() == 0
			matches.append(prop_matches)
		
		# continue if any property is matched by no ingredients
		if can_cont: continue
		
		# remove one of each ingredient in recipe from copy of input ingredients
		var input_ings = ingredients.duplicate()
		for ingredient in recipe_ings:
			input_ings.remove(input_ings.find(ingredient)) # we know ingredient in input_ings
		
		# permute remaining input_ings and check each permutation against matches
		if check_all_permutations(input_ings, matches, input_ings.size()):
			return recipe["results"]
	return []

func check_all_permutations(input_ings: Array, matches: Array, k: int):
	if k == 1:
		if check_permutation(input_ings, matches): return true
	else:
		if check_all_permutations(input_ings, matches, k - 1): return true
		for i in k - 1:
			if k % 2 == 0: swap(input_ings, i, k - 1)
			else: swap(input_ings, 0, k - 1)
			if check_all_permutations(input_ings, matches, k - 1): return true
	return false

func check_permutation(input_ings: Array, matches: Array):
	for i in input_ings.size():
		if not input_ings[i] in matches[i]: return false
	return true

func swap(arr: Array, i: int, j: int):
	var tmp = arr[i]
	arr[i] = arr[j]
	arr[j] = tmp
