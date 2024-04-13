class_name Player extends CharacterBody2D
var player_health = 100
func hit_player(damage):
	print("not implimented yet, will probs add a stun or smth")
# above are intended for public use


const accel = 50
const friction = 0.925
const noInputFriction = 0.8
const responsivenessMultiplier = 3

var wishDir: Vector2 = Vector2.ZERO
var animatedSprite: AnimatedSprite2D

const animationsDir = [Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT,Vector2.UP] #lists the desired wishDir that fits the animation best
const animationNames = ["RunDown","RunLeft","RunRight","RunUp","IdleDown","IdleLeft","IdleRight","IdleUp"]
const animationStride: int = 4 #total number of directions for animations

var currentAction: int = 0 # 0 for idle, 1 for run, further actions are timedActions and their properties and implimentations are below
var prevDir: Vector2 = Vector2.UP #used for determining idle directions

#timed action system, used for attacks and possibly dashes/dodges in the future
const timedActionNumber =         [2,3]   #refers to action number
const timedActionDuration =       [0.25,1]#in secconds
const timedActionDefaultCooldown =[1,2]
const timedActionAnimationPosition =  [3,4] #represents the index * stride
var timedActionCooldown =       [0,0]
var timedActionRemainingDuration = 0

func _ready():
	Singleton.player_node = self
	animatedSprite = $AnimatedSprite2D

func _physics_process(delta):
	handleTimedActions(delta)
	handlePlayerMovement()
	handlePlayerAnimations()
	
	
func handleTimedActions(delta):
	# map inputs to action
	var debug = 0
	if debug == 1:
		print(timedActionRemainingDuration)
		print(timedActionCooldown)
		print(currentAction)
	
	if currentAction >= 2 && timedActionRemainingDuration <= 0:
		currentAction = 0 #finnish 

	var desiredAction: int = -1
	if Input.is_action_pressed("attack1"):
		desiredAction = timedActionNumber[0]
		
	if Input.is_action_pressed("attack2"):
		desiredAction = timedActionNumber[1]
	
	#decrease cooldowns
	for i in range(timedActionCooldown.size()): #WHAT THE HELL IS THIS SHIT, THIS IS NOT THE FOR LOOP I KNOW AND LOVE
		if timedActionCooldown[i] > 0:          #I CANT BELIEVE IM SAYING THIS BUT I ACTUALLY MISS JAVA
			timedActionCooldown[i]-=delta       #TAKE ME HOME COUNTR TORAAAD TO HE PLACE WHWER BLENONNGGG WEST VERTINGA
	
	if timedActionRemainingDuration >= 0:
		timedActionRemainingDuration -= delta
		return
	
	if timedActionCooldown[timedActionNumber.find(desiredAction)] <= 0:
		#perform action
		if desiredAction == -1:
			return
		var index = timedActionNumber.find(desiredAction)
		currentAction = desiredAction
		timedActionCooldown[index] = timedActionDefaultCooldown[index]
		timedActionRemainingDuration = timedActionDuration[index]
	
		



func handlePlayerAnimations():
	if currentAction == 1 || currentAction == 0:
		if wishDir.length() == 0:
			currentAction = 0
		else:
			currentAction = 1
	
	#THERE IS NO SWITCH STATEMENT IN THIS GOD AWFUL LANGUAGE>?>???? LORD HAVE MERCY GET ME OUT
	#nevermind theres match, match deez??? deee
	match currentAction:
		0:
			animatedSprite.animation = animationNames[animationsDir.find(prevDir) + animationStride]
		1:
			var bestFit: Vector2 = Vector2.ZERO
			for dir in animationsDir:
				if dir.dot(wishDir) > bestFit.dot(wishDir):
					bestFit = dir
			animatedSprite.animation = animationNames[animationsDir.find(bestFit)]
			prevDir = bestFit
		2:
			animatedSprite.animation = "Placeholder"
		3:
			animatedSprite.animation = "Placeholder"

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
	
