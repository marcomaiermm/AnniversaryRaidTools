local _, ART = ...
local L = ART.L
local ARTcommsObject = ART.commsObject
local twipe, tinsert = table.wipe, table.insert

local timer
local requestTimer
local raidPrompted

local function fullName(unit)
  local name, realm = UnitFullName(unit)
  if not name then return end
  if not realm or realm == "" then _, realm = UnitFullName("player") end
  return name.."-"..(realm or "")
end

local function raidRank(name)
  if not (type(IsInRaid) == "function" and IsInRaid()) then return -1 end
  for index = 1, GetNumGroupMembers() do
    local unit = "raid"..index
    if UnitExists(unit) and fullName(unit) == name then
      if UnitIsGroupLeader(unit) then return 2 end
      if UnitIsGroupAssistant(unit) then return 1 end
      return 0
    end
  end
  return -1
end

function ART:LiveSession_CanControlProgress(name)
  if not (type(IsInRaid) == "function" and IsInRaid()) then return false end
  if name then return raidRank(name) >= 1 end
  return UnitIsGroupLeader("player") == true or UnitIsGroupAssistant("player") == true
end

function ART:LiveSession_GetPreferredSession(sessions)
  table.sort(sessions, function(left, right)
    local leftRank, rightRank = raidRank(left[1]), raidRank(right[1])
    if leftRank ~= rightRank then return leftRank > rightRank end
    return left[1] < right[1]
  end)
  return sessions[1]
end

function ART:LiveSession_SendProgress(index)
  local preset, distribution = self:GetCurrentPreset(), self:IsPlayerInGroup()
  if not self.liveSessionActive or distribution ~= "RAID" or not self:LiveSession_CanControlProgress()
      or not preset or preset.uid ~= self.livePresetUID or type(index) ~= "number" or index % 1 ~= 0
      or index < 1 or index > #(preset.value.pulls or {}) then return false end
  local raid = ART and ART.RaidPlanner and ART.RaidPlanner.raid
  if not raid then return false end
  ARTcommsObject:SendCommMessage(self.liveSessionPrefixes.progress, self:TableToString({
    version = 1, kind = "selection", raidKey = raid.key, raidIndex = preset.value.currentRaidIndex,
    presetUID = preset.uid, index = index,
  }), distribution, nil, "ALERT")
  return true
end

function ART:LiveSession_ReceiveProgress(message, distribution, sender)
  if not self.liveSessionActive or distribution ~= "RAID" or sender == fullName("player")
      or not self:LiveSession_CanControlProgress(sender) then return false end
  local payload = type(message) == "table" and message or self:StringToTable(message, false)
  local preset = self:GetCurrentLivePreset()
  if type(payload) ~= "table" or payload.version ~= 1 or payload.kind ~= "selection"
      or type(payload.raidKey) ~= "string" or type(payload.raidIndex) ~= "number"
      or type(payload.index) ~= "number" or payload.index % 1 ~= 0 or not preset or not preset.value
      or payload.raidIndex ~= preset.value.currentRaidIndex or payload.index < 1
      or payload.index > #(preset.value.pulls or {}) then return false end
  local waveRaid = preset.value.artWaveRaid
  if waveRaid then
    if waveRaid ~= payload.raidKey then return false end
  elseif payload.presetUID ~= preset.uid then
    return false
  end

  preset.value.currentPull, preset.value.selection = payload.index, { payload.index }
  if preset == self:GetCurrentPreset() then
    self.applyingLiveProgress = true
    if not waveRaid and self.SetMapSublevel then self:SetMapSublevel(payload.index) end
    self:SetSelectionToPull(payload.index)
    self.applyingLiveProgress = nil
  end
  return true
end

local originalSetSelectionToPull = ART.SetSelectionToPull
function ART:SetSelectionToPull(pull, ...)
  local result = originalSetSelectionToPull(self, pull, ...)
  local passive = select(2, ...) == true
  if type(pull) == "number" and not passive and not self.applyingLiveProgress then
    self:LiveSession_SendProgress(pull)
  end
  return result
end

