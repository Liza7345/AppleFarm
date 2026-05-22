extends Control

@export var game_ended_panel : CanvasItem = null

@onready var signal_bus = SignalBus
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if signal_bus:
		signal_bus.game_ended.connect(_on_game_ended)
	visible = false


func _on_game_ended():
	visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
