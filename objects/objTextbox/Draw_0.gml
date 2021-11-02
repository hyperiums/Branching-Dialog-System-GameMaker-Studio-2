// making sure setupRan allows us to avoid auto scrolling a new page of text when someone comes here from a dialog choice if the space key is still technically pressed.
acceptKey = setupRan && keyboard_check_pressed(vk_space);

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
    draw_set_valign(fa_top);
    draw_set_halign(fa_left);


    totalNumberOfPages = array_length(npcTextArrayInOrder);

    for (var p = 0; p < totalNumberOfPages; p++) {
        textLength[p] = string_length(npcTextArrayInOrder[p]);
		// all of these values were arrived at by play testing. They will be different in your implementation.
		switch(speakerSide[p]){
			case speakerLocation.onTheLeft:
				textXOffset[p] = 112;
				portraitXOffset[p] = 24;
				break;
			case speakerLocation.onTheRight:
				textXOffset[p] = 24;
				portraitXOffset[p] = 312;
				break;
			default:
				// This roughly centers textbox on our screen screen without a character speaking.
				textXOffset[p] = 72;
				portraitXOffset[p] = -1; // not used
				break;
		}
		
		#region calculate where to insert line breaks and where to draw each character
		// setting individual characters and finding where the lines of text should break
		for(var c = 0; c < textLength[p]; c++){
			var characterPosition = c + 1;
			
			// store individual characters in the characters array
			characters[c][p] = string_char_at(npcTextArrayInOrder[p], characterPosition);
			
			// get current width of line
			var textUpToChar = string_copy(npcTextArrayInOrder[p], 1, characterPosition);
			var currentTextWidth = string_width(textUpToChar) - string_width(characters[c][p]);
			
			// get the last free space
			var characterToLookFor = " "; // in case you don't like ending on spaces :)
			if(characters[c][p]==" ") {
				lastSeenSpacePosition = characterPosition + string_length(characterToLookFor);
			}
			
			// get the line breaks
			var currentTextIsGreaterThanAvailableWidth = currentTextWidth - lineBreakOffset[p] > maximumLineWidth;
			if(currentTextIsGreaterThanAvailableWidth){
				/*
					Assuming our maximum line width could only hold "Hi!" of the string "Hi! I'm NPC 1.", we're essentially going to grab "Hi! I"
					Then manipulate the string for the offset down to just "Hi! ", this prevents us from starting the next line with a space.
					
					Another possible improvement here is inserting line breaks into the string, then drawing the string in one go if you run into performance issues.
					However, this system is explicitly designed to support DRAMA in your dialog presentation layer, so that's for another tutorial.
				*/ 
				lineBreakPosition[lineBreakNumber[p]][p] = lastSeenSpacePosition;
				lineBreakNumber[p]++;
				var textUpToLastSpace = string_copy(npcTextArrayInOrder[p], 1, lastSeenSpacePosition);
				var lastFreeSpaceString = string_char_at(npcTextArrayInOrder[p], lastSeenSpacePosition);
				lineBreakOffset[p] = string_width(textUpToLastSpace) - string_width(lastFreeSpaceString);
			}
		}
		// getting each characters coordinates
		for(var c = 0; c < textLength[p]; c++){
			var characterPosition = c + 1;
			var textX = textboxX + textXOffset[p] + border;
			var textY = textboxY + border;
			
			// get current width of line
			var textUpToChar = string_copy(npcTextArrayInOrder[p], 1, characterPosition);
			var currentTextWidth = string_width(textUpToChar) - string_width(characters[c][p]);
			
			var textLine = 0;
			
			// compensate for string breaks
			for(var lineBreak = 0; lineBreak < lineBreakNumber[p]; lineBreak++){
				if(characterPosition >= lineBreakPosition[lineBreak][p]){
					var strCopy = string_copy(npcTextArrayInOrder[p], lineBreakPosition[lineBreak][p], characterPosition - lineBreakPosition[lineBreak][p]);
					currentTextWidth = string_width(strCopy);
					textLine = lineBreak + 1;
				}
			}
			// add to the x and y coordinates based on the new info
			characterXCoords[c][p] = textX + currentTextWidth;
			characterYCoords[c][p]= textY + textLine * lineSpacing;
		}
			
		#endregion
    }
	
    currentPage = 0;
    setupRan = true;
}

