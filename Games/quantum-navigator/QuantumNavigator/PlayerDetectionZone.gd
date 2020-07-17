extends Area2D

var player = null
var players = []

func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	player = body
	players.append(body)

func _on_PlayerDetectionZone_body_exited(_body):
	players.erase(_body)
	if players.size() == 0:
		player = null
	else:
		player = players[0]
