extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var anim_player:AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	var input_vector := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	if input_vector != Vector2.ZERO:
		velocity = input_vector * SPEED

		if input_vector.x > 0:
			anim_player.play("right")
		elif input_vector.x < 0:
			anim_player.play("left")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	move_and_slide()
