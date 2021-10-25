function populateSpeakerText(text) {
    if (is_undefined(currentPage) || is_undefined(npcTextArrayInOrder)) {
        show_debug_message("Objects attempting to have text populated should be aware of their current page, and an array in which to store the text.");
    }
    npcTextArrayInOrder[currentPage] = text;
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