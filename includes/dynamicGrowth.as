﻿/* Dynamic growth/weight systems for immobilzation! */

public function removeImmobilized():void
{
	eventBuffer += "\n\n" + logTimeStamp("good") + " <b>You’re no longer immobilized by your out-sized equipment!</b>";
	pc.removeStatusEffect("Endowment Immobilized");
}

// 4 levels, each to match the original ball growth stuff:
// [0] Egregious, [1] Ludicrous, [2] Overwhelming, [3] Immobilized!
// Length/Size Ratios: (for immobilization comparisons, average 5 ft person) Ex. - 5' person with M-cup for level 1 is [40/60] at position 0.
private var lvlRatioBalls:Array = [(9/60), (15/60), (25/60), (40/60)];
private var lvlRatioPenis:Array = [(9999/60), (9999/60), (9999/60), (9999/60)];
private var lvlRatioClits:Array = [(9999/60), (9999/60), (9999/60), (9999/60)];
private var lvlRatioBoobs:Array = [(9999/60), (9999/60), (9999/60), (9999/60)];
private var lvlRatioBelly:Array = [(9999/60), (9999/60), (9999/60), (9999/60)];
private var lvlRatioButts:Array = [(9999/60), (9999/60), (9999/60), (9999/60)];
// Threshold percentages for each level:
private var percentBalls:Array = [10, 25, 50, 100];
private var percentPenis:Array = [25, 50, 75, 100];
private var percentClits:Array = [25, 50, 75, 100];
private var percentBoobs:Array = [25, 50, 75, 100];
private var percentBelly:Array = [25, 50, 75, 100];
private var percentButts:Array = [25, 50, 75, 100];


/* General framework stuff */

public function immobilizedUpdate(count:Boolean = false):Number
{
	if(!pc.hasStatusEffect("Endowment Immobilized")) return 0;
	
	var bodyPart:Array = [];
	
	if(pc.balls > 0 && pc.weightQ("testicle") >= percentBalls[3] && pc.heightRatio("testicle") >= lvlRatioBalls[3]) bodyPart.push("balls");
	else if(pc.hasCock() && pc.weightQ("penis") >= percentPenis[3] && pc.heightRatio("penis") >= lvlRatioPenis[3]) bodyPart.push("cock");
	else if(pc.hasVagina() && pc.weightQ("clitoris") >= percentClits[3] && pc.heightRatio("clitoris") >= lvlRatioClits[3]) bodyPart.push("clit");
	else if(pc.hasBreasts() && pc.weightQ("breast") >= percentBoobs[3] && pc.heightRatio("breast") >= lvlRatioBoobs[3]) bodyPart.push("boobs");
	else if(pc.weightQ("belly") >= percentBelly[3] && pc.heightRatio("belly") >= lvlRatioBelly[3]) bodyPart.push("belly");
	else if(pc.weightQ("butt") >= percentButts[3] && pc.heightRatio("butt") >= lvlRatioButts[3]) bodyPart.push("butt");
	
	if(!count)
	{
		var msg:String = "";
		var bodyText: String = "";
		var partList:Array = [];
		
		// Hoverboard exception!
		if(pc.hasItem(new Hoverboard()))
		{
			eventBuffer += "\n\n" + logTimeStamp("passive") + " Your";
			if(bodyPart.length > 0)
			{
				if(InCollection("balls", bodyPart))
				{
					if(pc.balls == 1) partList.push("gigantic gonad");
					else partList.push("gigantic gonads");
				}
				if(InCollection("penis", bodyPart))
				{
					if(pc.cockTotal() == 1) partList.push("prodigious penis");
					else partList.push("prodigious penises");
				}
				if(InCollection("clit", bodyPart))
				{
					if(pc.totalClits() == 1) partList.push("colossal clit");
					else partList.push("colossal clits");
				}
				if(InCollection("boobs", bodyPart)) partList.push("titanic tits");
				if(InCollection("belly", bodyPart)) partList.push("bloated belly");
				if(InCollection("butt", bodyPart)) partList.push("epic ass cheeks");
				
				if (partList.length == 1) bodyText += partList[0];
				else
				{
					for (var x: int = 0; x < partList.length; x++)
					{
						bodyText += partList[x];
						
						if(partList.length == 2 && x == 0)
						{
							bodyText += " and ";
						}
						else if(x < partList.length - 2)
						{
							bodyText += ", ";
						}
						else if(x < partList.length - 1)
						{
							bodyText += ", and ";
						}
					}
				}
				eventBuffer += " " + bodyText;
			}
			else eventBuffer += " enormous body parts";
			eventBuffer += " make";
			if(InCollection(bodyText, "gigantic gonad", "bloated belly")) eventBuffer += "s";
			eventBuffer += " it impossible for you to move at all, you luckily have a remedy for that... Pulling out your pink hoverboard, you carefully guide it under your";
			if(bodyPart.length == 1)
			{
				if(bodyPart[0] == "balls") eventBuffer += ParseText(" [pc.sack]");
				else if(bodyPart[0] == "boobs") eventBuffer += ParseText(" [pc.chest]");
				else if(bodyPart[0] == "belly") eventBuffer += ParseText(" [pc.belly]");
				else if(bodyPart[0] == "butt") eventBuffer += ParseText(" [pc.butt]");
				else eventBuffer += " body";
			}
			else eventBuffer += " body";
			eventBuffer += ", relishing in the friction that’s cause by rubbing";
			if(bodyPart.length == 1 && bodyPart[0] == "boobs") eventBuffer += " them";
			else eventBuffer += " it";
			eventBuffer += " against the toy’s surface. With a few audible struggles, the hoverboard does its job and lifts your immobilizing weight off the ground! Now you can travel with ease... more or less.";
			
			removeImmobilized();
			pc.lust(5 * bodyPart.length);
		}
	}
	
	return bodyPart.length;
}