function ART:LiveSession_CheckRaidPrompt()
  if not (type(IsInRaid) == "function" and IsInRaid()) then
    raidPrompted = nil
    if self.raidPromptLiveSession and self.liveSessionActive then self:LiveSession_Disable() end
    self.raidPromptLiveSession = nil
    return false
  end
  if self.liveSessionActive then raidPrompted = true return false end
  local zoneId = self.Compat and self.Compat:GetBestMapForUnit("player")
  local raidIndex = zoneId and self.zoneIdToRaidIndex and self.zoneIdToRaidIndex[zoneId]
  if not raidIndex or not self.mapInfo or not self.mapInfo[raidIndex]
      or (self.unsupportedRaids and self.unsupportedRaids[raidIndex])
      or raidPrompted then return false end
  raidPrompted = true
  self:OpenConfirmationFrame(430, 150, L["Raid progress sync"], L["Enable"], L["raidProgressSyncPrompt"], function()
    local enable = function()
      if self.CheckCurrentZone then self:CheckCurrentZone() end
      self.raidPromptLiveSession = true
      self:LiveSession_Enable()
    end
    self:RunAfterFramesInitialized(enable)
    self:StartMainFrameInitialization()
  end)
  return true
end

---LiveSession_Enable
function ART:LiveSession_Enable()
  if self.liveSessionActive then return end
  self.main_frame.LiveSessionButton:SetText(L["*Live*"])
  self.main_frame.LiveSessionButton.text:SetTextColor(0, 1, 0)
  self.main_frame.LinkToChatButton:SetDisabled(true)
  self.main_frame.LinkToChatButton.text:SetTextColor(0.5, 0.5, 0.5)
  self.main_frame.sidePanelDeleteButton:SetDisabled(true)
  self.main_frame.sidePanelDeleteButton.text:SetTextColor(0.5, 0.5, 0.5)
  self.liveSessionActive = true
  self:SetUniqueID(self:GetCurrentPreset())
  self:EnsurePresetCreatedBy(self:GetCurrentPreset())
  self.livePresetUID = self:GetCurrentPreset().uid
  -- The local session must participate so simultaneous joins choose the same ranked owner.
  self:LiveSession_RequestSession()
  self:UpdatePresetDropdownTextColor()
  timer = C_Timer.NewTimer(2, function()
    local callback = function()
      self.liveSessionRequested = false
      local distribution = self:IsPlayerInGroup()
      local preset = self:GetCurrentPreset()
      local prefix = "[ARTLive: "
      local raid = self:GetRaidName(preset.value.currentRaidIndex)
      local presetName = preset.text
      local name, realm = UnitFullName("player")
      local fullName = name.."+"..realm
      ART.Compat:SendChatMessage(prefix..fullName.." - "..raid..": "..presetName.."]", distribution)
    end
    local cancelCallback = function()
      ART:LiveSession_Disable()
    end
    local fireCancelOnClose = true
    ART:CheckPresetSize(callback, cancelCallback, fireCancelOnClose)
  end)
end

---LiveSession_Disable
function ART:LiveSession_Disable()
  local widget = ART.main_frame.LiveSessionButton
  widget.text:SetTextColor(widget.normalTextColor.r, widget.normalTextColor.g, widget.normalTextColor.b)
  widget.text:SetText(L["Live"])
  ART.main_frame.LinkToChatButton:SetDisabled(false)
  self.main_frame.LinkToChatButton.text:SetTextColor(1, 0.8196, 0)
  local db = ART:GetDB()
  if db.presets[db.currentRaidIndex][1] == ART:GetCurrentPreset() then
    ART.main_frame.sidePanelDeleteButton:SetDisabled(true)
    ART.main_frame.sidePanelDeleteButton.text:SetTextColor(0.5, 0.5, 0.5)
  else
    self.main_frame.sidePanelDeleteButton:SetDisabled(false)
    self.main_frame.sidePanelDeleteButton.text:SetTextColor(1, 0.8196, 0)
  end
  self.liveSessionActive = false
  self.liveSessionAcceptingPreset = false
  self:UpdatePresetDropdownTextColor()
  self.main_frame.liveReturnButton:Hide()
  self.main_frame.setLivePresetButton:Hide()
  if timer then timer:Cancel() end
  self.liveSessionRequested = false
  self.main_frame.SendingStatusBar:Hide()
  if self.main_frame.LoadingSpinner then
    self.main_frame.LoadingSpinner:Hide()
    self.main_frame.LoadingSpinner.Anim:Stop()
  end
