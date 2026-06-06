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
	rotation=lerp(rotation,angle,0.1)
	if state==2:
		global_position=lerp(global_position,collide.position,0.01)
		if abs(global_position-collide.position)<margin:
			state = 1
	pass


func _on_timer_timeout() -> void:
	if state==1:
		angle.y+=1/(2*PI)
		collide=$RayCast3D.get_collider()
		if collide==last:
			collide=null
		#print(collide)
		if collide:
			state = 2
			last=collide
			collide=collide.get_parent()
		else:state=1
		pass
	pass # Replace with function body.
