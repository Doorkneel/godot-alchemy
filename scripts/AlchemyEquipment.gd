extends Control

enum AlchProps {
	FLAMMABLE,
	SOLUBLE_IN_WATER,
	SOLUBLE_IN_ALCOHOL,
	EXPLOSIVE,
	VISCOUS
}

enum Equipment {
	BURNER,
	PETRI_DISH,
	DISTILLER,
	PESTLE_MORTAR
}

var ingredient_info = {
	"NewtEye": {
		"name": "A Newt's Eye",
		"description": "One more herptile cyclops!",
		"known_properties": ["VISCOUS"],
		"unknown_properies": [],
		"discovered": false,
		"sprite": null
	}
}

var recipes = [
	{
		"results": ["LovePotion"],
		"ingredients": ["NewtEye"],
		"ingredient_props": ["SOLUBLE_IN_ALCOHOL"],
		"equipment": "DISTILLER"
	},
	{
		"results": ["LovePotion"],
		"ingredients": ["DogNose"],
		"ingredient_props": ["SOLUBLE_IN_ALCOHOL"],
		"equipment": "DISTILLER"
	},
	{
		"results": ["Ash", "Disappoinment"],
		"ingredients": [],
		"ingredient_props": ["FLAMMABLE"],
		"equipment": "BURNER"
	}
]

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