end

---Notify specific group member that my live session is active
local lastNotify
function ART:LiveSession_NotifyEnabled()
  local now = GetTime()
  if not lastNotify or lastNotify < now - 0.2 then
    lastNotify = now
    local distribution = self:IsPlayerInGroup()
    if (not distribution) or (not self.liveSessionActive) then return end
    local uid = self.livePresetUID
    ARTcommsObject:SendCommMessage(self.liveSessionPrefixes.enabled, uid, distribution, nil, "ALERT")
  end
  --self:SendToGroup(self:IsPlayerInGroup(),true,self:GetCurrentLivePreset())
end

---Send a request to the group to send notify messages for active sessions
function ART:LiveSession_RequestSession()
  local distribution = self:IsPlayerInGroup()
  if (not distribution) or (not self.liveSessionActive) then return end
  self.liveSessionRequested = true
  self.liveSessionActiveSessions = self.liveSessionActiveSessions or {}
  twipe(self.liveSessionActiveSessions)
  tinsert(self.liveSessionActiveSessions, { fullName("player"), self.livePresetUID })
  ARTcommsObject:SendCommMessage(self.liveSessionPrefixes.request, "0", distribution, nil, "ALERT")
end

function ART:LiveSession_SessionFound(sender, uid)
  local fullNamePlayer = fullName("player")

  for _, session in ipairs(self.liveSessionActiveSessions) do
    if session[1] == sender then session[2] = uid return end
  end

  if (not self.liveSessionAcceptingPreset) and fullNamePlayer ~= sender then
    if timer then timer:Cancel() end
    self.liveSessionAcceptingPreset = true
    --request the preset from one client only after a short delay
    --we have to delay a bit to catch all active clients
    requestTimer = C_Timer.NewTimer(0.5, function()
      local preferred = self:LiveSession_GetPreferredSession(self.liveSessionActiveSessions)
      if preferred and preferred[1] ~= fullNamePlayer then
        self.main_frame.SendingStatusBar:Show()
        self.main_frame.SendingStatusBar:SetValue(0 / 1)
        self.main_frame.SendingStatusBar.value:SetText(L["Receiving: ..."])
        if not self.main_frame.LoadingSpinner then
          self.main_frame.LoadingSpinner = CreateFrame("Frame", "ARTLoadingSpinner", self.main_frame)
          self.main_frame.LoadingSpinner:SetPoint("CENTER", self.main_frame, "CENTER")
          self.main_frame.LoadingSpinner:SetSize(60, 60)
          self.main_frame.LoadingSpinner.Anim = { Play = function() end, Stop = function() end }
        end
        self.main_frame.LoadingSpinner:Show()
        self.main_frame.LoadingSpinner.Anim:Play()
        self:UpdatePresetDropdownTextColor(true)

        self.liveSessionRequested = false
        self:LiveSession_RequestPreset(preferred[1])
        self.livePresetUID = preferred[2]
      else
        self.liveSessionAcceptingPreset = false
        self.liveSessionRequested = false
      end
    end)
  end
  --catch clients
  tinsert(self.liveSessionActiveSessions, { sender, uid })
end

function ART:LiveSession_RequestPreset(fullName)
  local distribution = self:IsPlayerInGroup()
  if (not distribution) or (not self.liveSessionActive) then return end
  ARTcommsObject:SendCommMessage(self.liveSessionPrefixes.reqPre, fullName, distribution, nil, "ALERT")
end

---Sends a map ping
function ART:LiveSession_SendPing(x, y, sublevel)
  --only send ping if we are in the livesession preset
  if self:GetCurrentPreset().uid == self.livePresetUID then
    local distribution = self:IsPlayerInGroup()
    if distribution then
      local scale = self:GetScale()
      ARTcommsObject:SendCommMessage(self.liveSessionPrefixes.ping, x * (1 / scale)..":"..y * (1 / scale)..
        ":"..sublevel, distribution, nil, "ALERT")
    end
  end
