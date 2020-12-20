extends Control

var ingredient_info
var recipes

func _ready():
	
	var ing_file = File.new()
	ing_file.open("res://data/ingredient_info.json", File.READ)
	ingredient_info = parse_json(ing_file.get_as_text())
	ing_file.close()
	
	var recipe_file = File.new()
	recipe_file.open("res://data/recipes.json", File.READ)
	recipes = parse_json(recipe_file.get_as_text())
	recipe_file.close()

func check_recipe(ingredients, equipment):
	for recipe in recipes:
		# simplest continue cases
		if recipe["equipment"] != equipment: continue
		var recipe_ings = recipe["ingredients"]
		var recipe_props = recipe["ingredient_props"]
		if (recipe_ings + recipe_props).size() != ingredients.size(): continue
		
		# things are simple without properties
#		if recipe_props.size() == 0:
#			ingredients.sort()
#			recipe_ings.sort()
#			if ingredients == recipe_ings: return recipe["results"]
#			else: continue
		
		# for each given ingredient, obtain list of things (ingredients / props)
		# in the recipe specification which are matched by that ingredient
		var matches: Dictionary = {}
		var immediate_continue := false

		for ingredient in ingredients:
			matches[ingredient] = []
			if ingredient is recipe_ings: matches[ingredient].append(ingredient)
			
			var ing_props = ingredient_info[ingredient]["known_properties"] + \
				ingredient_info[ingredient]["unknown_properies"]
			for prop in recipe_props:
				if prop in ing_props: matches[ingredient].append(prop)
			
			immediate_continue |= matches[ingredient].size() == 0
		
		# continue if any ingredient matches nothing in recipe spec
		if immediate_continue: continue
		
		# finally check whether recipe specification can be divided among the
		# ingredient matches
		pass
