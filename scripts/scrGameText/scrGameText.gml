function scrGameText(textId = "") {
    switch (textId) {
		// I'm leaving this as not an enum since I have an idea to change this pretty dramtically I want to try later.
		// I think we might be able to add an option with a value like -1 to allow a conversation to continue or ooo.. possibly even circle back in the conversation?
		// We'll see later.
        case "npc 1":
			populateSpeakerText("Hi! I'm Blue Kid! I have important things to say.", characters.greyKid);
			setSpeakerTextColor(8, 15, c_blue, c_aqua, c_white, c_green);
			setSpeakerTextColor(25, 34, c_red, c_red, c_red, c_red);
			setSpeakerTextFloat(4, 17);
			setSpeakerTextShake(25, 34);
			populateSpeakerText("Hi Blue Kid! I bet you do, lay it on me!", characters.greenKid, speakerLocation.onTheRight);
            populateSpeakerText("Do you like video games? I do!", characters.greyKid);
            addSpeakerOptions("Yeah - video games are the best", "npc 1 - yes");
            addSpeakerOptions("Nah - why?", "npc 1 - no");
            break;
        case "npc 1 - yes":
            populateSpeakerText("Me Too! My latest favorite is by this cool new developer. The title Hopeless is a bit odd though.", characters.greyKidHappy);
            break;
        case "npc 1 - no":
            populateSpeakerText("bye felicia!");
            break;
        case "npc 2":
            populateSpeakerText("H! I'm NPC 2. I have odd, punctionation, because! I. see ... things?");
            populateSpeakerText("H! I'm NPC 2 stillsies");
            break;
        case "npc 3":
            populateSpeakerText("H! I'm NPC 3");
            break;
    }
}