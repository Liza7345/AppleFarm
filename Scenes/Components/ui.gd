extends Node2D

@export var signal_bus: SignalBus = null
@export var apples_counter: Label = null
@export var coins_counter: Label = null

var count: int = 0

func _ready() -> void:
	signal_bus.gather_apple.connect(_on_gather_apple)
	signal_bus.sell_apples.connect(_on_sell_apples)

func _on_gather_apple() -> void:
	count += 1
	apples_counter.text = str(count)

func _on_sell_apples(sold_count: int, total_coins: int) -> void:
	count -= sold_count
	if count < 0:
		count = 0
	apples_counter.text = str(count)
	if coins_counter:
		coins_counter.text = str(total_coins)
