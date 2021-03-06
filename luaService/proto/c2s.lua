
return [[

.package {
	type 0 : integer
	session 1 : integer
}

.LoginRoleInfo{
	player_id 		0 : integer
	player_name 	1 : string
	level 			2 : integer
	job				3 : integer
}

login_get_rolelist 1 {
	response {
		rolelist 0 : *LoginRoleInfo
	}
}

login_load_playerinfo 2 {
	request {
		player_id  0 : integer
	}
	response {
		result 	   0 : integer
	}
}

login_create_role 3 {
	request {
		player_name 0 : string
		job			1 : integer
	}
	response {
		result 0 : integer
	}
}

login_get_player_info 4 {
	response {
		player_name 0 : string
		vip 		1 : integer
		diamond 	2 : integer
		paydiamond 	3 : integer
		binddiamond 4 : integer
		gold 		5 : integer
		silver 		6 : integer
		power		7 : integer
		scene_id	8 : integer
		pos_y		9 : integer
		pos_x 		10 : integer
		createtime	11 : integer
		
	}
}

athletic_change 5 {
	request {
		dst_id   0 : integer
		dst_rank 1 : integer 
	}
	response {
		win_id  0 : integer
	}	
}

.AthleticRankData{
	id 		0 : integer
	name 	1 : string
	rank 	2 : integer
}

athletic_get_rank 6 {
	request {
		rankmin 0 : integer
		rankmax 1 : integer
	}
	response {
		rankdata 0 : *AthleticRankData
	}
}

scene_enter 7 {
	request {
		scene_id 0 : integer
		x 		 1 : integer
		y 		 2 : integer
	}
}

heartbeat 8 {}

say 9 {
  request {
   name 0 : string
   msg 1 : string
  }
  response {
    name 0 : string
    msg 1 : string
  }
}

handshake 10 {
  
}

.Position{
  id 0 : integer
  x  1 : integer
  y  2 : integer  
}

.RoleState{
  state 0 : integer
  facex 1 : integer
  facey 2 : integer
}

player_position 11 {
  request {
    frame 0 : integer
    pos   1 : Position
    state 2 : RoleState
  }
  response {
    otherPos 0 : *Position
    otherState 1 : *RoleState
  }
}

player_join 12 {
	request {
		id 0 : integer
    name 1 : string
	}
	response {
		
	}
}

monster_position 13 {
  request {
    frame 0 : integer
    pos   1 : Position
    type  2 : integer
  }
  response {
    otherPos 0 : *Position
  }
}

player_movement 14 {
  request {
    id 0 : integer
    hor 1 : string
    ver 2 : string
  }  
}

player_rotation 15 {
  request {
    id 0 : integer
    x 1 : string
    z 2 : string
  }  
}

]]