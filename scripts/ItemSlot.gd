extends CenterContainer

class_name ItemSlot

export var default_color := Color(0.5, 0.5, 0.5)
export var highlight_color: Color = default_color.lightened(0.3)

export var item: String = ""

var occupied_by = null

func _ready():
	if get_child_count() > 2:
		occupied_by = get_children()[2]

func highlight():
	$ColorRect.color = highlight_color

func unhighlight():
	$ColorRect.color = default_color

func get_item():
	return occupied_by

func add_item(item, play_sound := true):
	if item:
		if play_sound: $Sound.play()
		add_child(item)
		occupied_by = item

func remove_item():
	if occupied_by:
		remove_child(occupied_by)
		occupied_by = null
