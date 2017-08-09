--Config crit chance PS: Values are in % of skill level and using a range 0 to 1
	local critChance = {
		Sword	= 0.75,
		Axe		= 0.6,
		Club	= 0.5,
		Dist	= 0.75,
		Magic	= 0.75
	}

	--Config crit damage by weapon type
	
	local critDmg = {
		Sword	= 0.3,
		Axe		= 0.3,
		Club	= 0.3,
		Dist	= 0.3,
		Magic	= 0.5
	}

function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	--If its a field or damage over time
	if Tile(creature:getPosition()):hasFlag(TILESTATE_MAGICFIELD) == TRUE or attacker == nil then
		return primaryDamage, primaryType, secondaryDamage, secondaryType	
	end

	--If its not a player or monster attacking
	if not attacker:isPlayer() and not attacker:isMonster() then
		return primaryDamage, primaryType, secondaryDamage, secondaryType		
	end

	local pDam, pCap = 0, 0
	local dodge = false
	
	--Calculate Crit chance of monsters
    if attacker:isMonster() and not creature:isMonster() then		
		if attacker:getSpeed() * 0.08 > math.random(100) then
			pDam = primaryDamage * 0.5
		end		
    end

	--Calculate DODGE chance of monsters
	if creature:isMonster() and attacker:isPlayer() and primaryType ~= COMBAT_HEALING then
		if creature:getSpeed() * 0.08 > math.random(100) then
			dodge = true
			creature:say("DODGE".. pDam, TALKTYPE_MONSTER_SAY)
		end
	end

	--Calculate CRIT chance of players
    if attacker:isPlayer() then 
		--The chance of critical is based on the weapon type, the same for crit damage
		if attacker:getWeaponType() == WEAPON_SWORD and math.random(100) <= attacker:getSkillLevel(SKILL_SWORD) * critChance.Sword then
			pDam = ((attacker:getSkillLevel(SKILL_SWORD) * critDmg.Sword)		/ 100) * primaryDamage		
		elseif attacker:getWeaponType() == WEAPON_AXE and math.random(100) <= attacker:getSkillLevel(SKILL_AXE) * critChance.Axe then
			pDam = ((attacker:getSkillLevel(SKILL_AXE) * critDmg.Axe)			/ 100) * primaryDamage		
		elseif attacker:getWeaponType() == WEAPON_CLUB and math.random(100) <= attacker:getSkillLevel(SKILL_CLUB) * critChance.Club then
			pDam = ((attacker:getSkillLevel(SKILL_CLUB) * critDmg.Club)			/ 100) * primaryDamage		
		elseif attacker:getWeaponType() == WEAPON_DISTANCE and math.random(100) <= attacker:getSkillLevel(SKILL_DISTANCE) * critChance.Dist then
			pDam = ((attacker:getSkillLevel(SKILL_DISTANCE) * critDmg.Dist)		/ 100) * primaryDamage		
		elseif attacker:getWeaponType() == WEAPON_WAND and math.random(100) <= attacker:getMagicLevel(SKILL_MAGLEVEL) * critChance.Magic then
			pDam = ((attacker:getMagicLevel(SKILL_MAGLEVEL) * critDmg.Magic)	/ 100) * primaryDamage
		end
    end

	--Calculate DODGE chance of players
	if creature:isPlayer() and primaryType ~= COMBAT_HEALING then
		--Get's the free % of the capacity
		pCap = getPlayerFreeCap(creature) / (creature:getCapacity() / 100)

		--The calculation is based on speed and % of free capacity (cap)
		if ((creature:getSpeed() / 2) * 0.05) * (pCap * 1.5/1) > math.random(100)  then			
			dodge = true
			creature:say("DODGE", TALKTYPE_MONSTER_SAY)
		end
	end

	--If its a Critical show message
	if pDam ~= 0 then
		if origin == ORIGIN_RANGED then
			creature:say("HEADSHOT!", TALKTYPE_MONSTER_SAY)
			creature:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)        
        elseif origin == ORIGIN_MELEE then
            attacker:say("CRITICAL!", TALKTYPE_MONSTER_SAY)
			creature:getPosition():sendMagicEffect(CONST_ME_HITAREA)
		elseif origin == ORIGIN_SPELL then
			if primaryType == 2 then
					attacker:say("ELECTROCUTE!", TALKTYPE_MONSTER_SAY)
				elseif primaryType == 512 then
					attacker:say("FREEZE!", TALKTYPE_MONSTER_SAY)
				elseif primaryType == 8 then
					attacker:say("BURN!", TALKTYPE_MONSTER_SAY)
				elseif primaryType == 2048 then
					attacker:say("EMBRACE!", TALKTYPE_MONSTER_SAY)
				elseif primaryType == 1024 then
					attacker:say("PURIFY!", TALKTYPE_MONSTER_SAY)
				elseif primaryType == 128 then
					attacker:say("REVIVE!", TALKTYPE_MONSTER_SAY)
				elseif primaryType == 1 then
					attacker:say("CRITICAL!", TALKTYPE_MONSTER_SAY)
				elseif primaryType == 4 then
					attacker:say("THORN!", TALKTYPE_MONSTER_SAY)
			end
        end
	end

	--If dodged
	if dodge then
		return primaryDamage - primaryDamage, primaryType, secondaryDamage - secondaryDamage, secondaryType
	else
		--If critted
		if pDam ~= 0 then
			if attacker:isPlayer() then
				attacker:sendTextMessage((MESSAGE_DAMAGE_DEALT), "Critical Hit: +".. pDam .." DMG")
				return primaryDamage + pDam, primaryType, secondaryDamage, secondaryType
			else
				attacker:say("Crit: ".. pDam, TALKTYPE_MONSTER_SAY)
				return primaryDamage + pDam, primaryType, secondaryDamage, secondaryType
			end
		end
		
		--Normal damage
		return primaryDamage, primaryType, secondaryDamage, secondaryType		
	end
	
end

--[[
VIS 	2
FRIGO 	512
FLAM 	8
MORT 	2048
HOLY 	1024
HEAL	128
PHYS	1
TERA	4
]]--

--print(getPlayerFreeCap(attacker)) 
--print(attacker:getCapacity())		


