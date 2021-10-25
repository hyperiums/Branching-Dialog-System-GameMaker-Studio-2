acceptKey = keyboard_check_pressed(vk_space);

textboxX = camera_get_view_x(view_camera[0]);
textboxY = camera_get_view_y(view_camera[0]) + preferredSpaceFromTopOfCamera;

if (!setupRan) {
    /* 
    	This font can be found here: https://www.fontspace.com/haeres-letter-font-f53961.
    	Googling "open source fonts" led me to sites like https://www.fontspace.com/category/open-source.
    	To install the font to your machine, google "how to install a font on {your operating system}."
    	Restart game maker studio so it can detect the new font.
    	Create a font like you do an object, then select your new font from the drop-down.
    	Random troubleshooting: if the game font isn't rendering or compiling, delete the font asset, close gms, re-add. I have no idea what causes this, but I ran into it, so hopefully, that tip will help you as well.
    */
    draw_set_font(customFont);
    draw_set_color(c_black);
    draw_set_valign(fa_top);
    draw_set_halign(fa_left);


    totalNumberOfPages = array_length(npcTextArrayInOrder);

    for (var p = 0; p < totalNumberOfPages; p++) {
        textLength[p] = string_length(npcTextArrayInOrder[p]);

        // This roughly centers textbox on our screen screen without a character speaking.
        textXOffset[p] = 87;
    }
    currentPage = 0;
    setupRan = true;
}

#region calculate how may characters to draw of oru current page
if (numberOfCharactersToDraw < textLength[currentPage]) {
    numberOfCharactersToDraw += textSpeed;
    // prevent overflow for faster typing speeds
    numberOfCharactersToDraw = clamp(numberOfCharactersToDraw, 0, textLength[currentPage]);
}
#endregion

#region flip through pages
if (acceptKey) {
    if (numberOfCharactersToDraw == textLength[currentPage]) {
        if (currentPage < totalNumberOfPages - 1) {
            currentPage++;
            numberOfCharactersToDraw = 0;
        } else {
            instance_destroy();
            if (totalNumberOfOptions > 0) {
                populateAndStartConversationById(optionLinkId[currentlySelectedOption]);
            }
        }
    } else {
        numberOfCharactersToDraw = textLength[currentPage];
    }
}
#endregion

#region base textbox positioning configuration, influences both options and dialog
textBackgroundSpriteWidth = sprite_get_width(textBackgroundSprite);
textBackgroundSpriteHeight = sprite_get_height(textBackgroundSprite);
var textboxXPosition = textboxX + textXOffset[currentPage];
var textboxYPosition = textboxY;
#endregion

#region display options
if (totalNumberOfOptions > 0) { // short circuit to save some operations potentially	
    currentlySelectedOption += keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
    // If you would like, this is where you could put in logic to wrap around your options versus keeping them from moving past the top or bottom.
    currentlySelectedOption = clamp(currentlySelectedOption, 0, totalNumberOfOptions - 1);

    var isOnFinalPage = currentPage == totalNumberOfPages - 1;
    var isFinalPageFullyRendered = numberOfCharactersToDraw == textLength[currentPage];
    if (isFinalPageFullyRendered && isOnFinalPage) {
        var optionsXPosition = textboxXPosition + optionMarginToRenderCarat;

        for (var currentOption = 0; currentOption < totalNumberOfOptions; currentOption++) {
            var optionsYPosition = textboxYPosition - (optionSpacing * totalNumberOfOptions) + (optionSpacing * currentOption);
            var optionWidth = string_width(availableOptions[currentOption]) + (optionBorder * 2);
            // optionSpacing-3 gives you a little bit of breather between the options and is a good place to adjust if you don't like my spacing.
            draw_sprite_ext(textBackgroundSprite, 0, optionsXPosition, optionsYPosition, optionWidth / textBackgroundSpriteWidth, (optionSpacing - 3) / textBackgroundSpriteHeight, 0, c_white, 1);

            if (currentlySelectedOption == currentOption) {
                /*
                	The positioning of this will be influenced by how tall your textbox is.
                	To determine that look at your y scale for draw_sprite_ext, then multiply by that number by your sprite's original height.
                	The result of which is roughly how tall you want this caret sprite to be for it to look lined up. You might be able to use draw_sprite_ext to stretch your image.
                	That would come in handy if you used different fonts for different conversations. Don't forget to adjust optionMarginToRenderCarat in the create method to give yourself adequate space.
                	You could also potentially figure that out dynamically if you have different-sized fonts.
                */
                draw_sprite(sprTextboxArrow, 0, textboxXPosition, optionsYPosition);
            }
            draw_text(optionsXPosition + optionBorder, optionsYPosition + floor(border / 2), availableOptions[currentOption]);
        }
    }
}
#endregion

#region display the dialog text
// There is no point in drawing something if we have nothing to draw.
if (totalNumberOfPages > 0) {
    #region draw the background of the textbox
    draw_sprite_ext(textBackgroundSprite, 0, textboxXPosition, textboxYPosition, textboxWidth / textBackgroundSpriteWidth, textboxHeight / textBackgroundSpriteHeight, 0, c_white, 1);
    #endregion

    #region draw the dialog on the background
    var textToDraw = string_copy(npcTextArrayInOrder[currentPage], 1, numberOfCharactersToDraw);
    draw_text_ext(textboxXPosition + border, textboxYPosition + border, textToDraw, lineSpacing, maximumLineWidth);
    #endregion
}
#endregion