public function bodyPartUpdates(partName:String = "none"):void
{
	var weightQ:Number = pc.weightQ(partName);
	var heightQ:Number = pc.heightRatio(partName);
	
	if(pc.isGoo()) { /* Goos are immune to immobilization? */ }
	else
	{
		if(partName == "testicle" && pc.balls > 0)
		{
			//Hit basketball size >= 9
			if(weightQ >= percentBalls[0] && heightQ >= lvlRatioBalls[0] && !pc.hasStatusEffect("Egregiously Endowed"))
			{
				eventBuffer += "\n\n" + logTimeStamp("passive") + ParseText(" Ugh, you could really use a chance to offload some [pc.cumNoun]. You");
				if(pc.ballDiameter() >= 9 && pc.ballDiameter() < 12)
				{
					if(pc.balls == 1) eventBuffer += "r testicle has reached the size of a basketball and shows";
					else eventBuffer += "r balls have reached the size of basketballs and show";
				}
				else
				{
					if(pc.balls == 1) eventBuffer += " have " + pc.ballsDescript(true, true) + " and it shows";
					else eventBuffer += " have " + pc.ballsDescript(false, true) + " and they show";
				}
				eventBuffer += " no signs of stopping. The squishy, sensitive mass will definitely slow your movements.";
				
				//Status - Egregiously Endowed - Movement between rooms takes twice as long, and fleeing from combat is more difficult.
				pc.createStatusEffect("Egregiously Endowed", 0,0,0,0,false,"Icon_Poison", "Movement between rooms takes twice as long, and fleeing from combat is more difficult.", false, 0);
				pc.lust(5);
			}
			//Hit beachball size >= 15
			if(weightQ >= percentBalls[1] && heightQ >= lvlRatioBalls[1] && !pc.hasStatusEffect("Ludicrously Endowed"))
			{
				eventBuffer += "\n\n" + logTimeStamp("passive") + ParseText(" Every movement is accompanied by a symphony of sensation from your swollen nutsack, so engorged with [pc.cumNoun] that it wobbles from its own internal weight. You have to stop from time to time just to keep from being overwhelmed by your own liquid arousal.");
				
				pc.createStatusEffect("Ludicrously Endowed", 0,0,0,0,false,"Icon_Poison", "The shifting masses of your over-sized endowments cause you to gain fifty percent more lust over time.", false, 0);
				pc.lust(5);
			}
			//Hit barrel size
			if(weightQ >= percentBalls[2] && heightQ >= lvlRatioBalls[2] && !pc.hasStatusEffect("Overwhelmingly Endowed"))
			{
				eventBuffer += "\n\n" + logTimeStamp("passive") + " Whoah, this is awkward. Your";
				if(pc.balls == 1) eventBuffer += " testicle is";
				else eventBuffer += " nuts are";
				if(pc.ballDiameter() >= 25 && pc.ballDiameter() < 40) eventBuffer += " practically barrel-sized";
				else eventBuffer += " utterly massive";
				eventBuffer += "! If you aren’t careful,";
				if(pc.balls == 1) eventBuffer += " it";
				else eventBuffer += " they";
				eventBuffer += " drag softly on the ground. Grass is no longer scenery - it’s hundreds of slender tongues tickling your nut";
				if(pc.balls != 1) eventBuffer += "s";
				eventBuffer += ". Mud is an erotic massage. Even sand feels kind of good against your thickened sack, like a vigorous massage.";
				
				pc.createStatusEffect("Overwhelmingly Endowed", 0,0,0,0,false,"Icon_Poison", "The shifting masses of your over-sized endowments cause you to gain twice as much lust over time.", false, 0);
				pc.lust(5);
			}
			//hit person size
			if(weightQ >= percentBalls[3] && heightQ >= lvlRatioBalls[3] && !pc.hasStatusEffect("Endowment Immobilized") && !pc.hasItem(new Hoverboard()))
			{
				eventBuffer += "\n\n" + logTimeStamp("passive") + " You strain as hard as you can, but there’s just no helping it. You’re immobilized. Your";
				if(pc.balls == 1) eventBuffer += " testicle is";
				else eventBuffer += " balls are";
				eventBuffer += " just too swollen to allow you to move anywhere. The bulk of your body weight is right there in your";
				if(pc.balls == 1) eventBuffer += " sack";
				else eventBuffer += " testes";
				eventBuffer += ", and there’s nothing you can do about it.";
				if(canShrinkNuts()) eventBuffer += ".. well, almost nothing. A nice, long orgasm ought to fix this!";
				else 
				{
					if(eventQueue.indexOf(bigBallBadEnd) == -1) eventQueue.push(bigBallBadEnd);
					if(pc.hasPerk("'Nuki Nuts")) eventBuffer += " If a quick fap wasn’t illegal here, this would be far simpler. Too bad.";
				}
				pc.createStatusEffect("Endowment Immobilized", 0,0,0,0,false,"Icon_Poison", "Your endowments prevent you from moving.", false, 0);
				pc.lust(5);
			}
		}
		else if(partName == "penis")
		{
			/* 9999 */
		}
		else if(partName == "clitoris")
		{
			/* 9999 */
		}
		else if(partName == "breast")
		{
			/* 9999 */
		}
		else if(partName == "belly")
		{
			/* 9999 */
		}
		else if(partName == "butt")
		{
			/* 9999 */
		}
	}
	
	bodyPartCleanup(partName);
}