#region calculate how may characters to draw of our current page
if(textPauseTimer <= 0){
	if (numberOfCharactersToDraw < textLength[currentPage]) {
	    numberOfCharactersToDraw += textSpeed;
	    // prevent overflow for faster typing speeds
	    numberOfCharactersToDraw = clamp(numberOfCharactersToDraw, 0, textLength[currentPage]);
		var checkChar = string_char_at(npcTextArrayInOrder[currentPage], numberOfCharactersToDraw);
		if(checkChar == "." || checkChar == "," || checkChar == "!" || checkChar == "?"){
			textPauseTimer = textPauseTime;
		}
		/* 
			There's no reason for this to be inside if the textPauseTimer check with our implementation.
			However, if you started with a pause, I could see it being necessary, so I left it here.
			Also, if you wanted to have punctuation do a special sound effect, then you'd want to change this to an else if.
		*/
		if(sound[currentPage] != -1){
			if(soundCount < soundDelay){
				soundCount++;
			}else{
				soundCount = 0;
				currentlyPlayingSound = audio_play_sound(sound[currentPage], 8, false);
			}
		}
	}
}else{
	textPauseTimer--;	
}
var stopAudioIfTypingDone = numberOfCharactersToDraw >= textLength[currentPage] && currentlyPlayingSound != -1;
if(stopAudioIfTypingDone){
	audio_stop_sound(currentlyPlayingSound);
	soundCount = soundDelay;
	currentlyPlayingSound = -1;
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
draw_set_color(fontColor[currentPage]);
textBackgroundSpriteWidth = sprite_get_width(textBackgroundSprite[currentPage]);
textBackgroundSpriteHeight = sprite_get_height(textBackgroundSprite[currentPage]);
var textboxXPosition = textboxX + textXOffset[currentPage];
var textboxYPosition = textboxY;
textBackgroundImage += textBackgroundImageSpeed;
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
            draw_sprite_ext(textBackgroundSprite[currentPage], textBackgroundImage, optionsXPosition, optionsYPosition, optionWidth / textBackgroundSpriteWidth, (optionSpacing - 3) / textBackgroundSpriteHeight, 0, c_white, 1);

            if (currentlySelectedOption == currentOption) {
                /*
                	The positioning of this will be influenced by how tall your textbox is.
                	To determine that look at your y scale for draw_sprite_ext, then multiply by that number by your sprite's original height.
                	The result of which is roughly how tall you want this caret sprite to be for it to look lined up. You might be able to use draw_sprite_ext to stretch your image.
                	That would come in handy if you used different fonts for different conversations. Don't forget to adjust optionMarginToRenderCarat in the create method to give yourself adequate space.
                	You could also potentially figure that out dynamically if you have different-sized fonts.
                */
                draw_sprite(sprTextboxArrow, textBackgroundImage, textboxXPosition, optionsYPosition);
            }
            draw_text(optionsXPosition + optionBorder, optionsYPosition + floor(border / 2), availableOptions[currentOption]);
        }
    }
}
#endregion

#region display the dialog text
// There is no point in drawing something if we have nothing to draw.
if (totalNumberOfPages > 0) {
	#region draw the speaker
	if(speakerSprite[currentPage] != noone){
		sprite_index = speakerSprite[currentPage];
		var isDoneRenderingCurrentPage = numberOfCharactersToDraw == textLength;
		if(isDoneRenderingCurrentPage){
			image_index = 0; // stop animating the speaker, if your speaker is animated. Mine isn't.
		}
		var speakerXPosition = textboxX + portraitXOffset[currentPage];
		if(speakerSide[currentPage]==speakerLocation.onTheRight){
			// Done to account for flipping the sprite.
			speakerXPosition += sprite_width;
		}
		draw_sprite_ext(textBackgroundSprite[currentPage], textBackgroundImage, textboxX + portraitXOffset[currentPage], textboxY, sprite_width / textBackgroundSpriteWidth, sprite_height / textBackgroundSpriteHeight, 0 , c_white, 1);
		draw_sprite_ext(sprite_index, image_index, speakerXPosition, textboxY, speakerSide[currentPage], 1, 0, c_white, 1);
	}
	#endregion
    #region draw the background of the textbox
    draw_sprite_ext(textBackgroundSprite[currentPage], textBackgroundImage, textboxXPosition, textboxYPosition, textboxWidth / textBackgroundSpriteWidth, textboxHeight / textBackgroundSpriteHeight, 0, c_white, 1);
    #endregion

    #region draw the dialog on the background
	for(var c = 0; c < numberOfCharactersToDraw; c++){
		draw_text(characterXCoords[c][currentPage], characterYCoords[c][currentPage], characters[c][currentPage]);
	}
	#endregion
}
#endregion