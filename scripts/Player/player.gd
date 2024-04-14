class_name Player extends CharacterBody2D
var player_health = 100
func hit_player(damage):
	print("player hit")
	currentAction = 4 #stun action
	var index = timedActionNumber.find(currentAction)
	timedActionCooldown[index] = timedActionDefaultCooldown[index]
	timedActionRemainingDuration = timedActionDuration[index]
	
	player_health -= damage

var resetting:bool = false

func reset(): #reset with animation
	resetting = true
	velocity = Vector2.ZERO
	animatedSprite.modulate = Color(1,1,1,0.5)
	initialResetSize = posOverTime.size()
func quick_reset(): #no animation
	var h = healthOverTime.pop_front()
	var p = posOverTime.pop_front()
	healthOverTime.clear()
	posOverTime.clear()
	healthOverTime.append(h)
	posOverTime.append(p)
	
	player_health = h
	position = p
	resetting = false
	velocity = Vector2.ZERO
	animatedSprite.modulate = Color(1,1,1,1)

# above are intended for public use ==========================================================
var healthOverTime:Array = []
var posOverTime: Array = []

var particles: CPUParticles2D

const accel = 40
const friction = 0.925
const noInputFriction = 0.8
const responsivenessMultiplier = 3

var wishDir: Vector2 = Vector2.ZERO
var animatedSprite: AnimatedSprite2D

const animationsDir = [Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT,Vector2.UP] #lists the desired wishDir that fits the animation best
const animationNames = ["RunDown","RunLeft","RunRight","RunUp","IdleDown","IdleLeft","IdleRight","IdleUp","AttackDown","AttackLeft","AttackRight","AttackUp"]
const animationStride: int = 4 #total number of directions for animations

var currentAction: int = 0 # 0 for idle, 1 for run, further actions are timedActions and their properties and implimentations are below
var prevDir: Vector2 = Vector2.UP #used for determining idle directions

#timed action system, used for attacks and possibly dashes/dodges in the future
const timedActionNumber =         [2,3,4]   #refers to action number
const timedActionDuration =       [0.25,0.125,0.25]#in secconds
const timedActionDefaultCooldown =[1,2,0]
const timedActionAnimationPosition =  [3,4,5] #represents the index * stride
var timedActionCooldown =       [0,0,0]
var timedActionRemainingDuration = 0

const dashMaintain = 100
const dashImpulse = 1500

const resetTimeScale = 0.5 #negetive time scale in godot is weird, so i have avoided using it after testing
const ResetDurationDesired = 2.0 #the amount of time the reset should take
var initialResetSize = 0

var weaponHitbox: player_hitbox
const weaponDamage = 30
var weaponParticles1: CPUParticles2D

func _ready():
	Singleton.player_node = self
	animatedSprite = $AnimatedSprite2D
	particles = $CPUParticles2D
	posOverTime.append(position)
	healthOverTime.append(player_health)
	weaponHitbox = get_child(3) #get weapon hitbox, idk $ would not work i hate this
	weaponParticles1 = $"AnimatedSprite2D/particle affects/WeaponParticles1"


func _physics_process(delta):
	if resetting:
		Engine.time_scale = resetTimeScale
		handleResetting()
		return
	handleTimedActions(delta)
	handlePlayerMovement()
	handlePlayerAnimations()
	
	if Input.is_action_pressed("SECRET_TEST_BUTTON_SHHH_TELL_NOBODY"):
		hit_player(10)
	if player_health <= 0:
		player_health = 0
		reset()
	
	if Engine.time_scale != 1:
		Engine.time_scale = 1
	
	posOverTime.append(position)
	healthOverTime.append(player_health)
	
func handleResetting():
	if posOverTime.size() < 1:
		resetting = false
		animatedSprite.modulate = Color(1,1,1,1)
		Singleton.reset()
		return
	
	var pos
	var hlth
	var numFramesToSkip = ((initialResetSize /60)/ResetDurationDesired)
	
	while numFramesToSkip > 0 && posOverTime.size() > 2: #skip frames 
		pos = posOverTime.pop_back()
		hlth = healthOverTime.pop_back()
		numFramesToSkip-=1
	
	pos = posOverTime.pop_back()
	hlth = healthOverTime.pop_back()
	
	player_health = hlth
	position = pos

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
		
	if Input.is_action_pressed("special"):
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
	else :
		return
		
	match currentAction:
		3:
			velocity = wishDir*dashImpulse
		2: 
			weaponParticles1.emitting = true


func handlePlayerAnimations():
	if currentAction == 1 || currentAction == 0:
		if wishDir.length() == 0:
			currentAction = 0
		else:
			currentAction = 1
	#THERE IS NO SWITCH STATEMENT IN THIS GOD AWFUL LANGUAGE>?>???? LORD HAVE MERCY GET ME OUT
	#nevermind theres match, match deez??? deee
	animatedSprite.modulate = Color.WHITE
	match currentAction:
		0:
			animatedSprite.animation = animationNames[animationsDir.find(prevDir) + (animationStride * 1)] 
		1:
			var bestFit: Vector2 = Vector2.ZERO
			for dir in animationsDir:
				if dir.dot(wishDir) > bestFit.dot(wishDir):
					bestFit = dir
			animatedSprite.animation = animationNames[animationsDir.find(bestFit)]
			prevDir = bestFit
		2:
			weaponHitbox.updateRot(prevDir)
			weaponHitbox.tickHitbox(weaponDamage)
			
			animatedSprite.animation = animationNames[animationsDir.find(prevDir) + (animationStride * 2)] 
			animatedSprite.play( animationNames[animationsDir.find(prevDir) + (animationStride * 2)] )
			
		3:
			if wishDir != Vector2.ZERO:
				velocity += wishDir * dashMaintain
		4:
			animatedSprite.modulate = Color.RED # damage

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
	
