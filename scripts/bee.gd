extends CharacterBody2D


const MAX_SPEED = 350.0
const ACCELERATION = 800.0
const FRICTION = 400.0
const BUZZ_FREQUENCY = 15.0  # How fast the bee oscillates
const BUZZ_AMPLITUDE = 30.0  # How much the bee wobbles
const DRIFT_AMOUNT = 0.15    # Slight momentum/drift for out of control feel

@onready var anim_player:AnimationPlayer = $AnimationPlayer
@onready var audio_player:AudioStreamPlayer2D = $AudioStreamPlayer2D
var buzz_time: float = 0.0
var target_velocity := Vector2.ZERO


func _physics_process(delta: float) -> void:
	var input_vector := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	# Update buzz oscillation
	buzz_time += delta * BUZZ_FREQUENCY
	
	# Create buzzing/wobbling motion
	var buzz_offset := Vector2(
		sin(buzz_time) * BUZZ_AMPLITUDE,
		cos(buzz_time * 1.3) * BUZZ_AMPLITUDE * 0.7  # Different frequency for more chaotic feel
	)

	if input_vector != Vector2.ZERO:
		# Accelerate towards input direction with some drift
		target_velocity = input_vector * MAX_SPEED
		velocity = velocity.move_toward(target_velocity, ACCELERATION * delta)
		
		# Add slight drift - bee doesn't stop perfectly
		velocity += input_vector.rotated(0.3) * DRIFT_AMOUNT * MAX_SPEED * delta

		if input_vector.x > 0:
			anim_player.play("right")
		elif input_vector.x < 0:
			anim_player.play("left")
	else:
		# Apply friction when no input, but less responsive
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# Apply buzzing offset to final velocity
	var buzz_velocity = velocity + buzz_offset * delta * 60.0
	
	# Clamp to prevent going too fast with buzz
	if buzz_velocity.length() > MAX_SPEED * 1.2:
		buzz_velocity = buzz_velocity.normalized() * MAX_SPEED * 1.2
	
	velocity = buzz_velocity
	move_and_slide()