public function bodyPartCleanup(partName:String = "none"):void
{
	if(immobilizedUpdate(true) >= 1) return;
	
	var weightQ:Number = pc.weightQ(partName);
	var heightQ:Number = pc.heightRatio(partName);
	var lvlRatio:Array = [1, 1, 1, 1];
	var perRatio:Array = [0, 0, 0, 0];
	var altCheck:Boolean = false;
	
	switch (partName)
	{
		case "testicle":
			altCheck = (pc.balls <= 0);
			lvlRatio = lvlRatioBalls;
			perRatio = percentBalls;
			break;
		case "penis":
			altCheck = (!pc.hasCock());
			lvlRatio = lvlRatioPenis;
			perRatio = percentPenis;
			break;
		case "clitoris":
			altCheck = (!pc.hasVagina());
			lvlRatio = lvlRatioClits;
			perRatio = percentClits;
			break;
		case "breast":
			altCheck = (!pc.hasBreasts());
			lvlRatio = lvlRatioBoobs;
			perRatio = percentBoobs;
			break;
		case "belly":
			altCheck = (pc.bellyRating() <= 0);
			lvlRatio = lvlRatioBelly;
			perRatio = percentBelly;
			break;
		case "butt":
			altCheck = (pc.buttRating() <= 0);
			lvlRatio = lvlRatioButts;
			perRatio = percentButts;
			break;
	}
	
	if(pc.isGoo()) altCheck = true;
	
	if((altCheck || weightQ < perRatio[3] || heightQ < lvlRatio[3]) && pc.hasStatusEffect("Endowment Immobilized")) removeImmobilized();
	if((altCheck || weightQ < perRatio[2] || heightQ < lvlRatio[2])) pc.removeStatusEffect("Overwhelmingly Endowed");
	if((altCheck || weightQ < perRatio[1] || heightQ < lvlRatio[1])) pc.removeStatusEffect("Ludicrously Endowed");
	if((altCheck || weightQ < perRatio[0] || heightQ < lvlRatio[0])) pc.removeStatusEffect("Egregiously Endowed");
}


/* Nuts stuff! */

public function nutSwellUpdates():void
{
	bodyPartUpdates("testicle");
}

public function nutStatusCleanup():void
{
	bodyPartCleanup("testicle");
}

public function canShrinkNuts():Boolean
{
	//Can fap it away!
	if(pc.perkv1("'Nuki Nuts") > 0 && pc.canMasturbate())
	{
		//NO FAPS!
		if(rooms[currentLocation].hasFlag(GLOBAL.NOFAP)) return false;
		if(rooms[currentLocation].hasFlag(GLOBAL.FAPPING_ILLEGAL)) return false;
		return true;
	}
	return false;
}

