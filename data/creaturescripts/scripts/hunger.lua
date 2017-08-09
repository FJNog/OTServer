function onLogin(player)
   if player:hungerIgnorePlayer() then
     return true
   end
 
   local value = player:hungerGetFeedStorage()
   if value > 0 then
     player:feed(value)
   elseif value == hungerConfig.FIRST_LOGIN then
     player:feed(hungerConfig.newPlayerFeed)
   end
 
   player:hungerSetFeedStorage(0)
   player:setStorageValue(hungerConfig.storageDmgAndCheckTicks, 0)
 
   player:registerEvent("HungerDeath")
   player:registerEvent("Hunger")
 
   player:hungerSetStage()
   local msg = player:hungerGetStageMsg()
   player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, msg)
   return true
end
 
function onThink(player, interval)
 
   local counter = (player:getStorageValue(hungerConfig.storageDmgAndCheckTicks) +1) % hungerConfig.dmgAndCheckTicks
   if counter == 0 then
     -- status changed ? send msg : do nothing
     local stage = player:hungerGetStage()
     player:hungerSetStage()
     local newStage = player:hungerGetStage()
 
     if stage ~= newStage then
       local msg = player:hungerGetStageMsg()
       player:sendTextMessage(MESSAGE_STATUS_DEFAULT, msg)
     end
 
     if player:hungerGetFeed() == 0 then
       player:hungerDoDmg()
     end
   end
 
   player:setStorageValue(hungerConfig.storageDmgAndCheckTicks, counter)
   return true
end
 
function onDeath(player, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
   local feedLvl = player:hungerGetFeed()
   if feedLvl < hungerConfig.newPlayerFeed then
     player:hungerSetFeedStorage(hungerConfig.newPlayerFeed)
   else
     player:hungerSetFeedStorage(feedLvl)
   end
   return true
end