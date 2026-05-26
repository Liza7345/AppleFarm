extends CanvasLayer

@onready var spinbox: SpinBox = $Control/Panel/VBoxContainer/SpinBox
@onready var start_button: Button = $Control/Panel/VBoxContainer/StartButton
@onready var signal_bus = SignalBus

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	spinbox.min_value = 1
	spinbox.max_value = 99999
	spinbox.value = 100
	visible = false  # По умолчанию скрыта
	
	# Подписываемся на сигналы из SignalBus
	signal_bus.show_start_panel.connect(_on_show_start_panel)
	signal_bus.hide_start_panel.connect(_on_hide_start_panel)

func _on_show_start_panel(goal: int) -> void:
	"""Показать панель старта с указанной целью"""
	spinbox.value = goal
	visible = true
	print("Показана панель старта, цель: ", goal)

func _on_hide_start_panel() -> void:
	"""Скрыть панель старта (игра уже активна)"""
	visible = false
	print("Панель старта скрыта")

func _on_start_pressed() -> void:
	"""Нажата кнопка старта"""
	var goal = int(spinbox.value)
	signal_bus.game_started.emit(goal)
	visible = false
