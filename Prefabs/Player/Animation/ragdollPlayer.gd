extends Node2D

func RagdollVelocity(velocity) -> void:
	for rigidbodies in get_children():
		if rigidbodies is RigidBody2D:
			rigidbodies.linear_velocity = velocity * randf_range(0.5, 1)
