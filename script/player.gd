extends CharacterBody2D

enum STATES {AIR = 1, FLOOR = 2, LADDER, WALL } # cada valor constante em um enum é associado a um situação do jogador
const SPEED = 220.0
const RUNSPEED = 400.0
const JUMP_VELOCITY = -300.0


var playerState = STATES.AIR # inicia o jogo com o situação do player AIR ou estar no ar/voando/pulando
var playerOnButton = false # troca para TRUE se o jogador se aproximar do botão
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation := $sprite as AnimatedSprite2D # variavel para manipular a sprite do player

func _physics_process(delta):
	match playerState: # swith que usa o situação atual do player
		STATES.AIR: # caso ele esteja no ar
			print(velocity.y)
			print(playerState)
			if is_on_floor(): # se ele encostar no chão
				playerState = STATES.FLOOR # muda a situação para FLOOR
			animation.play("air") # muda a sprite para pulando
			if Input.is_action_pressed("ui_right"): # se precionar seta direita 
				if Input.is_action_pressed("ui_up"): # se estiver segurando o botão de corre
					velocity.x = lerp(velocity.x,RUNSPEED,0.1) # vai para direita com a velocidade de corrida
				else:
					velocity.x = lerp(velocity.x,SPEED,0.1) # vai para direita com a velocidade normal
				animation.flip_h = false # inverte a sprite
			elif Input.is_action_pressed("ui_left"): # a mesma coisa mas para esquerda
				if Input.is_action_pressed("ui_up"):
					velocity.x = lerp(velocity.x,-RUNSPEED,0.1)
				else:
					velocity.x = lerp(velocity.x,-SPEED,0.1)
				animation.flip_h = true # inverte a sprite
			velocity.y += gravity * delta # adiciona gravidade ao player
			move_and_slide() # atualiza o player

		STATES.FLOOR: # caso ele esteja no chão
			print(velocity.x)
			print(playerState)
			if Input.is_action_pressed("ui_right"): # se precionar seta direita
				if Input.is_action_pressed("ui_up"): # se estiver segurando o botão de corre
					velocity.x = lerp(velocity.x,RUNSPEED,0.1) # vai para direita com a velocidade de corrida
				else:
					velocity.x = lerp(velocity.x,SPEED,0.1) # vai para direita com a velocidade normal
				animation.play("walk") # muda a sprite para andando
				animation.flip_h = false # inverte a sprite
			elif Input.is_action_pressed("ui_left"): # a mesma coisa mas para esquerda 
				if Input.is_action_pressed("ui_up"):
					velocity.x = lerp(velocity.x,-RUNSPEED,0.1)
				else:
					velocity.x = lerp(velocity.x,-SPEED,0.1)
				animation.play("walk")
				animation.flip_h = true # inverte a sprite
			else: # se o player estiver parado
				velocity.x = move_toward(velocity.x, 0, SPEED) # a velocidade volta para 0
				animation.play("idle") # muda a sprite para parado
				
			if Input.is_action_pressed("ui_accept"): # se o player aperta espaço
				velocity.y = JUMP_VELOCITY # pula
				playerState = STATES.AIR # e muda a situação para AIR, pulando
			move_and_slide() # atualiza o player
			
	print(playerOnButton)

func _on_area_2d_area_entered(area): # se o player se aproximar do botão
	playerOnButton = true # a variavel se torna verdadeira
	
func _on_area_2d_area_exited(area): # se o player sai de perto do botão
	playerOnButton = false # a variavel se torna falsa