public function bigBallBadEnd():void
{
	clearOutput();
	author("Fenoxo");
	//Dangerous area, can’t unswell:
	if(rooms[currentLocation].hasFlag(GLOBAL.HAZARD))
	{
		output("It isn’t long before the natives of this place take you as an amusement - a live-in toy whose virility is the show-piece of an alien exhibit. You never do manage to get your dad’s fortune, but hey, at least you get to live in relative comfort and have all the orgasms your body can handle.");
		
		days += 40 + rand(6);
		hours = rand(24);
		processTime(rand(60));
		
		for(var i:int = 0; i < 12; i++)
		{
			pc.orgasm();
		}
		
		badEnd();
	}
	//Not a dangerous area:
	else 
	{
		output("Eventually, you manage to get someone to pick you up and take you in for treatment. It isn’t cheap either. ");
		if(pc.credits >= 10000)
		{
			pc.credits -= 10000;
			output("Your finances are ");
			if(pc.credits < 1000) output("completely ");
			output("drained by your own libidinous foolishness, but at least you can move around normally again!");
		}
		else
		{
			pc.credits = 0;
			output("Your finances aren’t capable of footing the bill, but at least the medical experimentation that pays for it all isn’t too bad.");
			if(pc.biggestTitSize() >= 1 && rand(2) == 0 && pc.breastRows[0].breasts < 3) 
			{
				output(" A third breast is a small price to pay, after all.");
				pc.breastRows[0].breasts = 3;
			}
			else if(pc.balls < 3) 
			{
				output(" A trio of smaller nuts is a small price to pay, after all.");
				pc.balls = 3;
			}
		}
		pc.ballSizeRaw = 30;
		currentLocation = "SHIP INTERIOR";
		generateMap();
		processTime(1382);
		clearMenu();
		addButton(0, "Next", mainGameMenu);
	}
}


/* Hair stuff! */

public function maneHairGrow():void
{
	var lengthMin:Number = 3;
	
	if(pc.hairLength >= lengthMin) return;
	
	eventBuffer += "\n\n" + logTimeStamp("passive") + " Your scalp tingles and you";
	if (pc.hairLength <= 0)
	{
		eventBuffer += ParseText(" reach up to scratch it. Instead of [pc.skinFurScalesNoun], your fingers run across");
		if(pc.hairType == GLOBAL.HAIR_TYPE_REGULAR)
		{
			eventBuffer += " patches of growing hair.";
			pc.hairLength = 0.125;
		}
		else
		{
			eventBuffer += ParseText(" a growing patch of tiny [pc.hairsNoun].");
			pc.hairLength = 0.5;
		}
		eventBuffer += ParseText(" <b>You now have [pc.hair]!</b>");
	}
	else
	{
		var hairGain:Number = 1 + rand(2);
		if (pc.hairLength <= 2)
		{
			eventBuffer += ParseText(" reach up to touch your short [pc.hairNoun]. <b>It seems longer than it did before, growing out about " + num2Text(hairGain) + " more inch");
			if(hairGain != 1) eventBuffer += "es";
			eventBuffer += ".</b>";
		}
		else
		{
			eventBuffer += ParseText(" see your [pc.hairNoun] grow out, right in front of your eyes. <b>Your hair has lengthened by " + num2Text(hairGain) + " inch");
			if(hairGain != 1) eventBuffer += "es";
			eventBuffer += "!</b>";
		}
		pc.hairLength = Math.round(pc.hairLength + hairGain);
	}
	if(!InCollection(pc.hairStyle, ["null", "tentacle"]))
	{
		eventBuffer += " It seems the growth has messed up your hairdo in the process... You might have to get it restyled later.";
		pc.hairStyle = "null";
	}
}


/* Boobs stuff! */

