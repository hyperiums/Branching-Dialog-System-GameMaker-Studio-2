if (instance_number(object_index) > 1) {
    instance_destroy();
    show_debug_message("We only want one dialog to run at a time.");
}
#region textbox display configuration
depth = -10000; // This assumes you want the textbox to be in their face. There might be a game mechanic where you have to clear the junk out of the way to hear someone. Heh. You do you!
textboxWidth = 225;
textboxHeight = 94;
preferredSpaceFromTopOfCamera = 180;
border = 8;
// You can set the spacing manually. I noticed that about 20% more than the font size looked good.
lineSpacing = floor(font_get_size(customFont) * 1.20);
maximumLineWidth = textboxWidth - (border * 2);
textBackgroundSprite = sprTextbox;
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
totalNumberOfPages = 0;
numberOfCharactersToDraw = 0;
textSpeed = 1;
#endregion

#region options
availableOptions[0] = "";
optionLinkId[0] = -1;
currentlySelectedOption = 0;
totalNumberOfOptions = 0;
#endregion

setupRan = false;