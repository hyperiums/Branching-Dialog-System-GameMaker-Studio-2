enum speakerLocation { // doubles as a constant to flip the scale which makes it a bit more fragile. However, it does keep the code compact.
	onTheLeft = 1,
	onTheRight = -1,
};
enum characters {
	blueKid,
	greyKid,
	greyKidHappy,
	greenKid
}
function scrSetDefaultsForText(){
	#region line break information
	lineBreakPosition[0][currentPage] = 999;
	lineBreakNumber[currentPage] = 0;
	lineBreakOffset[currentPage] = 0;
	#endregion
	
	#region individual letter customization
	// You could optimize this to be called after populating the text to know programmatically how many characters there are.
	// This is quick and dirty, which means it'll be suboptimal.
	var maximumCharactersInTextBox = 500;
	for(var c = 0; c < maximumCharactersInTextBox; c++){
		fontColor1[c][currentPage] = c_black;
		fontColor2[c][currentPage] = c_black;
		fontColor3[c][currentPage] = c_black;
		fontColor4[c][currentPage] = c_black;
		floatText[c][currentPage] = false;
		floatDirection[c][currentPage] = c*20; // "randomized" degree of waviness
		shakeText[c][currentPage] = false;
		shakeDirection[c][currentPage] = irandom(360);
		shakeTimer[c][currentPage] = irandom(4);
	}
	#endregion
	
	#region speaker and background information	
	textBackgroundSprite[currentPage] = sprTextbox;
	speakerSprite[currentPage] = noone;
	speakerSide[currentPage] = undefined;
	#endregion
	
	fontColor[currentPage] = c_black;
	
	sound[currentPage] = -1;
}

/*
	Moves the x and y position in regular irregular intervals that for the characters specified to implement a shaking effect.
*/
function setSpeakerTextShake(startCharacterPosition, endCharacterPosition){
	for(var c = startCharacterPosition; c <= endCharacterPosition; c++){
		// currentPage-1 assumes you call this directly after calling populateSpeakerText
		shakeText[c][currentPage-1] = true;
	}
}

/*
	Moves the y position in regular intervals that appear wave like for the characters specified.
*/
function setSpeakerTextFloat(startCharacterPosition, endCharacterPosition){
	for(var c = startCharacterPosition; c <= endCharacterPosition; c++){
		// currentPage-1 assumes you call this directly after calling populateSpeakerText
		floatText[c][currentPage-1] = true;
	}
}

/*
  A fun idea to explore would be searching for sub strings in the previous page and setting the color on them instead of having to specify exact
  character positions. One problem you might run into there is "him him hit" would return three matches to "hi". There are ways around that if you wanted though.
*/
function setSpeakerTextColor(startCharacterPosition, endCharacterPosition, topLeftColor, topRightColor, bottomRightColor, bottomLeftColor){
	for(var c = startCharacterPosition; c <= endCharacterPosition; c++){
		// currentPage-1 assumes you call this directly after calling populateSpeakerText
		fontColor1[c][currentPage-1] = topLeftColor;
		fontColor2[c][currentPage-1] = topRightColor;
		fontColor3[c][currentPage-1] = bottomRightColor;
		fontColor4[c][currentPage-1] = bottomLeftColor;
	}
}

function populateSpeakerText(text, character = noone, side = undefined) {
    if (is_undefined(currentPage) || is_undefined(npcTextArrayInOrder)) {
        show_debug_message("Objects attempting to have text populated should be aware of their current page, and an array in which to store the text.");
    }
	scrSetDefaultsForText();
    npcTextArrayInOrder[currentPage] = text;
	if(character != noone && is_undefined(side)){
		side = speakerLocation.onTheLeft;	
	}
	switch(character){
		case characters.greyKid:
			speakerSprite[currentPage] = sprPlayerSpeak;
			textBackgroundSprite[currentPage] = sprTextboxGrey;
			fontColor[currentPage] = c_black;
			sound[currentPage] = slowTyping;
			break;
		case characters.greyKidHappy:
			speakerSprite[currentPage] = sprPlayerSpeakHappy;
			textBackgroundSprite[currentPage] = sprTextboxGrey;
			fontColor[currentPage] = c_black;
			sound[currentPage] = mediumTyping;
			break;
		case characters.greenKid:
			speakerSprite[currentPage] = sprGreenKidSpeakSassy;
			textBackgroundSprite[currentPage] = sprTextboxGreen;
			fontColor[currentPage] = c_black;
			sound[currentPage] = slowTyping;
			break;
	}
	speakerSide[currentPage] = side;
    currentPage++;
}

function addSpeakerOptions(optionText, linkId) {
    if (is_undefined(availableOptions) || is_undefined(totalNumberOfOptions) || is_undefined(optionLinkId)) {
        show_debug_message("We expect to have an array of options (availableOptions), where they should send the dialog to (optionLinkId), and a running count of our speaker's options (totalNumberOfOptions).");
    }
    // we're cheating a bit by using our current total to keep adding options
    availableOptions[totalNumberOfOptions] = optionText;
    optionLinkId[totalNumberOfOptions] = linkId;
    totalNumberOfOptions++;
}

function populateAndStartConversationById(textId) {
    if (is_undefined(objTextbox)) {
        show_debug_message("Without a textbox object, most of this code won't work. objTextbox is where most of our actual work takes place.");
    }
    with(instance_create_depth(0, 0, -100000, objTextbox)) {
        scrGameText(textId);
    }
}

