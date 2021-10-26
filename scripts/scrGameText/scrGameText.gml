function scrGameText(textId = "") {
    switch (textId) {
		// I'm leaving this as not an enum since I have an idea to change this pretty dramtically I want to try later.
		// I think we might be able to add an option with a value like -1 to allow a conversation to continue or ooo.. possibly even circle back in the conversation?
		// We'll see later.
        case "npc 1":
            populateSpeakerText("Hi! I'm NPC 1. I've got humble beginnings but I think one day they're going to give me a name!");
            populateSpeakerText("Do you like video games?");
            addSpeakerOptions("Yeah - video games are the best", "npc 1 - yes");
            addSpeakerOptions("Nah - why?", "npc 1 - no");
            break;
        case "npc 1 - yes":
            populateSpeakerText("Me Too! My latest favorite is by this cool new developer. The title Hopeless is a bit odd though.");
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