public function honeyPotBump(cumShot:Boolean = false):void
{
	var msg:String = "";
	
	if(pc.thickness >= 30)
	{
		pc.thickness -= 10;
		var boobDiff:Number = 10;
		if(pc.thickness >= 60)
		{
			boobDiff += 10;
			pc.thickness -= 10;
		}
		boobDiff /= 10;
		
		eventBuffer += "\n\n" + logTimeStamp("passive") + ParseText(" Your body tightens as the honeypot gene goes to work, diverting your excess bodymass into your [pc.chest], building you bigger and fuller of [pc.milkNoun].");
		
		for(var bb:int = 0; bb < pc.bRows(); bb++)
		{
			pc.breastRows[bb].breastRatingHoneypotMod += boobDiff;
		}
		if(pc.milkFullness < 100) pc.milkFullness = 100;
	}
	else if(pc.breastRows[0].breastRatingHoneypotMod == 0)
	{
		msg += "\n\n" + logTimeStamp("passive") + ParseText(" Your [pc.chest] feel");
		if(!pc.hasBreasts()) msg += "s";
		msg += " bigger than normal, swollen ";
		if(cumShot) msg += "from all the oral calories you’ve taken in.";
		else msg += "with the spare calories your honeypot gene has siphoned off of your meals.";
	}
	else if(pc.breastRows[0].breastRatingHoneypotMod < 10 && pc.breastRows[0].breastRatingHoneypotMod+1 >= 10)
	{
		msg += "\n\n" + logTimeStamp("passive") + ParseText(" Your [pc.chest] practically glow");
		if(!pc.hasBreasts()) msg += "s";
		msg += " with the ever-expanding fruit of your honeypot gene. You wonder just how big you’ll get.";
	}
	else if(pc.breastRows[0].breastRatingHoneypotMod < 20 && pc.breastRows[0].breastRatingHoneypotMod+1 >= 20)
	{
		msg += "\n\n" + logTimeStamp("passive") + ParseText(" Sometimes when you move, your [pc.arm] sends your liquid-filled [pc.chest] bouncing. You can feel as much as hear the fluid churning inside, ready to be released into your hands, the ground, or a passersby’s open mouth.");
	}
	else if(pc.breastRows[0].breastRatingHoneypotMod < 30 && pc.breastRows[0].breastRatingHoneypotMod+1 >= 30)
	{
		msg += "\n\n" + logTimeStamp("passive") + ParseText(" Every movement is accompanied by a weighty, sloshing jiggle from your [pc.chest]. The more you take in, the more like a gold myr honeypot you seem, growing until you seem more boob than ") + pc.mfn("man","woman","person") + ".";
	}
	else if(pc.breastRows[0].breastRatingHoneypotMod < 40 && pc.breastRows[0].breastRatingHoneypotMod+1 >= 40)
	{
		msg += "\n\n" + logTimeStamp("passive") + ParseText(" Wherever you go, the eyes of every single passing sapient zero in on your [pc.chest].");
		if(!pc.hasBreasts()) msg += " It juts";
		else msg += " They jut";
		msg += ParseText(" from your body like the proud prow of a deep space freighter, filled with a glorious [pc.milkFlavor] bounty. If only they knew - if only they could sense just how great it would be to take your [pc.nipple] in your mouth and suck. An all too pleasurable shudder wracks your spine at the thought.");
	}
	else if(pc.breastRows[0].breastRatingHoneypotMod < 50 && pc.breastRows[0].breastRatingHoneypotMod+1 >= 50)
	{
		msg += "\n\n" + logTimeStamp("passive") + ParseText(" It’s tough not to toddle forward off your [pc.feet] and onto your [pc.milkNoun]-engorged chest. The pressure would probably release a tide of [pc.milkFlavor] juice and still barely put a dent in your super-sized knockers. The honeypot gene is so amazing, the way it makes your body so fruitful... You’ve got to share this beautiful bosom with the galaxy!");
	}
	//Bump up boob size for 3 days of eating or a cumshot!
	for(var cc:int = 0; cc < pc.bRows(); cc++)
	{
		pc.breastRows[cc].breastRatingHoneypotMod += 1;
		//Drinking cum refills milk most of the way
		if(cumShot) if(pc.milkFullness < 81) pc.milkFullness = 81;
	}
	
	if(msg.length > 0) eventBuffer += msg;
}

