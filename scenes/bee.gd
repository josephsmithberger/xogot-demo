extends CharacterBody2D

const MAX_SPEED := 250.0
const ACCELERATION := 600.0
const FRICTION := 300.0
const BUZZ_FREQUENCY_X := 18.0
const BUZZ_FREQUENCY_Y := 22.0
const BUZZ_SPEED := 120.0

@onready var anim_player:AnimationPlayer = $AnimationPlayer

var _buzz_time := 0.0

func _physics_process(delta: float) -> void:
    _buzz_time += delta

    var input_vector := Vector2(
        Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
        Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
    ).normalized()

    if input_vector != Vector2.ZERO:
        var desired_velocity := input_vector * MAX_SPEED
        velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)

        if input_vector.x > 0:
            anim_player.play("right")
        elif input_vector.x < 0:
            anim_player.play("left")
    else:
        velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

    var buzz_velocity := Vector2(
        sin(_buzz_time * BUZZ_FREQUENCY_X),
        cos(_buzz_time * BUZZ_FREQUENCY_Y)
    ) * BUZZ_SPEED
    velocity += buzz_velocity * delta

    move_and_slide()
