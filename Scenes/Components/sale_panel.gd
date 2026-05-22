extends CanvasLayer
@export var settings: GameSettings = null

@onready var spinbox: SpinBox = $Control/Panel/VBoxContainer/ExchangeRow/AppleCol/SpinBox
@onready var coins_preview: Label = $Control/Panel/VBoxContainer/ExchangeRow/CoinCol/CoinsPreview
@onready var sell_button: Button = $Control/Panel/VBoxContainer/ButtonsRow/SellButton
@onready var signal_bus = SignalBus

var apple_count: int = 0
var coins: int = 0
var goal: int = 0
func _ready() -> void:
	signal_bus.sale_zone_opened.connect(_on_sale_zone_opened)
	signal_bus.gather_apple.connect(_on_gather_apple)
	signal_bus.sell_apples.connect(_on_sell_apples)
	spinbox.value_changed.connect(_on_spinbox_value_changed)
	signal_bus.game_started.connect(_save_goal)
	$Control/Panel/VBoxContainer/ButtonsRow/SellButton.pressed.connect(_on_sell_pressed)
	$Control/Panel/VBoxContainer/ButtonsRow/CloseButton.pressed.connect(_on_close_pressed)
func _save_goal(_goal):
	goal = _goal
func _on_sale_zone_opened() -> void:
	if apple_count == 0:
		spinbox.min_value = 0
		spinbox.max_value = 0
		spinbox.value = 0
		spinbox.editable = false
		sell_button.disabled = true
		coins_preview.text = "0 монет"
	else:
		spinbox.min_value = 1
		spinbox.max_value = apple_count
		spinbox.value = 1
		spinbox.editable = true
		sell_button.disabled = false
		_update_coins_preview(1)
	visible = true

func _on_gather_apple() -> void:
	apple_count += 1

func _on_sell_apples(_count: int, total_coins: int) -> void:
	coins = total_coins

func _on_spinbox_value_changed(value: float) -> void:
	var clamped = clamp(int(value), 0, apple_count)
	_update_coins_preview(clamped)

func _update_coins_preview(count: float) -> void:
	coins_preview.text = "%d монет" % (int(count) * settings.apple_price)

func _on_sell_pressed() -> void:
	var count = int(spinbox.value)
	if count <= 0 or count > apple_count:
		return
	apple_count -= count
	coins += count * settings.apple_price
	signal_bus.sell_apples.emit(count, coins)
	_close()
	if coins >= goal:
		signal_bus.game_ended.emit()
	signal_bus.game_ended.emit()

func _on_close_pressed() -> void:
	_close()

func _close() -> void:
	visible = false
