extends Node

@export var signal_bus: SignalBus = null

@onready var default_cursor = preload("res://Assets/Game/Cursor/cursor.png")
@onready var choose_cursor = preload("res://Assets/Game/Cursor/cursor_choose.png")

func _ready():
	# Устанавливаем стандартный курсор
	set_default_cursor()
	
	# Подключаемся к сигналам
	if signal_bus:
		signal_bus.selection_mode_entered.connect(_on_selection_mode_entered)
		signal_bus.selection_mode_exited.connect(_on_selection_mode_exited)
	else:
		push_error("CursorManager: signal_bus not assigned!")

func set_default_cursor():
	Input.set_custom_mouse_cursor(default_cursor, Input.CURSOR_ARROW, Vector2(0, 0))

func set_choose_cursor():
	Input.set_custom_mouse_cursor(choose_cursor, Input.CURSOR_ARROW, Vector2(0, 0))

func _on_selection_mode_entered():
	set_choose_cursor()

func _on_selection_mode_exited():
	set_default_cursor()
