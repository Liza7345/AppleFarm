extends Node2D

@export var empty_basket : Sprite2D = null
@export var basket_with_apples : Sprite2D = null
@export var signal_bus: SignalBus = null
<<<<<<< HEAD

var apples_count = 0
=======
>>>>>>> be79633d48fc7a978e2c8305c747e24e9195b433
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	empty_basket.visible = false
	basket_with_apples.visible = false
	signal_bus.show_basket.connect(_on_show_basket)
<<<<<<< HEAD
	signal_bus.gather_apple.connect(_on_gather_apple)

=======
>>>>>>> be79633d48fc7a978e2c8305c747e24e9195b433

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
<<<<<<< HEAD
	
func _on_show_basket(position : Vector2):
	apples_count = 0
=======
func _on_show_basket(position: Vector2):
>>>>>>> be79633d48fc7a978e2c8305c747e24e9195b433
	global_position = position
	_show_empty_basket()
	
func _show_empty_basket():
	empty_basket.visible = true
	basket_with_apples.visible = false
	
func _show_basket_with_apples():
	empty_basket.visible = false
	basket_with_apples.visible = true
<<<<<<< HEAD
	
func _on_gather_apple():
	apples_count = apples_count + 1
	
	if apples_count == 5:
		_show_basket_with_apples()
=======
>>>>>>> be79633d48fc7a978e2c8305c747e24e9195b433
