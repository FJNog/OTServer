function onSay(player, words, param)
   local msg = player:hungerGetStageMsg()
   player:sendTextMessage(MESSAGE_STATUS_DEFAULT, msg)
   return true
end