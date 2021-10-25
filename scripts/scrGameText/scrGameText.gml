function scrGameText(textId = "") {
    switch (textId) {
		// I'm leaving this as not an enum since I have an idea to change this pretty dramtically I want to try later.
        case "npc 1":
            populateSpeakerText("H! I'm NPC 1");
            populateSpeakerText("Do you like video games?");
            addSpeakerOptions("Yeah - video games are the best", "npc 1 - yes");
            addSpeakerOptions("Nah - why?", "npc 1 - no");
            break;
        case "npc 1 - yes":
            populateSpeakerText("Me Too!");
            break;
        case "npc 1 - no":
            populateSpeakerText("bye felicia!");
            break;
        case "npc 2":
            populateSpeakerText("H! I'm NPC 2");
            populateSpeakerText("H! I'm NPC 2 stillsies");
            break;
        case "npc 3":
            populateSpeakerText("H! I'm NPC 3");
            break;
    }
}