if (instance_number(object_index) > 1) {
    instance_destroy();
    show_debug_message("We only want one dialog to run at a time.");
}
#region textbox display configuration
depth = -10000; // This assumes you want the textbox to be in their face. There might be a game mechanic where you have to clear the junk out of the way to hear someone. Heh. You do you!
textboxWidth = 260;
textboxHeight = 80;
preferredSpaceFromTopOfCamera = 200;
border = 8;
fontColor[0] = c_black;
// You can set the spacing manually. I noticed that about 20% more than the font size looked good.
lineSpacing = floor(font_get_size(customFont) * 1.20);
maximumLineWidth = textboxWidth - (border * 2);
textBackgroundSprite[0] = sprTextbox;
textBackgroundImage = 0;
textBackgroundImageSpeed = 6/60;
acceptKeyTimerDelay = 10;
acceptKeyTimer = acceptKeyTimerDelay;
#endregion

#region option display configuration
optionSpacing = lineSpacing + 13; // We need room to draw the text (hence lineSpacing), plus a little margin for cleanliness.
optionBorder = 4;
optionMarginToRenderCarat = 35;
#endregion

#region textbox logic configuration
npcTextArrayInOrder = array_create(0);
textLength = array_create(1, undefined);
currentPage = 0;
optionalStartPage = -1;
totalNumberOfPages = 0;
numberOfCharactersToDraw = 0;
textSpeed = 1;
#endregion

#region Dialog text by character and where to draw it
characters[0][0] = ""; // character, page
characterXCoords[0][0] = 0; // character, page
characterYCoords[0][0] = 0; // character, page
#endregion

#region options
availableOptions[0][0] = "";
optionLinkIdStartPage[0][0] = -1;
optionLinkId[0][0] = -1;
currentlySelectedOption = 0;
totalNumberOfOptions[0] = 0;
#endregion

setupRan = false;

#region sound
/*
	My sounds are 20 seconds long at most, so here I target 60 frames times 20 seconds to ensure they don't play over each other.
	However, to do this more accurately you would need to use audio_sound_length to get the length of the sound once during setup and keep track of that per sound.
	You could also make these arrays to manually set their length.
	Finally, you could also make sure all of your sounds are the same length.
*/
soundDelay = 60*20; 
soundCount = soundDelay;
// You could use !audio_is_playing to achieve a similar result instead of how I implemented currentlyPlayingSound
// I went with this so that I could stop the audio at the end of the page.
currentlyPlayingSound = -1;
#endregion

#region effects
scrSetDefaultsForText();
lastSeenSpacePosition = 0;
textPauseTimer = 0;
textPauseTime = 16;
#endregion