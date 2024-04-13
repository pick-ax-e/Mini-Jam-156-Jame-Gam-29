class_name Player extends CharacterBody2D

const accel = 50
const friction = 0.925
const noInputFriction = 0.8
const responsivenessMultiplier = 3

var wishDir: Vector2 = Vector2.ZERO
var animatedSprite: AnimatedSprite2D

var animationsDir = [Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT,Vector2.UP] #lists the desired wishDir that fits the animation best
var animationNames = ["RunDown","RunLeft","RunRight","RunUp","IdleDown","IdleLeft","IdleRight","IdleUp"]
var animationStride: int = 4 #total number of directions for animations
var currentAction: int = 0 # 0 for idle, 1 for run, further actions are timedActions and their properties and implimentations are below
var prevDir: Vector2 = Vector2.UP

#timed action system, used for attacks and possibly dashes/dodges in the future
var timedActionNumber =         [2,3]   #refers to action number
var timedActionDuration =       [0.25,1]#in secconds
var timedActionDefaultCooldown =[0.25,2]
var timedActionCooldown =       [0,0]

func _ready():
	Singleton.player_node = self
	animatedSprite = $AnimatedSprite2D

func _physics_process(delta):
	handleTimedActions()
	handlePlayerMovement()
	handlePlayerAnimations()
	
	
func handleTimedActions():
	#first map inputs to action
	var desiredAction: int = -1
	if Input.action_press("attack1"):
		desiredAction = timedActionNumber[0]
	if Input.action_press("attack2")
		desiredAction = timedActionNumber[1]
	
		



func handlePlayerAnimations():
	if currentAction != 2:
		if wishDir.length() == 0:
			currentAction = 0
		else:
			currentAction = 1
	
	#THERE IS NO SWITCH STATEMENT IN THIS GOD AWFUL LANGUAGE>?>???? LORD HAVE MERCY GET ME OUT
	
	
	if currentAction == 0:
		animatedSprite.animation = animationNames[animationsDir.find(prevDir) + animationStride]
	elif currentAction == 1:
	#find the correct animation to use FOR RUNNING
		var bestFit: Vector2 = Vector2.ZERO
		for dir in animationsDir:
			if dir.dot(wishDir) > bestFit.dot(wishDir):
				bestFit = dir
	
		animatedSprite.animation = animationNames[animationsDir.find(bestFit)]
		prevDir = bestFit
	
	

#func handlePlayerAttacks():
	

func handlePlayerMovement():
	wishDir.x = Input.get_axis("move_left","move_right")
	wishDir.y = Input.get_axis("move_forward","move_back")
	wishDir = wishDir.normalized()
	
	#if nothing pressed apply no input friction
	if wishDir.length() == 0:
		velocity *= noInputFriction
	else:
		#calculate multiplier to make things more responsive in opisite directions
		var multi = (wishDir * -1).dot( velocity.normalized() ) + 1.0
		multi = (multi * responsivenessMultiplier) + 1
		velocity += wishDir * accel * multi
		
	velocity *= friction
	move_and_slide()
	