//Notes about milk gain increases
public function milkGainNotes():void
{
	var x:int = 0;
	//Cross 75% milk fullness +1 cup
	//This doubles past F-cup
	if(pc.hasStatusEffect("Pending Gain Milk Note: 75"))
	{
		//Bump size!
		for(x = 0; x < pc.bRows(); x++)
		{
			if(pc.breastRows[x].breastRatingRaw >= 5) pc.breastRows[x].breastRatingLactationMod = 1.5;
			else pc.breastRows[x].breastRatingLactationMod = 1;
		}

		eventBuffer += "\n\n" + logTimeStamp("passive") + ParseText(" There’s no way you could miss how your [pc.fullChest] have swollen up with [pc.milk]. You figure it won’t be long before they’re completely full. It might be a good idea to milk them soon. <b>With all that extra weight, ");
		if(pc.bRows() > 1) eventBuffer += "the top row is ";
		else eventBuffer += "they’re ";
		eventBuffer += ParseText("currently [pc.breastCupSize]s");
		if(pc.bRows() > 1) eventBuffer += ", and the others are similarly swollen";
		eventBuffer += ".</b>";
		pc.removeStatusEffect("Pending Gain Milk Note: 75");
	}
	//Cross 100% milk fullness + 1.5 cups
	//This doubles past F-cup
	if(pc.hasStatusEffect("Pending Gain Milk Note: 100"))
	{
		//Bump size!
		for(x = 0; x < pc.bRows(); x++)
		{
			if(pc.breastRows[x].breastRatingRaw >= 5) pc.breastRows[x].breastRatingLactationMod = 2.5;
			else pc.breastRows[x].breastRatingLactationMod = 1.5;
		}
		eventBuffer += "\n\n" + logTimeStamp("passive") + ParseText(" Your [pc.fullChest] feel more than a little sore. They’re totally and unapologetically swollen with [pc.milk]. You heft the [pc.breastCupSize]s and sigh, swearing you can almost hear them slosh. <b>They’re totally full.</b>");
		pc.removeStatusEffect("Pending Gain Milk Note: 100");
	}
	//Cross 150% milk fullness + 2 cups
	//This doubles past F-cup
	if(pc.hasStatusEffect("Pending Gain Milk Note: 150"))
	{
		//Bump size!
		for(x = 0; x < pc.bRows(); x++)
		{
			if(pc.breastRows[x].breastRatingRaw >= 5) pc.breastRows[x].breastRatingLactationMod = 3.5;
			else pc.breastRows[x].breastRatingLactationMod = 2;
		}
		
		eventBuffer += "\n\n" + logTimeStamp("passive") + ParseText(" Your [pc.nipples] are extraordinarily puffy at the moment, practically suffused with your neglected [pc.milk]. It’s actually getting kind of painful to hold in all that liquid weight, and if ");
		if(pc.hasPerk("Milky") || pc.hasPerk("Treated Milk")) eventBuffer += "it wasn’t for your genetically engineered super-tits, your body would be slowing down production";
		else if(pc.hasPerk("Honeypot")) eventBuffer += "it wasn’t for your honeypot gene, your body would be slowing down production";
		else if(pc.isPregnant()) eventBuffer += "you weren’t pregnant, you’d probably be slowing production.";
		else if(pc.upperUndergarment is BountyBra) eventBuffer += "you weren’t wearing a <b>Bounty Bra</b>, your body would be slowing down production";
		else eventBuffer += "you don’t take care of it soon, a loss of production is likely";
		eventBuffer += ParseText(". Right now, they’re swollen up to [pc.breastCupSize]s.");
		pc.removeStatusEffect("Pending Gain Milk Note: 150");
	}
	//Hit 200% milk fullness cap + 3 cups
	//This doubles past F-cup
	if(pc.hasStatusEffect("Pending Gain Milk Note: 200"))
	{
		//Bump size!
		for(x = 0; x < pc.bRows(); x++)
		{
			if(pc.breastRows[x].breastRatingRaw >= 5) pc.breastRows[x].breastRatingLactationMod = 4.5;
			else pc.breastRows[x].breastRatingLactationMod = 3;
		}
		
		eventBuffer += "\n\n" + logTimeStamp("passive") + ParseText(" The tightness in your [pc.fullChest] is almost overwhelming. You feel so full – so achingly stuffed – that every movement is a torture of breast-swelling delirium. You can’t help but wish for relief or a cessation of your lactation, whichever comes first. ");
		if(pc.hasPerk("Milky") || pc.hasPerk("Treated Milk")) eventBuffer += "<b>However, with your excessively active udders, you are afraid the production will never stop.</b>";
		else if(pc.hasPerk("Honeypot")) eventBuffer += "<b>However, with your honeypot gene, they’ll likely never stop.</b>";
		else if(pc.isPregnant()) eventBuffer += "<b>With a pregnancy on the way, there’s no way your body will stop producing.</b>";
		else if(pc.upperUndergarment is BountyBra) eventBuffer += ParseText("<b>Your Bounty Bra will keep your [pc.fullChest] producing despite the uncomfortable fullness.</b>");
		else eventBuffer += ParseText("<b>If you don’t tend to them, your [pc.breastCupSize]s will stop producing [pc.milk].</b>");
		pc.removeStatusEffect("Pending Gain Milk Note: 200");
	}
}

