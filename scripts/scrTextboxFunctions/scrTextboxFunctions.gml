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
	// meant to manually store where we want line breaks
	lineBreakPosition[0][currentPage] = 999;
	lineBreakNumber[currentPage] = 0;
	lineBreakOffset[currentPage] = 0;
	textBackgroundSprite[currentPage] = sprTextbox;
	speakerSprite[currentPage] = noone;
	speakerSide[currentPage] = undefined;
	fontColor[currentPage] = c_black;
	sound[currentPage] = -1;
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

