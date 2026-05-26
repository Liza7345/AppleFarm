extends Node2D

@export var empty_basket : Sprite2D = null
@export var basket_with_apples : Sprite2D = null

@onready var signal_bus = SignalBus

var apples_count = 0
var last_tree = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	empty_basket.visible = false
	basket_with_apples.visible = false
	signal_bus.show_basket.connect(_on_show_basket)
	signal_bus.gather_apple.connect(_on_gather_apple)
	signal_bus.game_started.connect(_on_game_started)

func _on_game_started(_goal: int) -> void:
	apples_count = 0
	empty_basket.visible = false
	basket_with_apples.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_show_basket(position : Vector2):
	apples_count = 0
	global_position = position
	_show_empty_basket()

	
func _show_empty_basket():
	empty_basket.visible = true
	basket_with_apples.visible = false
	
func _show_basket_with_apples():
	empty_basket.visible = false
	basket_with_apples.visible = true
	
func _on_gather_apple():
	apples_count = apples_count + 1
	if apples_count >= 2:
		_show_basket_with_apples()
