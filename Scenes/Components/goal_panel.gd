extends CanvasLayer

@onready var signal_bus = SignalBus

@onready var spinbox: SpinBox = $Control/Panel/VBoxContainer/SpinBox
@onready var start_button: Button = $Control/Panel/VBoxContainer/StartButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	spinbox.min_value = 1
	spinbox.max_value = 99999
	spinbox.value = 100
	visible = true

func _on_start_pressed() -> void:
	var goal = int(spinbox.value)
	signal_bus.game_started.emit(goal)
	visible = false
