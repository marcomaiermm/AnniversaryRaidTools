local _, addon = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.

local ART = addon
addon.test = {}
local T = addon.test
local AceGUI = LibStub("AceGUI-3.0")

--- @type ARTTest[]
T.testList = {}

local function snapshotErrors()
  local snapshot = {}
  for _, errorInfo in ipairs(ART:GetErrors()) do
    snapshot[errorInfo.message] = errorInfo.count or 1
  end
  return snapshot
end

local function getNewErrors(snapshot)
  local newErrors = {}
  for _, errorInfo in ipairs(ART:GetErrors()) do
    if (errorInfo.count or 1) > (snapshot[errorInfo.message] or 0) then
      newErrors[#newErrors + 1] = errorInfo
    end
  end
  return newErrors
end
local resultText = ""

local function showResults(output)
  resultText = table.concat(output, "\n")

  if not T.resultFrame then
    local resultFrame = AceGUI:Create("Frame")
    T.resultFrame = resultFrame
    _G.ARTTestResultFrame = resultFrame.frame
    table.insert(UISpecialFrames, "ARTTestResultFrame")
    resultFrame:SetTitle("ART Test Results")
    resultFrame:SetWidth(800)
    resultFrame:SetHeight(600)
    resultFrame:EnableResize(false)
    resultFrame:SetLayout("Flow")
    resultFrame:SetCallback("OnClose", function()
      if ART.copyHelper then ART.copyHelper:SmartHide() end
    end)

    local resultBox = AceGUI:Create("MultiLineEditBox")
    T.resultBox = resultBox
    resultBox:SetWidth(800)
    resultBox:SetLabel("Complete test output")
    resultBox:DisableButton(true)
    resultBox:SetNumLines(25)
    resultBox:SetCallback("OnTextChanged", function()
      resultBox:SetText(resultText)
    end)

    local copyButton = AceGUI:Create("Button")
    T.copyButton = copyButton
    copyButton:SetText("Copy results")
    copyButton:SetHeight(40)
    copyButton:SetCallback("OnClick", function()
      resultBox:HighlightText(0, #resultText)
      resultBox:SetFocus()
      copyButton:SetDisabled(true)
      ART.copyHelper:SmartShow(resultFrame.frame, 0, 0)
    end)
    resultBox.editBox:HookScript("OnEditFocusLost", function()
      copyButton:SetDisabled(false)
      ART.copyHelper:SmartHide()
    end)
    resultBox.editBox:SetScript("OnKeyUp", function(_, key)
      if ART.copyHelper:WasControlKeyDown() and key == "C" then
        ART.copyHelper:SmartFadeOut()
        resultBox:ClearFocus()
      end
    end)

    resultFrame:AddChild(resultBox)
    resultFrame:AddChild(copyButton)
  end
  if not ART.copyHelper then ART:MakeCopyHelper(T.resultFrame.frame) end

  T.resultBox:SetText(resultText)
  if ART.main_frame then T.resultFrame.frame:SetParent(ART.main_frame) end
  T.resultFrame.frame:SetFrameStrata("DIALOG")
  T.resultFrame:Show()
end

local testRunPending
local testRunActive

function T:RunAllTests()
  if testRunPending or testRunActive then return end
  testRunPending = true

  local function startTests()
    if not testRunPending or testRunActive then return end
    if not ART:AreFramesInitialized() then return end
    testRunPending = false
    testRunActive = true

    local output = {}
    local failedTests = 0
    local originalPrint = print

    local function log(...)
      originalPrint(...)
      local values = {}
      for index = 1, select("#", ...) do
        values[index] = tostring(select(index, ...))
      end
      local message = table.concat(values, "\t")
      output[#output + 1] = message:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    end

    log("Running all tests")

    local function runTest(index)
      local test = T.testList[index]
      if not test then
        local passedTests = #T.testList - failedTests
        if failedTests == 0 then
          log("\124cff00ff00PASS: "..passedTests.." test(s) passed\124r")
        else
          log("\124cffff0000FAIL: "..passedTests.." passed, "..failedTests.." failed\124r")
        end
        testRunActive = false
        showResults(output)
        return
      end

      log("RUN: "..test.name)
      local errorsBefore = snapshotErrors()
      _G.print = log
      local succeeded, testResult = pcall(test.func)
      C_Timer.After(test.duration, function()
        local verified, verifyError = true
        if succeeded and type(testResult) == "function" then
          verified, verifyError = pcall(testResult)
        end
        if _G.print == log then _G.print = originalPrint end
        local newErrors = getNewErrors(errorsBefore)
        if not succeeded or not verified or #newErrors > 0 then
          failedTests = failedTests + 1
          log("\124cffff0000FAIL: "..test.name.."\124r")
          if not succeeded then log(testResult)
          elseif not verified then log(verifyError) end
          for _, errorInfo in ipairs(newErrors) do
            log(errorInfo.message)
          end
        else
          log("\124cff00ff00PASS: "..test.name.."\124r")
        end
        runTest(index + 1)
      end)
    end

    C_Timer.After(1, function() runTest(1) end)
  end

  if ART:AreFramesInitialized() then
    startTests()
    return
  end

  ART:RunAfterFramesInitialized(startTests)
  if testRunPending then ART:ShowInterface(true) end
end