public function lactationUpdateHourTick():void
{
	//These are easy since they proc with time passage and can be added to event buffer.
	//Milk Multiplier crosses a 10 point threshold while dropping
	//Drops .5 an hour above 150 fullness. 1 above 200 fullness
	//Milk Rate drops by .1 an hour above 200.
	var originalMultiplier:Number = pc.milkMultiplier;
	//Bounty bra never loses milkMultiplier!
	if(pc.upperUndergarment is BountyBra || pc.isPregnant() || pc.hasPerk("Honeypot") || pc.hasPerk("Mega Milk") || pc.hasPerk("Hypermilky"))
	{

	}
	else
	{
		if(pc.milkFullness >= 200) 
		{
			if (pc.hasPerk("Milky") && pc.hasPerk("Treated Milk")) { }
			else if(pc.hasPerk("Milky") || pc.hasPerk("Treated Milk")) pc.milkMultiplier -= .2;
			else pc.milkMultiplier -= 1;
		}
		else if(pc.milkFullness >= 150) 
		{
			if(!pc.hasPerk("Milky") && !pc.hasPerk("Treated Milk")) pc.milkMultiplier -= .5;
		}
	}
	//Drops a tiny amount if below 50.
	if(pc.milkMultiplier < 50 && !(pc.upperUndergarment is BountyBra) && !pc.isPregnant() && !pc.hasPerk("Honeypot") && !pc.hasPerk("Mega Milk") && !pc.hasPerk("Hypermilky")) {
		if(pc.hasPerk("Milky") && pc.hasPerk("Treated Milk")) {}
		else if(pc.hasPerk("Milky") || pc.hasPerk("Treated Milk")) pc.milkMultiplier -= .02;
		else pc.milkMultiplier -= 0.1;

		if(!pc.hasPerk("Milky")) pc.milkMultiplier -= 0.1;
		else pc.milkMultiplier -= 0.02;
		if(pc.milkFullness > 0) 
		{
			pc.milkFullness -= 1;
			if(pc.milkFullness < 0) pc.milkFullness = 0;
		}
	}
	if(pc.milkMultiplier < 0) pc.milkMultiplier = 0;
	//90
	if(pc.milkMultiplier < 90 && originalMultiplier >= 90) eventBuffer += "\n\n" + logTimeStamp("passive") + " You’re pretty sure that your lactation is starting to slow down a little bit. If you don’t start milking yourself, you’ll eventually stop producing.";
	//80
	if(pc.milkMultiplier < 80 && originalMultiplier >= 80) eventBuffer += "\n\n" + logTimeStamp("passive") + ParseText(" Low level tingles in your [pc.chest] remind you that producing [pc.milk] is something your body does, but if you keep ignoring yourself, you won’t for too much longer.");
	//70
	if(pc.milkMultiplier < 70 && originalMultiplier >= 70) eventBuffer += "\n\n" + logTimeStamp("passive") + ParseText(" You’re feeling pretty sore in your [pc.chest], but it’s not getting that much worse. <b>You’re pretty sure that you’re lactating less as a result of the inattention to your chest.</b>");
	//60	
	if(pc.milkMultiplier < 60 && originalMultiplier >= 60) eventBuffer += "\n\n" + logTimeStamp("passive") + ParseText(" Your body’s ability to produce [pc.milk] is diminishing to the point where your [pc.fullChest] are barely making any more. It won’t take long before you stop production entirely.");
	//50
	if(pc.milkMultiplier < 50 && originalMultiplier >= 50) {
		for(var x:int = 0; x < pc.bRows(); x++)
		{
			pc.breastRows[x].breastRatingLactationMod = 0;
		}
		eventBuffer += "\n\n" + logTimeStamp("passive") + ParseText(" Like a switch has been flipped inside you, you feel your body’s [pc.milk]-factories power down. <b>You’ve stopped lactating entirely.</b>");
		if(pc.milkFullness >= 75) 
		{
			eventBuffer += ParseText(" The swelling from your over-filled [pc.fullChest] goes down as well, leaving you with [pc.breastCupSize]s.");
			pc.milkFullness = 75;
		}
	}
	//Clean up boob size stuff
	pc.setBoobSwelling();
}

