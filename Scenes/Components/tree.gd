extends Node2D

@export var signal_bus : SignalBus = null
@export var physics_collision: CollisionShape2D = null
@export var apples : Array[Apple] = []
@onready var animated_sprite = $AnimatedSprite2D
@export var root : Node2D = null
@onready var area = $Area2D

var selection_mode : bool = false
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.input_event.connect(_on_click)
	signal_bus.selection_mode_entered.connect(_on_selection_mode_entered)
	signal_bus.selection_mode_exited.connect(_on_selection_mode_exited)
	for apple in apples:
		apple.set_signal_bus(signal_bus)

func _on_selection_mode_entered():
	selection_mode = true
	
func _on_selection_mode_exited():
	selection_mode = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _physic_process(delta: float) -> void:
	animated_sprite.play("idle")
	
func _on_click(viewport, event, shape_idx):
	if selection_mode and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		signal_bus.current_tree_selected.emit(physics_collision)
		signal_bus.current_tree_selected_root.emit(root)
