extends CharacterBody2D


const SPEED = 220.0
const JUMP_VELOCITY = -300.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isJumping := false
@onready var animation := $sprite as AnimatedSprite2D

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		isJumping = true
	elif is_on_floor():
		isJumping = false
		
	if direction != 0:
		velocity.x = direction * SPEED
		animation.scale.x = (direction+direction) # flip sprint
		if !isJumping:
			animation.play("run")
			
	elif isJumping:
		animation.play("jump")
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle") # stop, sprint back for idle

	move_and_slide()

func _on_area_2d_area_entered(area):
	$Label.text = "o cu apertou, já pode peidar"
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		print("apertou o cu")

func _on_area_2d_area_exited(area):
	$Label.text = ""
