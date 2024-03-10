function getClientInfo()
    return {
        name = "Bad Apple!! PV in Synthesizer V",
        author = "UtaUtaUtau",
        versionNumber = 1,
        minEditorVersion = 0
    }
end

function split(s, separator)
    if separator == nil then
        separator = "%s"
    end
    local t = {}
    for str in string.gmatch(s, "([^"..separator.."]+)") do
        table.insert(t, str)
    end
    return t
end

frames = 6572
frame = 1
aspectRatio = 4 / 3
height = 39
imgWidth = 52
interval = 125
noteWidth = height * aspectRatio

function writeFrame()
    -- Clear notes
    for i=1,track:getNumNotes() do
        track:removeNote(1)
    end
    -- Draw frame
    local framePath = svpDir.."lua_frames\\"..string.format("frame-%04d.txt", frame)
    for line in io.lines(framePath) do
        local lineInfo = split(line, ":")
        local pitch = 60 + tonumber(lineInfo[1])
        local noteRanges = split(lineInfo[2], ",")
        if #noteRanges > 1 then
            for i=1,#noteRanges,2 do
                local onset = tonumber(noteRanges[i])
                local duration = tonumber(noteRanges[i+1]) - tonumber(noteRanges[i])
                onset = math.floor(SV.QUARTER * noteWidth * onset / (8 * imgWidth) + 0.5)
                duration = math.floor(SV.QUARTER * noteWidth * duration / (8 * imgWidth) + 0.5)

                local note = SV:create("Note")
                note:setOnset(onset)
                note:setDuration(duration)
                note:setPitch(pitch)
                track:addNote(note)
            end
        end
    end

    -- Frame Number
    local frameNumber = SV:create("Note")
    frameNumber:setOnset(SV.QUARTER * 7)
    frameNumber:setDuration(SV.QUARTER)
    frameNumber:setLyrics("Frame: "..frame)
    frameNumber:setPitch(84)
    track:addNote(frameNumber)

    -- Current Time
    local frameNumber = SV:create("Note")
    frameNumber:setOnset(SV.QUARTER * 7)
    frameNumber:setDuration(SV.QUARTER)
    frameNumber:setLyrics("Time: "..os.date("%I:%M %p"))
    frameNumber:setPitch(83)
    track:addNote(frameNumber)

    frame = frame + 1
    if frame > frames then
        SV:finish()
    else
        SV:setTimeout(interval, writeFrame)
    end
end

function main()
    -- Rescale
    local eight = SV.QUARTER / 8
    local mainEditor = SV:getMainEditor()
    local coordSystem = mainEditor:getNavigation()
    local pxPerBlick = coordSystem:getTimePxPerUnit()
    local pxPerEight = eight * pxPerBlick
    local pxPerSemitone = coordSystem:getValuePxPerUnit()
    local rescale = pxPerSemitone / pxPerEight
    coordSystem:setTimeScale(rescale * pxPerBlick)

    -- Get the only track
    track = mainEditor:getCurrentGroup():getTarget()

    svpDir = SV:getProject():getFileName():match("(.*\\)")
    writeFrame(frame)
end