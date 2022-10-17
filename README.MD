# GodotVSRG

A simple but functional vsrg example, designed to be similar in feel to other popular vsrgs and to be implemented in a way that supports most features existing players would expect from the gameplay portion of a rhythm game.

This is not currently designed to be a playable game and thus doesn't contain a main menu, song select, user options, or eval screens. But is instead just the gameplay and instantly just throws you into the chart.

## Features
- MSS (WIFE3) accuracy system
- NPS graph
- Hiterror bars
- Hidden/Sudden
- Scroll velocities
- Scroll speed
- Reverse scroll
- Judgements
- Toasties
- Song progress
- Break indicators
- Parses osu!mania charts (or atleast [this](https://osu.ppy.sh/beatmapsets/1022130#mania/2138515) one)

## Gameplay Example

https://user-images.githubusercontent.com/6253118/196013381-baf8337e-f0dc-4682-abcc-6ba431abd8ab.mp4

## Screenshot(s)

![image](https://user-images.githubusercontent.com/6253118/196020698-3422f22a-beca-415f-bb83-58eebe4f0258.png)

## How to test

Charts should go into a song folder in the project root, so "res://song/" will find it, charts are made of 2 parts chart.osu and audio.mp3, you can get both from extracting them from a .osz file.

Technically these should be loaded via usr:// and engine should handle unzipping them but I haven't got around to it yet.

Keybinds are ZX,. change them in the project settings if you want different ones.

Other settings are in code/gameplay/UserSettings.


