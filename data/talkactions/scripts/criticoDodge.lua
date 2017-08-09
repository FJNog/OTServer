function onSay(player, words, param)

	local chanceCritico
	local danoCritico
	local tipoArma
	local chanceDodge
	local pCap
	local critChance = {
		Sword	= 0.75,
		Axe		= 0.6,
		Club	= 0.5,
		Dist	= 0.75,
		Magic	= 0.75
	}

	local critDmg = {
		Sword	= 0.3,
		Axe		= 0.3,
		Club	= 0.3,
		Dist	= 0.3,
		Magic	= 0.5
	}
		
		pCap = getPlayerFreeCap(player) / (player:getCapacity() / 100)
		chanceDodge = ((player:getSpeed() / 2) * 0.05) * (pCap * 1.5/1)
		if player:getWeaponType() == WEAPON_SWORD then
			tipoArma = 'Swords'
			chanceCritico =	player:getSkillLevel(SKILL_SWORD) * critChance.Sword
			danoCritico = (player:getSkillLevel(SKILL_SWORD) * critDmg.Sword)	
		elseif player:getWeaponType() == WEAPON_AXE then
			tipoArma = 'Axes'
			chanceCritico =	player:getSkillLevel(SKILL_AXE) * critChance.Axe
			danoCritico = (player:getSkillLevel(SKILL_AXE) * critDmg.Axe) 
		elseif player:getWeaponType() == WEAPON_CLUB then
			tipoArma = 'Clubs'
			chanceCritico =	player:getSkillLevel(SKILL_CLUB) * critChance.Club
			danoCritico = (player:getSkillLevel(SKILL_CLUB) * critDmg.Club)		
		elseif player:getWeaponType() == WEAPON_DISTANCE then
			tipoArma = 'Distance'
			chanceCritico =	player:getSkillLevel(SKILL_DISTANCE) * critChance.Dist
			danoCritico = (player:getSkillLevel(SKILL_DISTANCE) * critDmg.Dist)	
		elseif player:getWeaponType() == WEAPON_WAND then
			tipoArma = 'Magias'
			chanceCritico =	player:getMagicLevel(SKILL_MAGLEVEL) * critChance.Magic
			danoCritico = (player:getMagicLevel(SKILL_MAGLEVEL) * critDmg.Magic)	
		else
			tipoArma = 'Nehuma arma esquipada'
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'Você tem '.. chanceDodge ..'% de desviar de ataques')
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'Você tem 0% de critico! '.. tipoArma)
		return true
		end

		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'Você tem '.. chanceDodge ..'% de desviar de ataques')
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'Você tem '.. chanceCritico ..'% de chance de critico e '.. danoCritico ..'% de dano extra com '.. tipoArma)
		return true
end