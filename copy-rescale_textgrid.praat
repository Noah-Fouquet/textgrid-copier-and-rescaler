# Copy and rescale TextGrid
# ===================
# Copy the tiers, boundaries, and labels from a reference TextGrid
# to new TextGrids in the TextGrid folder, automatically scaling
# the boundaries according to the duration of each recording present
# in the sound folder.
#
# This method only works when the stimulus is identical across all
# recordings in the experiment, such as a fixed read text or a set
# of sentences. This produces a rough automatic alignment that is
# not accurate and must be manually corrected. Its sole purpose is
# to provide a head start for later, precise manual alignment.
#
# Version: [1.1] - 20/01/2026
#
# Pablo Arantes <noe.fouquet90@gmail.com>
#
# Copyright (C) 2026 Fouquet Noé
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.

clearinfo

form Copy & rescale TextGrid to new files#
    text sound_folder ./sound/
    word sound_extension wav
    text textgrid_folder ./textgrid/
    text reference_textgrid ./ref.TextGrid
endform


# remove leading dot from extension if present
if left$(sound_extension$, 1) = "."
    sound_extension$ = mid$(sound_extension$, 2)
endif

appendInfoLine: "=== Loading reference TextGrid ==="

Read from file: reference_textgrid$
refTG$ = selected$("TextGrid")

select TextGrid 'refTG$'
refDur = Get end time

appendInfoLine: "Reference TG ", refTG$, " with duration of ", fixed$(refDur, 2), "s"

# ------------------------------------------------
# List sound files
# ------------------------------------------------

Create Strings as file list... list 'sound_folder$'*.'sound_extension$'
n_files = Get number of strings

if n_files = 0
    exitScript: "No sound files found."
endif

appendInfoLine: "Found ", n_files, " sound files."

# ------------------------------------------------
# Get tier structure once
# ------------------------------------------------

select TextGrid 'refTG$'
nTiers = Get number of tiers
tierNames$ = ""

for t from 1 to nTiers
    name$ = Get tier name: t
    tierNames$ = if t = 1 then name$ else tierNames$ + " " + name$ endif
    appendInfoLine: "Tier ", t, " = ", name$
endfor

Create Strings as file list... list_tg 'textgrid_folder$'*
n_tg = Get number of strings

# Loop of deletion of existing TG files if some exist in the TG folder
if n_tg >= 1
  beginPause: "Your TextGrid folder contains files, running the script would delete the files. Do you want to proceed?"
  clicked = endPause: "Yes", "No", 1
  if clicked = 1
    appendInfoLine: "Deleting the ", n_tg, " files in '", textgrid_folder$, "'"
    filedelete 'outTGPath$'
  elsif clicked = 2
    exitScript: "The ",n_tg," files in '", textgrid_folder$, "' were not deleted."
  endif
endif

# ================================================================
# MAIN LOOP
# ================================================================

for i from 1 to n_files
    appendInfoLine: newline$, "--- FILE ", i, " ---"

    select Strings list
    file_name$ = Get string... i
    appendInfoLine: "Sound file = ", file_name$

    baseName$ = replace$(file_name$, "." + sound_extension$, "", 0)
    outTGPath$ = textgrid_folder$ + baseName$ + ".TextGrid"

    Read from file... 'sound_folder$''file_name$'
    snd$ = selected$("Sound")

    select Sound 'snd$'
    sndDur = Get end time
    scale = sndDur / refDur

    appendInfoLine: "Sound ", file_name$, " duration = ", fixed$(sndDur, 2), "s | Scale factor = ", fixed$(scale, 2)

    select Sound 'snd$'
    To TextGrid: tierNames$, ""

    appendInfoLine: "Created TextGrid : ", baseName$

    # ------------------------------------------------
    # Copy & scale boundaries
    # ------------------------------------------------

    for t from 1 to nTiers
        select TextGrid 'refTG$'
        nInt = Get number of intervals: t

        for k from 1 to nInt - 1
            select TextGrid 'refTG$'
            ref_end = Get end point: t, k
            new_end = ref_end * scale

            select TextGrid 'baseName$'
            Insert boundary: t, new_end
        endfor
        appendInfoLine: ">> Tier ", t, "'s intervals ✔"
    endfor

    # ------------------------------------------------
    # Copy labels
    # ------------------------------------------------

    for t from 1 to nTiers
        select TextGrid 'refTG$'
        nInt = Get number of intervals: t

        for k from 1 to nInt
            select TextGrid 'refTG$'
            label$ = Get label of interval: t, k

            select TextGrid 'baseName$'
            Set interval text: t, k, label$
        endfor
        appendInfoLine: ">> Tier ", t, "'s labels ✔"
    endfor

    # ------------------------------------------------
    # Create TextGrid file and write information
    # ------------------------------------------------

    select TextGrid 'baseName$'
    Write to text file... 'textgrid_folder$''baseName$'.TextGrid
    appendInfoLine: "Saved TextGrid → ", outTGPath$
    appendInfoLine: "--- FILE ", i, " ✔---"

    # ------------------------------------------------
    # Cleanup
    # ------------------------------------------------

    select Sound 'snd$'
    plus TextGrid 'baseName$'
    Remove
endfor

select all
Remove

appendInfoLine: newline$, "✔ Done fitting TextGrids."
