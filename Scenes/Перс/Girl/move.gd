extends CharacterBody2D

@export var speed: float = 150.0
@onready var animated_sprite = $AnimatedSprite2D

var direction = Vector2.ZERO
var last_direction = Vector2.DOWN

func _physics_process(delta):
	 # Получаем нажатия клавиш
	if Input.is_action_pressed("WalkLeft"):
		direction=Vector2.LEFT
	elif  Input.is_action_pressed("WalkRight"):
		direction=Vector2.RIGHT
	elif  Input.is_action_pressed("WalkDown"):
		direction=Vector2.DOWN
	elif  Input.is_action_pressed("WalkUp"):
		direction=Vector2.UP
	else:
		direction=Vector2.ZERO
	if direction==Vector2.UP:
		animated_sprite.play("idle_back")
	elif direction==Vector2.DOWN:
		animated_sprite.play("idle_front")
	elif direction==Vector2.RIGHT:
		animated_sprite.play("idle_right")
	elif direction==Vector2.LEFT:
		animated_sprite.play("idle_left")
	else: animated_sprite.play("idle_stay")
	 
	 # Движение
	velocity = direction * speed
	move_and_slide()
