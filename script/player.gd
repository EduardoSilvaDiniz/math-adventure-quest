extends CharacterBody2D

enum STATES {AIR = 1, FLOOR, LADDER, WALL} # cada valor constante em um enum é associado a um situação do jogador
const SPEED = 220.0
const RUNSPEED = 400.0
const JUMP_VELOCITY = -400.0

var playerState = STATES.AIR # inicia o jogo com o situação do player AIR ou estar no ar/voando/pulando
var playerOnButton = false # troca para TRUE se o jogador se aproximar do botão
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1
@onready var animation := $sprite as AnimatedSprite2D # variavel para manipular a sprite do player
@onready var wallchacker := $wallchecker as RayCast2D
@onready var jump := $jump as AudioStreamPlayer2D
@onready var dead := $dead as AudioStreamPlayer2D
var button_wall = false #confere se o botão da parede está sendo tocado
var portal = false #confere se o portal está sendo tocado
var teleporta = true #para não ficar teleportando toda hora

func _physics_process(delta):
	
	match playerState: # swith que usa o situação atual do player
		STATES.AIR: # caso ele esteja no ar
			animation.play("air") # muda a sprite para pulando
			if is_on_floor(): # se ele encostar no chão
				playerState = STATES.FLOOR # muda a situação para FLOOR
			elif is_near_wall():
				playerState = STATES.WALL
			if Input.is_action_pressed("ui_right"): # se precionar seta direita 
				if Input.is_action_pressed("run"): # se estiver segurando o botão de corre
					velocity.x = lerp(velocity.x,RUNSPEED,0.1) # vai para direita com a velocidade de corrida
				else:
					velocity.x = lerp(velocity.x,SPEED,0.1) # vai para direita com a velocidade normal
				animation.flip_h = false # inverte a sprite
			elif Input.is_action_pressed("ui_left"): # a mesma coisa mas para esquerda
				if Input.is_action_pressed("run"):
					velocity.x = lerp(velocity.x,-RUNSPEED,0.1)
				else:
					velocity.x = lerp(velocity.x,-SPEED,0.1)
				animation.flip_h = true # inverte a sprite
			move_and_fall(delta, false) # atualiza o player
			set_direction()

		STATES.FLOOR: # caso ele esteja no chão
			if Input.is_action_pressed("ui_right"): # se precionar seta direita
				if Input.is_action_pressed("run"): # se estiver segurando o botão de corre (z)
					velocity.x = lerp(velocity.x,RUNSPEED,0.1) # vai para direita com a velocidade de corrida
				else:
					velocity.x = lerp(velocity.x,SPEED,0.1) # vai para direita com a velocidade normal
				animation.play("walk") # muda a sprite para andando
				animation.flip_h = false # inverte a sprite
			elif Input.is_action_pressed("ui_left"): # a mesma coisa mas para esquerda 
				if Input.is_action_pressed("run"):
					velocity.x = lerp(velocity.x,-RUNSPEED,0.1)
				else:
					velocity.x = lerp(velocity.x,-SPEED,0.1)
				animation.play("walk")
				animation.flip_h = true # inverte a sprite
			else: # se o player estiver parado
				velocity.x = move_toward(velocity.x, 0, SPEED) # a velocidade volta para 0
				animation.play("idle") # muda a sprite para parado
				
			if Input.is_action_pressed("jump"): # se o player aperta espaço
				jump.play()
				velocity.y = JUMP_VELOCITY # pula
				playerState = STATES.AIR # e muda a situação para AIR, pulando
			if not is_on_floor():
				playerState = STATES.AIR
			move_and_fall(delta, false) # atualiza o player
			set_direction()
			apply_push_force()
			
		STATES.WALL:
			if is_on_floor():
				playerState = STATES.FLOOR
			elif not is_near_wall():
				playerState = STATES.AIR
			if Input.is_action_pressed("jump") and ((Input.is_action_pressed("ui_left") and direction == 1) or (Input.is_action_pressed("ui_right") and direction == -1)):
				jump.play()
				velocity.x = 450 * -direction
				velocity.y = JUMP_VELOCITY * 0.7
			move_and_fall(delta, true) # atualiza o player
	
	if button_wall and Input.is_key_pressed(KEY_E):
		button_wall = false #desligar para não clicar várias vezes o botão
		get_tree().call_group("wall_button", "fufando")
	if portal and Input.is_key_pressed(KEY_E) and teleporta:
		teleporta = false
		get_tree().call_group("portal", "teleporta")
		get_node("Timer").start(0.5)

func apply_push_force():
	for obj in get_slide_collision_count():
		var colli = get_slide_collision(obj)
		if colli.get_collider() is box:
			colli.get_collider().slide_obj(-colli.get_normal())

func move_and_fall(delta, slow_fall : bool):
	if slow_fall:
		velocity.y = clamp(velocity.y,JUMP_VELOCITY, 200)
	velocity.y += gravity * delta
	move_and_slide()

func set_direction():
	direction = 1 if not animation.flip_h else -1
	wallchacker.rotation_degrees = 90 * -direction

func is_near_wall():
	return wallchacker.is_colliding()

func _on_area_2d_area_entered(area):
	if area.is_in_group("portal"):
		portal = true
	elif area.is_in_group("wall_button"):
		button_wall = true
	elif area.is_in_group("checkpoint1"):
		Global.checkpoint = Vector2(78, 573)
	elif area.is_in_group("checkpoint2"):
		Global.checkpoint = Vector2(1282, 631)
	elif area.is_in_group("thorn"):
		position = Global.checkpoint
	Global.obj = area

func _on_area_2d_area_exited(area):
	if area.is_in_group("portal"):
		portal = false
	if area.is_in_group("wall_button"):
		button_wall = false
	Global.obj = area

func _on_timer_timeout():
	teleporta = true
