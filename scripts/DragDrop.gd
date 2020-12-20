extends Control

class_name DragDrop

export var snap_distance = 190

var dragging := false
var destination: ItemSlot

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
	var parent = draggable.get_parent()
	update_destination(parent)
	parent.raise()

func update_drag(draggable: BaseButton):
	var pos_offset = self.rect_scale * draggable.rect_size / 2
	draggable.set_global_position(draggable.get_global_mouse_position() - pos_offset)

	var min_distance = snap_distance
	var new_dest: ItemSlot = null

	for droppable in get_tree().get_nodes_in_group("droppable"):
		var dist = (draggable.rect_global_position - pos_offset - \
			droppable.rect_global_position).length()
		if dist < min_distance:
			min_distance = dist
			new_dest = droppable
	if new_dest and new_dest != destination: update_destination(new_dest)

func update_destination(new_dest: ItemSlot):
	if destination: destination.unhighlight()
	if new_dest: new_dest.highlight()
	destination = new_dest
	print(destination)

func stop_drag(draggable: BaseButton):
	dragging = false
	var parent: ItemSlot = draggable.get_parent()
	var destination_item = destination.get_item()

	parent.remove_item()
	destination.remove_item()
	parent.add_item(destination_item, false)
	destination.add_item(draggable)
	update_destination(null)
