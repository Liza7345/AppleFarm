extends Node2D

@export var signal_bus: SignalBus = null
@onready var sale_zone = $SaleZone

func _ready() -> void:
	sale_zone.signal_bus = signal_bus
