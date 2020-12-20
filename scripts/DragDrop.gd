extends Control

export var snap_distance = 190

var dragging := false
var destination: CenterContainer

func _ready():
	var draggables = get_tree().get_nodes_in_group("draggable")
	for draggable in draggables:
		draggable.connect("gui_input", self, "input", [draggable])

func input(event, draggable: BaseButton):
	if event is InputEventMouseButton:
		if dragging: stop_drag(draggable)
		else: start_drag(draggable)
	elif event is InputEventMouseMotion:
		if dragging: update_drag(draggable)

func start_drag(draggable: BaseButton):
	dragging = true
	update_destination(draggable.get_parent())
	destination.raise()

func update_drag(draggable: BaseButton):
	draggable.set_global_position(draggable.get_global_mouse_position() 
		- draggable.get_rect().size / 2)

	var min_distance = snap_distance
	for child in get_children():
		if child is CenterContainer:
			var dist = (draggable.rect_global_position - child.rect_global_position).length()
			if dist < min_distance:
				min_distance = dist
				update_destination(child)

func update_destination(new_dest):
	if destination: destination.unhighlight()
	if new_dest: new_dest.highlight()
	destination = new_dest

func stop_drag(draggable: BaseButton):
	dragging = false
	draggable.get_parent().remove_child(draggable)
	destination.add_child(draggable)
	update_destination(null)
