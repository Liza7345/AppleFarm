class_name AppleNode
extends Node2D

@export var rigid_body : RigidBody2D = null
@onready var parent_node = get_parent()

var apple_selected : bool = false
# @export var signal_bus : SignalBus = null

var signal_bus : SignalBus = null

func _ready() -> void:
	pass

func set_signal_bus(_signal_bus : SignalBus):
	signal_bus = _signal_bus
	signal_bus.current_tree_selected_root.connect(_on_current_tree_selected_root)
	signal_bus.apples_fall.connect(_on_apples_fall)


func find_first_of_type(type : String) -> Node:
	var nodes = get_tree().get_nodes_in_group("")
	for node in nodes:
		if node.get_class() == type:
			return node
	return null

func _on_current_tree_selected_root(root : Node2D):
	if parent_node == root:
		apple_selected = true
	else:
		apple_selected = false
		
func _on_apples_fall():
	if apple_selected:
		fall()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fall():
	rigid_body.freeze = false
	print("Яблоко падает")