//Milk Multiplier crosses a 10 point threshold from raising
public function milkMultiplierGainNotificationCheck():void
{
	var msg:String = "";
	
	//kGAMECLASS cheat to cheat these messages into the event buffer? Or pass event buffer as an argument? Regardless, seems the cleanest way to keep it from interrupting the scene it gets called in.
	//30
	if(pc.hasStatusEffect("Pending Gain MilkMultiplier Note: 30")) {
		msg += "\n\n" + logTimeStamp("passive") + ParseText(" The soreness in your [pc.nipples] is both persistent and pleasant in its own unique way. There’s no disguising how it makes your [pc.chest] practically glow with warmth.");
		pc.removeStatusEffect("Pending Gain MilkMultiplier Note: 30");
	}
	//40
	if(pc.hasStatusEffect("Pending Gain MilkMultiplier Note: 40")) {
		msg += "\n\n" + logTimeStamp("passive") + ParseText(" Tingles run through your [pc.fullChest] every now and again. Your [pc.nipples] even feel moist. Perhaps you’ll start lactating soon?");
		pc.removeStatusEffect("Pending Gain MilkMultiplier Note: 40");
	}
	//50
	if(pc.hasStatusEffect("Pending Gain MilkMultiplier Note: 50")) {
		msg += "\n\n" + logTimeStamp("passive") + ParseText(" A single droplet of [pc.milk] escapes from one of your [pc.nipples]");
		if(pc.isChestGarbed()) msg += ParseText(", staining your [pc.upperGarments] [pc.milkColor]");
		msg += ". <b>You’re lactating</b>, albeit slowly.";
		pc.removeStatusEffect("Pending Gain MilkMultiplier Note: 50");
	}
	//60
	if(pc.hasStatusEffect("Pending Gain MilkMultiplier Note: 60")) {
		msg += "\n\n" + logTimeStamp("passive") + ParseText(" Judging by the feelings in your [pc.fullChest], you can safely say that you’re making [pc.milk] faster than before. Is that what ");
		if(pc.hasPregnancy()) msg += "it feels like to be an expectant mother?";
		else msg += "expectant mothers feel like?";
		pc.removeStatusEffect("Pending Gain MilkMultiplier Note: 60");
	}
	//70
	if(pc.hasStatusEffect("Pending Gain MilkMultiplier Note: 70")) {
		msg += "\n\n" + logTimeStamp("passive") + " You’re pretty sure you’re lactating even more now. As a matter of fact, a scan by your codex confirms it. Your body is producing a decent amount of milk, perhaps a little under half its maximum capability.";
		pc.removeStatusEffect("Pending Gain MilkMultiplier Note: 70");
	}
	//80
	if(pc.hasStatusEffect("Pending Gain MilkMultiplier Note: 80")) {
		msg += "\n\n" + logTimeStamp("passive") + ParseText(" Heat suffuses your chest, just another indication that your [pc.fullChest] have passed a new threshold of productivity. You’re definitely lactating harder.");
		pc.removeStatusEffect("Pending Gain MilkMultiplier Note: 80");
	}
	//90
	if(pc.hasStatusEffect("Pending Gain MilkMultiplier Note: 90")) {
		msg += "\n\n" + logTimeStamp("passive") + ParseText(" There’s no doubt about how bountiful your [pc.fullChest] are feeling, swollen with potential just waiting to be milked out so that they can produce more. <b>You’re getting close to having your body as trained for lactation as possible.</b>");
		pc.removeStatusEffect("Pending Gain MilkMultiplier Note: 90");
	}
	//100
	if(pc.hasStatusEffect("Pending Gain MilkMultiplier Note: 100")) {
		msg += "\n\n" + logTimeStamp("passive") + ParseText(" A wonderful, productive feeling swells in your [pc.fullChest], tingling hotly. A quick scan with your codex reports that your body is making [pc.milk] at its full capacity.");
		pc.removeStatusEffect("Pending Gain MilkMultiplier Note: 100");
	}
	//110
	if(pc.hasStatusEffect("Pending Gain MilkMultiplier Note: 110")) {
		msg += "\n\n" + logTimeStamp("passive") + ParseText(" Somehow, your body is adapting to all the milking its been put through, and your [pc.fullChest] feel more powerful and fecund than ever before. Your chest is a well-trained milking machine.");
		pc.removeStatusEffect("Pending Gain MilkMultiplier Note: 110");
	}
	//125
	if(pc.hasStatusEffect("Pending Gain MilkMultiplier Note: 125")) {
		msg += "\n\n" + logTimeStamp("passive") + ParseText(" Your chest is practically singing in delight, and the only thing it sings about is [pc.milk] - rivers of never ending, liquid flows that will spill from you unceasingly. You have trained them to lactate as well as anything can be trained. If you want to make any more [pc.milk], you’ll have to grow your [pc.fullChest] bigger or turn to science.");
		pc.removeStatusEffect("Pending Gain MilkMultiplier Note: 125");
	}
	if(msg.length > 0) eventBuffer += msg;
}


/* Butt stuff! */

public function buttslutBootyGrow():void
{
	var bootyMin:Number = 18;
	
	// If butt is max size or is currently filled, no need to grow.
	if(pc.buttRatingRaw >= bootyMin || pc.statusEffectv1("Anally-Filled") > 0) return;
	
	var oldBooty:Number = pc.buttRatingRaw;
	var addBooty:Number = 1 + rand(9);
	if(pc.buttRatingRaw + addBooty > bootyMin) addBooty = bootyMin - pc.buttRatingRaw;
	if(addBooty < 0) return;
	
	eventBuffer += "\n\n" + logTimeStamp("passive") + " You notice some extra weight and jiggle when you go to move or stand. Looking behind you, you find that your ass has gained";
	if (addBooty > 5) eventBuffer += " an epic amount of cheek";
	else if (addBooty > 4) eventBuffer += " a massive surge in size";
	else if (addBooty > 3) eventBuffer += " a much larger circumference";
	else if (addBooty > 2) eventBuffer += " a few sizes";
	else if (addBooty > 1) eventBuffer += " a another size or two";
	else eventBuffer += " some mass";
	eventBuffer += ParseText("... It seems your bubbly booty refuses to be any smaller" + (pc.buttRatingRaw < 10 ? " than that." : "--not that you’d complain!") + " <b>Your [pc.butts] have grown bigger!</b>");
	
	pc.buttRatingRaw += addBooty;
	
	if(pc.hairType == GLOBAL.HAIR_TYPE_GOO && addBooty > 0)
	{
		var gooCost:Number = (20 * addBooty);
		if(gooCost > 0 && gooBiomass() >= gooCost)
		{
			eventBuffer += " Although, the growth took up some of your gooey biomass in the process...";
			gooBiomass(-1 * gooCost);
		}
	}
}

