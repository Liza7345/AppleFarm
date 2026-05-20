extends Area2D

var signal_bus : SignalBus = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_signal_bus(_signal_bus : SignalBus):
	signal_bus = _signal_bus
	
func _on_body_entered(body : RigidBody2D):
	if "Apple" in body.name:
		body.set_deferred("freeze", true)
		body.set_deferred("visible", false)
		signal_bus.gather_apple.emit()
