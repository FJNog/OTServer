function onUse(player, item, fromPosition, itemEx, toPosition)
if not (Item(itemEx.uid) or not Creature(itemEx.uid)) or itemEx.itemid == 2173 then return false end
stat_onUse(player, item, fromPosition, itemEx, toPosition)
return true
end