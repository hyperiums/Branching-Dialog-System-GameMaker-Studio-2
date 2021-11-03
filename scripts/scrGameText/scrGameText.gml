enum conversationPoints {
	npc1,
	npc1Yes,
	npc1No,
	npc2,
	npc3
}
function scrGameText(textId = "") {
    switch (textId) {
		// Doing the alternativeStartPage option by manually tying the option to the currentPage is brittle, but it works.
		// If you change the text order, the number would need to change.
        case conversationPoints.npc1:
			populateSpeakerText("Hi! I'm Blue Kid! I have important things to say.", characters.greyKid);
			setSpeakerTextColor(8, 15, c_blue, c_aqua, c_white, c_green);
			setSpeakerTextColor(25, 34, c_red, c_red, c_red, c_red);
			setSpeakerTextFloat(4, 17);
			setSpeakerTextShake(25, 34);
			populateSpeakerText("Hi Blue Kid! I bet you do, lay it on me!", characters.greenKid, speakerLocation.onTheRight);
            populateSpeakerText("Do you like video games? I do!", characters.greyKid);
            addSpeakerOptions("Yeah - video games are the best", conversationPoints.npc1Yes, 1);
            addSpeakerOptions("Nah - why?", conversationPoints.npc1, 3);
            addSpeakerOptions("Don't talk to me!", conversationPoints.npc1No);
			populateSpeakerText("We skipped forward to me! That's pretty nifty.", characters.greenKid, speakerLocation.onTheRight);
			addSpeakerOptions("Can we see EVERYTHING the yes guy has to say?", conversationPoints.npc1Yes);
			setSpeakerTextFloat(11, 21);
            break;
        case conversationPoints.npc1Yes:
            populateSpeakerText("Me Too! My latest favorite is by this cool new developer. The title Hopeless is a bit odd though.", characters.greyKidHappy);
            populateSpeakerText("Can we just start here? That would be so cool.", characters.greyKidHappy);
            break;
        case conversationPoints.npc1No:
            populateSpeakerText("bye felicia!");
            break;
        case conversationPoints.npc2:
            populateSpeakerText("H! I'm NPC 2. I have odd, punctionation, because! I. see ... things?");
            populateSpeakerText("H! I'm NPC 2 stillsies");
            break;
        case conversationPoints.npc3:
            populateSpeakerText("H! I'm NPC 3");
            break;
    }
}