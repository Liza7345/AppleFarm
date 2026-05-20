extends Area2D

@export var signal_bus: SignalBus = null
@onready var hint_bubble = $HintBubble

var player_inside: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	hint_bubble.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Девочка":
		player_inside = true
		hint_bubble.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Девочка":
		player_inside = false
		hint_bubble.visible = false

func _process(_delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("Sell"):
		signal_bus.sale_zone_opened.emit()
