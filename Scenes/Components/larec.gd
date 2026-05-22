extends Node2D

@onready var signal_bus = SignalBus
@onready var sale_zone = $SaleZone

func _ready() -> void:
	sale_zone.signal_bus = signal_bus
