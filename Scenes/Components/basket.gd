extends Node2D

@export var empty_basket : Sprite2D = null
@export var basket_with_apples : Sprite2D = null
@export var signal_bus: SignalBus = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	empty_basket.visible = false
	basket_with_apples.visible = false
	signal_bus.show_basket.connect(_on_show_basket)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_show_basket(position: Vector2):
	global_position = position
	_show_empty_basket()
	
func _show_empty_basket():
	empty_basket.visible = true
	basket_with_apples.visible = false
	
func _show_basket_with_apples():
	empty_basket.visible = false
	basket_with_apples.visible = true
