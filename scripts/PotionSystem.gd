extends Node2D

class_name PotionSystem

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum AlchemyItem {
	NEWT_EYE,
	CHARCOAL,
	ASH,
	FAILURE
}

class Recipe:
	var ingredients
	
	func _init(ingredients=[], result=AlchemyItem.FAILURE):
		self.ingredients = ingredients
		

var recipe_list = {
	{
		AlchemyItem.CHARCOAL: true,
		AlchemyItem.ASH: true
	}: AlchemyItem.NEWT_EYE,
	{
		AlchemyItem.CHARCOAL: true
	}: AlchemyItem.CHARCOAL
}

# Called when the node enters the scene tree for the first time.
func _ready():
	print("SDDF")
	pass # Replace with function body.
	
func _init():
	print("SDDFPOK")
	pass
	

#func _get_()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
