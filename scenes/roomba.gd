extends CharacterBody3D
var last
var speed=5.0
var state=1
#0=off
#1=searching
#2=moving
#3=cleaning
var angle = rotation
var collide:Object
var margin = Vector3.ONE*1.5

func _physics_process(delta: float) -> void:
	#print(global_position)
	position.y=0.6
	rotation.y = lerp_angle(rotation.y, angle.y, 0.1)
	if state==2:
		global_position=lerp(global_position,collide.global_position,0.01)
		if global_position.distance_to(collide.global_position) < 1.5:
			state = 1
	pass


func _on_timer_timeout() -> void:
	angle.y = wrap(angle.y, 0.0, TAU)
	if state==1:
		angle.y+=1/(2*PI)
		collide=$RayCast3D.get_collider()
		if collide==last:
			collide=null
		#print(collide)
		if collide:
			if collide.get_parent().name=='Player':
				pass
			else:
				state = 2
			angle.y=rotation.y
			last=collide
			#collide=collide.get_parent()
		else:state=1
		pass
	pass # Replace with function body.