end

---Sends a preset object
function ART:LiveSession_SendObject(obj)
  if self:GetCurrentPreset().uid == self.livePresetUID then
    local distribution = self:IsPlayerInGroup()
    if distribution then
      local export = ART:TableToString(obj)
      local silent, fromLiveSession = true, true
      ARTcommsObject:SendCommMessage(self.liveSessionPrefixes.obj, export, distribution, nil, "BULK", ART.displaySendingProgress,
        { distribution, nil, silent, fromLiveSession })
    end
  end
end

---Sends updated object offsets (move object)
function ART:LiveSession_SendObjectOffsets(objIdx, x, y)
  if self:GetCurrentPreset().uid == self.livePresetUID then
    local distribution = self:IsPlayerInGroup()
    if distribution then
      ARTcommsObject:SendCommMessage(self.liveSessionPrefixes.objOff, objIdx..":"..x..":"..y, distribution, nil,
        "ALERT")
    end
  end
end

---Sends updated objects - instead of sending an update every time we erase a part of an object we send one message after mouse up
function ART:LiveSession_SendUpdatedObjects(changedObjects)
  if self:GetCurrentPreset().uid == self.livePresetUID then
    local distribution = self:IsPlayerInGroup()
    if distribution then
      local export = ART:TableToString(changedObjects)
      ARTcommsObject:SendCommMessage(self.liveSessionPrefixes.objChg, export, distribution, nil, "ALERT")
    end
  end
end

---Sends various commands: delete all drawings, clear preset, undo, redo
function ART:LiveSession_SendCommand(cmd)
  if self:GetCurrentPreset().uid == self.livePresetUID then
    local distribution = self:IsPlayerInGroup()
    if distribution then
      ARTcommsObject:SendCommMessage(self.liveSessionPrefixes.cmd, cmd, distribution, nil, "ALERT")
    end
  end
end

---Sends a note text update
function ART:LiveSession_SendNoteCommand(cmd, noteIdx, text, y)
  if self:GetCurrentPreset().uid == self.livePresetUID then
    local distribution = self:IsPlayerInGroup()
    if distribution then
      text = text..":"..(y or "0")
      ARTcommsObject:SendCommMessage(self.liveSessionPrefixes.note, cmd..":"..noteIdx..":"..text, distribution,
        nil, "ALERT")
    end
  end
end

---Sends a new preset to be used as the new live session preset
function ART:LiveSession_SendPreset(preset)
  local distribution = self:IsPlayerInGroup()
  if distribution then
    self:SetUniqueID(preset)
    self:EnsurePresetCreatedBy(preset)
    local export = ART:TableToString(preset)
    local silent, fromLiveSession = true, true
    ARTcommsObject:SendCommMessage(self.liveSessionPrefixes.preset, export, distribution, nil, "BULK", ART.displaySendingProgress,
      { distribution, preset, silent, fromLiveSession })
  end
end

---Sends the current pull payload consumed by the transmission receiver.
function ART:LiveSession_SendPulls(pulls)
  local distribution = self:IsPlayerInGroup()
  if distribution then
    local msg = ART:TableToString(pulls)
    ARTcommsObject:SendCommMessage(self.liveSessionPrefixes.pull, msg, distribution, nil, "ALERT")
  end
end

function ART:LiveSession_SendPOIAssignment(sublevel, poiIdx, value)
  local distribution = self:IsPlayerInGroup()
  if distribution then
    local export = ART:TableToString({ sublevel, poiIdx, value })
    ARTcommsObject:SendCommMessage(self.liveSessionPrefixes.poiAssignment, export, distribution, nil, "ALERT")
  end
end

if type(CreateFrame) == "function" then
  local raidPromptFrame = CreateFrame("Frame")
  raidPromptFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
  raidPromptFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  raidPromptFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  raidPromptFrame:SetScript("OnEvent", function()
    C_Timer.After(0.5, function() ART:LiveSession_CheckRaidPrompt() end)
  end)
end
