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

@onready var animation = get_node("AnimationPlayer")
@onready var sfx_jump = $SFX_Jump
@onready var sfx_death = $SFX_Death
@onready var sfx_running = $SFX_Running

func _ready():
	GlobalData.player = self
	
	var namex = get_tree().current_scene.get_name()
	initial_position = position
	if namex == "map-1":
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
	elif namex == "map-2":
		var boar21 = get_node("../Boar1")
		var boar22 = get_node("../Boar2")
		boar21.custom.connect(death)
		boar22.custom.connect(death)
		var bee20 = get_node("../Bee")
		var bee21 = get_node("../Bee2")
		var bee22 = get_node("../Bee3")
		var bee23 = get_node("../Bee4")
		var bee24 = get_node("../Bee5")
		var bee25 = get_node("../Bee6")
		bee20.bee.connect(death)
		bee21.bee.connect(death)
		bee22.bee.connect(death)
		bee23.bee.connect(death)
		bee24.bee.connect(death)
		bee25.bee.connect(death)
		var goblin20 = get_node("../goblin")
		var goblin21 = get_node("../goblin2")
		goblin20.goblin.connect(death)
		goblin21.goblin.connect(death)
	elif namex == "map-3":
		var bear = get_node("../bear")
		var snake = get_node("../Snake")
		var slime = get_node("../slime")
		var slime2 = get_node("../slime2")
		var goblin22 = get_node("../goblin")
		var goblin23 = get_node("../goblin2")
		var bear2 = get_node("../bear2")
		var snail = get_node("../snail")
		var snail2 = get_node("../snail2")
		
		bear.bear.connect(death)
		snake.snake.connect(death)
		slime.slime.connect(death)
		slime2.slime.connect(death)
		goblin22.goblin.connect(death)
		goblin23.goblin.connect(death)
		bear2.bear.connect(death)
		snail.snail.connect(death)
		snail2.snail.connect(death)
		
	elif namex == "map-4":
		var snake3 = get_node("../Snake")
		var snake4 = get_node("../Snake2")
		var snake5 = get_node("../Snake3")
		var snake6 = get_node("../Snake4")
		var goblin24 = get_node("../goblin")
		var goblin25 =get_node("../goblin2")
		
		snake3.snake.connect(death)
		snake4.snake.connect(death)
		snake5.snake.connect(death)
		snake6.snake.connect(death)
		goblin24.goblin.connect(death)
		goblin25.goblin.connect(death)
		
	elif namex == "map-5":
		pass
		

func death():
	death_enemy = true
	#print("death")

func _physics_process(delta):
	var current_animation = animation.get_current_animation()
	#print("X: ", position.x)
	#print("Y: ", position.y)
	#if current_animation != "death": 
	if Input.is_action_pressed("ui_cancel"):
		SceneLoading.load_scene("res://main-menu/main_menu.tscn")
	
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
			
	var namee = get_tree().current_scene.get_name()
	
	if namee == "map-1":
		if position.x > 11300 and position.y > 330:
			SceneLoading.load_scene("res://map-2/map-2.tscn")
	elif namee == "map-2":
		if position.x > 8861 and position.y > 650:
			SceneLoading.load_scene("res://map-3/map_3.tscn")
	elif namee == "map-3":
		if position.x > 6800 and position.y < -990:
			SceneLoading.load_scene("res://map-4/map-4.tscn")
	elif namee == "Map-4":
		if position.x > 11490 and position.y > 329:
			SceneLoading.load_scene("res://map-5/map-5.tscn")
	elif namee == "Map-5":
		if position.x > 453 and position.y < 540:
			SceneLoading.load_scene("res://wingame/wingame.tscn")
		
	if GlobalData.LIVE < 1:
		GlobalData.LIVE = 9
		SceneLoading.load_scene("res://gameover/gameover.tscn")
	
	move_and_slide()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		GlobalData.Death_bool = false
		GlobalData.LIVE -= 1
		GlobalData.respawn_player()
		
func sfx_running_sound(): 
	sfx_running.pitch_scale = randf_range(.8, 1.2)
	sfx_running.play()
