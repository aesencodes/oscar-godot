extends CharacterBody2D

class_name Oscar

const SPEED = 150.0
const JUMP_VELOCITY = -350.0
const JUMP_MAX = 2
const DeathThreshold = 794

@export var climbing = false
var jump_count = 0

var death_enemy = false

var check = true

var initial_position = Vector2()  # Simpan posisi awal pemain

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation 	= get_node("AnimationPlayer")
@onready var sfx_jump 	= $SFX_Jump
@onready var sfx_death 	= $SFX_Death
@onready var sfx_running= $SFX_Running

func _ready():
	GlobalData.player = self
	
	initial_position = position
	var boar = get_node("../Boar")
	var boar2 = get_node("../Boar2")
	var boar3 = get_node("../Boar3")
	var goblin = get_node("../goblin")
	var goblin2 = get_node("../goblin2")
	var goblin3 = get_node("../goblin3")
	var goblin4 = get_node("../goblin4")
	var goblin5 = get_node("../goblin5")
	var bee = get_node("../Bee")
	var bee2 = get_node("../bumper_bee/Bee2")
	var bee3 = get_node("../bumper_bee/Bee3")
	var bee4 = get_node("../bumper_bee/Bee4")
	
	boar.custom.connect(death)
	boar2.custom.connect(death)
	boar3.custom.connect(death)
	goblin.goblin.connect(death)
	goblin2.goblin.connect(death)
	goblin3.goblin.connect(death)
	goblin4.goblin.connect(death)
	goblin5.goblin.connect(death)
	bee.bee.connect(death)
	bee2.bee.connect(death)
	bee3.bee.connect(death)
	bee4.bee.connect(death)

	
func death():
	death_enemy = true
	print("death")

func _physics_process(delta):
	var current_animation = animation.get_current_animation()
	
	#if current_animation != "death": 
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
		if Input.is_action_just_pressed("ui_accept") and current_animation != "death":
			velocity.y = JUMP_VELOCITY
			animation.play("jump")
			sfx_jump.play()
			jump_count += 1
	
	if position.y > DeathThreshold or death_enemy:
		GlobalData.Death_bool = true
		
		#Sound Player Death
		sfx_death.play()
		
		#animate play Death
		animation.play("death")
		await get_tree().create_timer(0.5).timeout
		
		death_enemy = false
		
		#Respawn to CheckPoint
		GlobalData.respawn_player()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	
	if position.y < DeathThreshold:
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
			sfx_running.stop()
		if velocity.y > 0:
			animation.play("idle")
			sfx_running.stop()			
	
	move_and_slide()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		GlobalData.LIVE -= 1
		GlobalData.Death_bool = false		
		
func sfx_running_sound(): 
	sfx_running.pitch_scale = randf_range(.8, 1.2)
	sfx_running.play()
