-- Based on https://www.nexusmods.com/morrowind/mods/49040?tab=description

local slow = 141421
local medium = 70710
local fast = 17677

local REGEN_SPEED = medium

local formula = "((GetSquareRoot, int) * (wp * wp / "..REGEN_SPEED.." ))"

local function OnServerPostInit(eventStatus)
RecordStores["script"].data.permanentRecords["rem_magickaregen_startup"] = { scriptText = "begin rem_magickaregen_startup\n\nif ( chargenState != -1 )\n    return\nendif\n\nif ( player->GetEffect sEffectStuntedMagicka == 1 )\n    StopScript rem_magickaregen_startup\n    return\nendif\n\nStartScript rem_magickareg\nStopScript rem_magickaregen_startup\n\nend\n"}
RecordStores["script"].data.permanentRecords["Rem_MagickaRegenMenuMode"] = { scriptText = "begin Rem_MagickaRegenMenuMode\n\nfloat time\nfloat wp\nfloat int\nfloat reg\n\nif ( time == 0 )\n    set time to ( 24 * DaysPassed + GameHour )\n    return\nendif\n\nif ( MenuMode )\n    return\nendif\n\nset int to ( player->GetIntelligence )\nset wp to ( player->GetWillpower )\nset reg to "..formula.."\nset time to ( 24 * DaysPassed + GameHour ) - time\nset reg to ( reg * ( time * 30 ))\nplayer->ModCurrentMagicka, reg\nset reg to 0\nset time to 0\n\nStopScript Rem_MagickaRegenMenuMode\n\nend\n"}
RecordStores["script"].data.permanentRecords["Rem_Magickareg"] = { scriptText = "begin Rem_Magickareg\n\nfloat timer\nfloat wp\nfloat int\nfloat reg\n\nif ( MenuMode )\n   if ( ScriptRunning Rem_MagickaRegenMenuMode == 0 )\n      StartScript Rem_MagickaRegenMenuMode\nendif\nelse\n    set timer to ( timer + GetSecondsPassed )\n    if ( timer < 1 )\n        return\n    endif\n    set timer to 0\n\n    set int to ( player->GetIntelligence )\n    set wp to ( player->GetWillpower )\n    set reg to "..formula.."\n    player->ModCurrentMagicka reg\n    return\nendif\n\nend\n"}
RecordStores["script"]:Save()

table.insert(config.playerStartupScripts,"rem_magickaregen_startup")
end

customEventHooks.registerHandler("OnServerPostInit", OnServerPostInit)
