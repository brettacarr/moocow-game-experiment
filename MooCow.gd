extends KinematicBody2D

signal hitFence

export var speed = 400
var screen_size
var velocity = Vector2()
var hasChainSaw = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

func get_input():
	# Detect up/down/left/right keystate and only move when pressed.
	
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	
	
func _physics_process(delta):
	get_input()
	
	if velocity.length() >0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	if (velocity.x != 0):
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = velocity.x > 0
	if (velocity.y != 0):
		$AnimatedSprite.animation = "stand"
	
#	position += velocity * delta
	position.x = clamp(position.x, 32, screen_size.x-32)
	position.y = clamp(position.y, 64, screen_size.y-64)

	move_and_slide(velocity)
	for i in get_slide_count():
			var collision = get_slide_collision(i)
			var collider = collision.collider as RigidBody2D
			if (collider.name == "Chainsaw"):
				hasChainSaw = true
				if collider != null:
					collider.get_parent().remove_child(collider)
			if ("Fence" in collider.name && 
				Input.is_action_just_pressed("ui_accept") && 
				hasChainSaw):
				if collider != null:
					collider.get_parent().remove_child(collider)
			
	

