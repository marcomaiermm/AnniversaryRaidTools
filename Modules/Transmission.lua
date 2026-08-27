local _, ART = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.

local L = ART.L
local Serializer = LibStub:GetLibrary("AceSerializer-3.0")
local Deflate = LibStub:GetLibrary("LibDeflate")
local ARTcommsObject = ART.commsObject
local presetCommPrefix = ART.presetCommPrefix

-- Lua APIs
local tremove = table.remove
local pairs, type, unpack = pairs, type, unpack

local uidCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789()"

local encodingPrefix = "!ART1!"

function ART:TableToString(inTable)
  local serialized = Serializer:Serialize(inTable)
  local compressed = Deflate:CompressDeflate(serialized)
  return encodingPrefix..Deflate:EncodeForPrint(compressed)
end

function ART:StringToTable(inString, fromChat)
  if type(inString) ~= "string" or inString:sub(1, #encodingPrefix) ~= encodingPrefix then
    return "Unsupported ART export format."
  end
  local decoded = Deflate:DecodeForPrint(inString:sub(#encodingPrefix + 1))
  if not decoded then return "Error decoding." end
  local decompressed = Deflate:DecompressDeflate(decoded)
  if not decompressed then return "Error decompressing." end
  local success, deserialized = Serializer:Deserialize(decompressed)
  return success and deserialized or "Error deserializing "..tostring(deserialized)
end

ART.transmissionCache = {}

local function showMapSectionIfNeeded()
  if ART.IsMapSectionActive and ART.SetCurrentSection and not ART:IsMapSectionActive() then
    ART:SetCurrentSection("maps")
  end
end

function ART:HandleChatLink(link, text)
  if (link and link:sub(0, 19) == "garrmission:artlive") then
    local sender = link:sub(21, string.len(link))
    local name, realm = string.match(sender, "(.*)+(.*)")
    sender = name.."-"..realm
    --ignore importing the live preset when sender is player, open ART only
    local playerName, playerRealm = UnitFullName("player")
    playerName = playerName.."-"..playerRealm
    if sender == playerName then
      ART:Async(function()
        showMapSectionIfNeeded()
        ART:ShowInterfaceInternal(true)
      end, "showInterface")
    else
      ART:Async(function()
        showMapSectionIfNeeded()
        ART:ShowInterfaceInternal(true)
        ART:LiveSession_Enable()
      end, "showInterfaceLive")
    end
    return
  elseif (link and link:sub(0, 15) == "garrmission:art") then
    local sender = link:sub(17, string.len(link))
    local name, realm = string.match(sender, "(.*)+(.*)")
    if (not name) or (not realm) then
      local msg = "\nsender: "..sender
      local escapedText = text:gsub("|", "||")
      msg = msg.."\nfull text: "..escapedText
      local cache = ART.U.TableToString(ART.transmissionCache)
      ART:OnError(msg, cache, "ART failed to import preset from chat link")
      return
    end
    -- to get the displayName (name of the preset) we need to get everything between the starting and closing brackets
    local displayName = text:match("%[(.-)%]")
    sender = name.."-"..realm
    local preset = ART.transmissionCache[sender] and ART.transmissionCache[sender][displayName]
    if preset and type(preset) == "table" then
      ART:Async(function()
        showMapSectionIfNeeded()
        ART:ShowInterfaceInternal(true)
        ART:ImportPreset(CopyTable(preset))
      end, "showInterfaceChatImport")
    elseif preset == 0 then --special marker for old raid preset
      local msg = L["WARNING_OLD_RAID_IMPORT"]
      print("|cFFFF0000ART:|r "..msg)
    else
      local msg = "\nparsed displayName: "..displayName
      msg = msg.."\nsender: "..sender
      local escapedText = text:gsub("|", "||")
      msg = msg.."\nfull text: "..escapedText
      local cache = ART.U.TableToString(ART.transmissionCache)
      ART:OnError(msg, cache, "ART failed to import preset from chat link")
    end
    return
  end
end

function ARTcommsObject:OnCommReceived(prefix, message, distribution, sender)
  --[[
        Sender has no realm name attached when sender is from the same realm as the player
        UnitFullName("Nnoggie") returns no realm while UnitFullName("player") does
        UnitFullName("Nnoggie-TarrenMill") returns realm even if you are not on the same realm as Nnoggie
        We append our realm if there is no realm
    ]]
  local name, realm = UnitFullName(sender)
  if not name then return end
  if not realm or string.len(realm) < 3 then
    local _, r = UnitFullName("player")
    realm = r
  end
  local fullName = name.."-"..realm

  if prefix == ART.versionCheckPrefix then
    if ART.VersionCheck_OnCommReceived then
      ART:VersionCheck_OnCommReceived(message, distribution, fullName)
    end
    return
  end

  --standard preset transmission
  --we cache the preset here already
  --the user still decides if he wants to click the chat link and add the preset to his db
  if prefix == presetCommPrefix then
    local preset = ART:StringToTable(message, false)
    if not ART:ValidateImportPreset(preset, true) then return end
    local presetName = preset.text
    local raid = ART:GetRaidName(preset.value.currentRaidIndex, true)
    if not raid then
      -- check if it's raid that has been in ART before but is not in the current version
      local knownRaid = ART.knownRaids[preset.value.currentRaidIndex]
      if knownRaid then
        local displayName = knownRaid..": "..presetName
        ART.transmissionCache[fullName] = ART.transmissionCache[fullName] or {}
        ART.transmissionCache[fullName][displayName] = 0 --special marker for old raid preset
      end
      return
    end
    local displayName = raid..": "..presetName
    ART.transmissionCache[fullName] = ART.transmissionCache[fullName] or {}
    ART.transmissionCache[fullName][displayName] = preset
    --live session preset
    if ART.liveSessionActive and ART.liveSessionAcceptingPreset and preset.uid == ART.livePresetUID then
      ART:ImportPreset(preset, true)
      ART.liveSessionAcceptingPreset = false
      ART.main_frame.SendingStatusBar:Hide()
      if ART.main_frame.LoadingSpinner then
        ART.main_frame.LoadingSpinner:Hide()
        ART.main_frame.LoadingSpinner.Anim:Stop()
      end
      ART.liveSessionRequested = false
    end
  end

  if prefix == ART.liveSessionPrefixes.enabled then
    if ART.liveSessionRequested == true then
      ART:LiveSession_SessionFound(fullName, message)
    end
  end

  --pulls
  if prefix == ART.liveSessionPrefixes.pull then
    if ART.liveSessionActive then
      local preset = ART:GetCurrentLivePreset()
      if preset.value.artWaveRaid then return end
      local pulls = ART:StringToTable(message, false)
      preset.value.pulls = pulls
      if not preset.value.pulls[preset.value.currentPull] then
        preset.value.currentPull = #preset.value.pulls
        preset.value.selection = { #preset.value.pulls }
      end
      if preset == ART:GetCurrentPreset() then
        ART:ReloadPullButtons()
        ART:SetSelectionToPull(ART:GetCurrentPull(), nil, true)
      end
    end
  end

  --live session messages that ignore concurrency from here on, we ignore our own messages
  if sender == UnitFullName("player") then return end

  if prefix == ART.liveSessionPrefixes.progress then
    ART:LiveSession_ReceiveProgress(message, distribution, fullName)
    return
  end

  if prefix == ART.liveSessionPrefixes.ccAssignment then
    if ART.CCAssignments then ART.CCAssignments:ReceiveChange(message, distribution, fullName) end
    return
  end

  if prefix == ART.liveSessionPrefixes.playerMark then
    if ART.Roster then ART.Roster:ReceiveChange(message, distribution, fullName) end
    return
  end

  if prefix == ART.liveSessionPrefixes.route then
    ART:LiveSession_ReceiveRoute(message, distribution, fullName)
    return
  end

  if prefix == ART.liveSessionPrefixes.request then
    if ART.liveSessionActive then
      ART:LiveSession_NotifyEnabled()
    end
  end

  --request preset
  if prefix == ART.liveSessionPrefixes.reqPre then
    local playerName, playerRealm = UnitFullName("player")
    playerName = playerName.."-"..playerRealm
    if playerName == message then
      ART:SendToGroup(ART:IsPlayerInGroup(), true, ART:GetCurrentLivePreset())
      ART:LiveSession_SendRoute()
    end
  end


  --ping
  if prefix == ART.liveSessionPrefixes.ping then
    local currentUID = ART:GetCurrentPreset().uid
    if ART.liveSessionActive and (currentUID and currentUID == ART.livePresetUID) then
      local x, y, sublevel = string.match(message, "(.*):(.*):(.*)")
      x = tonumber(x)
      y = tonumber(y)
      sublevel = tonumber(sublevel)
      local scale = ART:GetScale()
      if sublevel == ART:GetCurrentSubLevel() then
        ART:PingMap(x * scale, y * scale)
      end
    end
  end

  --preset objects
  if prefix == ART.liveSessionPrefixes.obj then
    if ART.liveSessionActive then
      local preset = ART:GetCurrentLivePreset()
      local obj = ART:StringToTable(message, false)
      ART:StorePresetObject(obj, true, preset)
      if preset == ART:GetCurrentPreset() then
        local scale = ART:GetScale()
        local currentPreset = ART:GetCurrentPreset()
        local currentSublevel = ART:GetCurrentSubLevel()
        ART:DrawPresetObject(obj, nil, scale, currentPreset, currentSublevel)
      end
    end
  end

  --preset object offsets
  if prefix == ART.liveSessionPrefixes.objOff then
    if ART.liveSessionActive then
      local preset = ART:GetCurrentLivePreset()
      local objIdx, x, y = string.match(message, "(.*):(.*):(.*)")
      objIdx = tonumber(objIdx)
      x = tonumber(x)
      y = tonumber(y)
      ART:UpdatePresetObjectOffsets(objIdx, x, y, preset, true)
      if preset == ART:GetCurrentPreset() then ART:DrawAllPresetObjects() end
    end
  end

  --preset object changed (deletions, partial deletions)
  if prefix == ART.liveSessionPrefixes.objChg then
    if ART.liveSessionActive then
      local preset = ART:GetCurrentLivePreset()
      local changedObjects = ART:StringToTable(message, false)
      if changedObjects and type(changedObjects) == "table" then
        for objIdx, obj in pairs(changedObjects) do
          preset.objects[objIdx] = obj
        end
        if preset == ART:GetCurrentPreset() then ART:DrawAllPresetObjects() end
      end
    end
  end

  --various commands
  if prefix == ART.liveSessionPrefixes.cmd then
    if ART.liveSessionActive then
      local preset = ART:GetCurrentLivePreset()
      if message == "deletePresetObjects" then ART:DeletePresetObjects(preset, true) end
      if message == "undo" then ART:PresetObjectStepBack(preset, true, true) end
      if message == "redo" then ART:PresetObjectStepForward(preset, true, true) end
      if message == "clear" then ART:ClearPreset(preset, true) end
    end
  end

  --note text update, delete, move
  if prefix == ART.liveSessionPrefixes.note then
    if ART.liveSessionActive then
      local preset = ART:GetCurrentLivePreset()
      local action, noteIdx, text, y = string.match(message, "(.*):(.*):(.*):(.*)")
      noteIdx = tonumber(noteIdx)
      if action == "text" then
        preset.objects[noteIdx].d[5] = text
      elseif action == "delete" then
        tremove(preset.objects, noteIdx)
      elseif action == "move" then
        local x = tonumber(text)
        y = tonumber(y)
        preset.objects[noteIdx].d[1] = x
        preset.objects[noteIdx].d[2] = y
      end
      if preset == ART:GetCurrentPreset() then ART:DrawAllPresetObjects() end
    end
  end

  --preset
  if prefix == ART.liveSessionPrefixes.preset then
    if ART.liveSessionActive then
      local preset = ART:StringToTable(message, false)
      local raid = ART:GetRaidName(preset.value.currentRaidIndex, true)
      local displayName = raid..": "..preset.text
      ART.transmissionCache[fullName] = ART.transmissionCache[fullName] or {}
      ART.transmissionCache[fullName][displayName] = preset
      if ART:ValidateImportPreset(preset) then
        ART:LiveSession_SetUID(preset.uid)
        ART:ImportPreset(preset, true)
      end
    end
  end
end

---MakeSendingStatusBar
---Creates a bar that indicates sending progress when sharing presets with your group
---Called once from initFrames()
function ART:MakeSendingStatusBar(f)
  f.SendingStatusBar = CreateFrame("StatusBar", nil, f)
  local statusbar = f.SendingStatusBar
  statusbar:SetMinMaxValues(0, 1)
  statusbar:SetPoint("CENTER", ART.main_frame.bottomPanel, "CENTER", 0, 0)
  statusbar:SetWidth(200)
  statusbar:SetHeight(20)
  statusbar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
  statusbar:GetStatusBarTexture():SetHorizTile(false)
  statusbar:GetStatusBarTexture():SetVertTile(false)
  statusbar:SetStatusBarColor(0.26, 0.42, 1)

  statusbar.bg = statusbar:CreateTexture(nil, "BACKGROUND", nil, 0)
  statusbar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
  statusbar.bg:SetAllPoints()
  statusbar.bg:SetVertexColor(0.26, 0.42, 1)

  statusbar.value = statusbar:CreateFontString(nil, "OVERLAY")
  statusbar.value:SetPoint("CENTER", statusbar, "CENTER", 0, 0)
  statusbar.value:SetFontObject(GameFontNormalSmall)
  statusbar.value:SetJustifyH("CENTER")
  statusbar.value:SetJustifyV("MIDDLE")
  statusbar.value:SetShadowOffset(1, -1)
  statusbar.value:SetTextColor(1, 1, 1)
  statusbar:Hide()

  --hooks to show/hide the bottom text
  statusbar:HookScript("OnShow", function(self)
    ART.main_frame.bottomPanelString:Hide()
  end)
  statusbar:HookScript("OnHide", function(self)
    ART.main_frame.bottomPanelString:Show()
  end)
end

--callback for SendCommMessage
local function displaySendingProgress(userArgs, bytesSent, bytesToSend, didSend)
  ART.main_frame.SendingStatusBar:Show()
  ART.main_frame.SendingStatusBar:SetValue(bytesSent / bytesToSend)
  ART.main_frame.SendingStatusBar.value:SetText(string.format(L["Sending: %.1f"], bytesSent / bytesToSend * 100).."%")
  --done sending
  if bytesSent == bytesToSend then
    local distribution = userArgs[1]
    local preset = userArgs[2]
    local silent = userArgs[3]
    --restore "Send" and "Live" button
    if ART.liveSessionActive then
      ART.main_frame.LiveSessionButton:SetText(L["*Live*"])
    else
      ART.main_frame.LiveSessionButton:SetText(L["Live"])
      ART.main_frame.LiveSessionButton.text:SetTextColor(1, 0.8196, 0)
      ART.main_frame.LinkToChatButton:SetDisabled(false)
      ART.main_frame.LinkToChatButton.text:SetTextColor(1, 0.8196, 0)
    end
    ART.main_frame.LinkToChatButton:SetText(L["Share"])
    ART.main_frame.LiveSessionButton:SetDisabled(false)
    ART.main_frame.SendingStatusBar:Hide()
    --output chat link
    if didSend ~= false and not silent and preset then
      local prefix = "[ART: "
      local raid = ART:GetRaidName(preset.value.currentRaidIndex, true)
      local presetName = preset.text
      local name, realm = UnitFullName("player")

      --UnitFullName("player") will always return a players name with a capitalised first letter, regardless of whether
      --or not that is actually the case, while UnitFullName("Nnoggie") will return the player name with case respected.
      --This causes a subtle bug for (the few) players who's name does not begin with a capital, where chat links do not
      --work, because line 243 in OnCommReceived respects the case of the name, but here in the sending code we do not.
      --As a result, the entry in ART.transmissionCache is indexed with case respected, but read on line 225 of this file
      --without respect for case (due to us sending it here, without respect for case). The fix is to subsequently call
      --GetUnitName(name) on the name, in order to get the correct case.

      ---@diagnostic disable-next-line: param-type-mismatch
      name = UnitFullName(name)

      local fullName = name.."+"..realm
      local message = prefix..fullName.." - "..raid..": "..presetName.."]"
      -- ponytail: delivery gap; add receiver acknowledgements if cross-client ordering still races.
      C_Timer.After(0.5, function() ART.Compat:SendChatMessage(message, distribution) end)
    end
  end
end

ART.displaySendingProgress = displaySendingProgress

---generates a unique random 11 digit number in base64
function ART:GenerateUniqueID(length)
  local s = {}
  for i = 1, length do
    local index = math.random(1, #uidCharacters)
    s[i] = uidCharacters:sub(index, index)
  end
  return table.concat(s)
end

function ART:SetUniqueID(preset)
  if not preset.uid then
    local newUid = ART:GenerateUniqueID(11)
    -- collision check
    local inUse = false
    local presets = ART:GetDB().presets
    for _, raid in pairs(presets) do
      for _, pres in pairs(raid) do
        if pres.uid and pres.uid == newUid then
          inUse = true
          break
        end
      end
    end
    if not inUse then
      preset.uid = newUid
    else
      ART:SetUniqueID(preset)
    end
  end
end

---SendToGroup
---Send current preset to group/raid
function ART:SendToGroup(distribution, silent, preset)
  preset = preset or ART:GetCurrentPreset()
  --set unique id
  ART:SetUniqueID(preset)
  ART:EnsurePresetCreatedBy(preset)
  local export = ART:TableToString(preset)
  ARTcommsObject:SendCommMessage("ARTPreset", export, distribution, nil, "BULK", displaySendingProgress,
    { distribution, preset, silent })
end
