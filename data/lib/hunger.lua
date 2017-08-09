
-- Hunger System by Kronos
-- version="1.2"
-- author Hellboy aka Kronos (idea Nandonalt)
-- https://otland.net/threads/hunger-system-tfs-mod-or-manual.60952/#post-631368
 
-- CONFIG
 
hungerConfig = {
   FIRST_LOGIN = -1,
 
   storageStage = 3636,
   storageOnDeathFeed = 3637,
   storageDmgAndCheckTicks = 3638,
 
   dmgAmount = 1,
   dmgAndCheckTicks = 5,
   newPlayerFeed = 30,
 
   ignore = {
     "Account Manager"
   },
 
   stages = {
     [1] = {minFeed = 15, msg = "Você vai morrer caso não coma algo!!"},
     [2] = {minFeed = 50, msg = "Você esta faminto!"},
	 [3] = {minFeed = 100, msg = "Você esta com muita fome."},
     [4] = {minFeed = 175, msg = "Você esta com fome"},
     [5] = {minFeed = 300, msg = "Você poderia comer algo"},
     [6] = {minFeed = 400, msg = "Você esta cheio"}
   }
}
 
-- /CONFIG
 
 
function Player.hungerIgnorePlayer(self)
   return isInArray(hungerConfig.ignore, self:getName())
end
 
function Player.hungerGetFeed(self)
   local feedCondition = self:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
   if feedCondition then
     return math.floor(feedCondition:getTicks() / 1000)
   end
   return 0
end
 
function Player.hungerGetFeedStorage(self)
   return self:getStorageValue(hungerConfig.storageOnDeathFeed)
end
 
function Player.hungerSetFeedStorage(self, value)
   self:setStorageValue(hungerConfig.storageOnDeathFeed, value)
end
 
function Player.hungerGetStage(self)
   return self:getStorageValue(hungerConfig.storageStage)
end
 
function Player.hungerSetStage(self)
   local feed = self:hungerGetFeed()
   local tmpStage = 0
   for stageNumber, stageInfo in ipairs(hungerConfig.stages) do
     tmpStage = stageNumber
     if stageInfo.minFeed >= feed then
       break
     end
   end
   self:setStorageValue(hungerConfig.storageStage, tmpStage)
end
 
function Player.hungerGetStageMsg(self)
   local stageId = self:getStorageValue(hungerConfig.storageStage)
   return hungerConfig.stages[stageId].msg
end
 
function Player.hungerDoDmg(self)
   self:addHealth(-hungerConfig.dmgAmount)
   return true
end
 