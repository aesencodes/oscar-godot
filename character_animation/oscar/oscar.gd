extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -350.0
const JUMP_MAX = 2
const DeathThreshold = 790

@export var climbing = false
var jump_count = 0

var LIVE = 9
var check = true

var initial_position = Vector2()  # Simpan posisi awal pemain

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation = get_node("AnimationPlayer")

func _ready():
	initial_position = position 

func _physics_process(delta):
	if climbing == false:
		velocity.y += gravity * delta
	elif climbing == true:
		velocity.y = 0
		if Input.is_action_pressed("ui_up"):
			velocity.y = -SPEED
			animation.play("climb")
		elif Input.is_action_pressed("ui_down"):
			velocity.y = SPEED
			animation.play("climb")
	else:
		# Reset climbing animation when not climbing
		animation.play("idle")

	# Reset JUMP_COUNT
	if is_on_floor() and jump_count != 0:
		velocity.y += gravity * delta
		jump_count = 0
		

	if jump_count < JUMP_MAX:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
			animation.play("jump")
			jump_count += 1
	
		if position.y > DeathThreshold:
			animation.play("death")
			await get_tree().create_timer(0.5).timeout
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	
	if position.y < 790:
		if direction:
			velocity.x = direction * SPEED
			if velocity.y == 0:
				animation.play("walk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction:
		velocity.x = direction * SPEED
		if velocity.y > 0:
			animation.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			animation.play("idle")
		if velocity.y > 0:
			animation.play("idle")
		
	move_and_slide()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		LIVE = LIVE - 1
		position = initial_position
		print("NYAWA: ", LIVE)
