#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force

#Include json.ahk

; All constants:
PoeNinja:=["https://poe.ninja/api/data/CurrencyOverview?league=Archnemesis&type=Currency", "https://poe.ninja/api/data/CurrencyOverview?league=Archnemesis&type=Fragment", "https://poe.ninja/api/data/itemoverview?league=Archnemesis&type=Invitation", "https://poe.ninja/api/data/itemoverview?league=Archnemesis&type=Incubator", "https://poe.ninja/api/data/itemoverview?league=Archnemesis&type=DeliriumOrb",  "https://poe.ninja/api/data/itemoverview?league=Archnemesis&type=Scarab", "https://poe.ninja/api/data/itemoverview?league=Archnemesis&type=Fossil", "https://poe.ninja/api/data/itemoverview?league=Archnemesis&type=Oil","https://poe.ninja/api/data/itemoverview?league=Archnemesis&type=DivinationCard","https://poe.ninja/api/data/itemoverview?league=Archnemesis&type=Essence","https://poe.ninja/api/data/itemoverview?league=Archnemesis&type=Resonator"]

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; CenterKoef := 1.3
; PowerKoef := Max(CenterKoef-1, ln(500)-CenterKoef)
MaxChaos := 100
MaxExalt := 5
MaxCountStack :=80
sellPriceGlobalChaos := -1
sellPriceGlobalExalt := -1
sdvigPriceBuy = -0.2
sdvigPriceSell = 0.05
MinChaosProfit :=2
Debug := false

ExaltPrice := 130

skipData := ["eternal", "prime-regrading-lens", "transmute"]

stackData := {regret:15, chaos:10, exalted:10, divine:3, alch:10, alt:20, regal:10, vaal:10, chisel:20, mirror:1, scour:30, gcp:10, chance:10, chrome:20, fusing:20, jewellers: 20, silver: 30, blessed: 20, bauble: 20, aug: 30, annul: 5}
stackData["mirror-shard"] := 5
stackData["mavens-orb"] := 5

; Temporary
stackData["transmute"] := 5
stackData["wisdom"] := 5
stackData["portal"] := 5
stackData["whetstone"] := 5
stackData["scrap"] := 5
stackData["eternal"] := 5
stackData["dusk"] := 5
stackData["mid"] := 5
stackData["dawn"] := 5
stackData["noon"] := 5
stackData["grie"] := 5
stackData["rage"] := 5
stackData["ign"] := 5
stackData["hope"] := 5
stackData["eber"] := 5
stackData["yriel"] := 5
stackData["inya"] := 5
stackData["volkuur"] := 5
stackData["hydra"] := 5
stackData["phoenix"] := 5
stackData["minot"] := 5
stackData["chimer"] := 5
stackData["offer"] := 5
stackData["stacked-deck"] := 5
stackData["simple-sextant"] := 5
stackData["prime-sextant"] := 5
stackData["awakened-sextant"] := 5
stackData["sacrifice-set"] := 5
stackData["mortal-set"] := 5
stackData["pale-court-set"] := 5
stackData["blessing-xoph"] := 5
stackData["blessing-tul"] := 5
stackData["blessing-esh"] := 5
stackData["blessing-uul-netol"] := 5
stackData["blessing-chayula"] := 5
stackData["xophs-breachstone"] := 5
stackData["tuls-breachstone"] := 5
stackData["eshs-breachstone"] := 5
stackData["uul-breachstone"] := 5
stackData["chayulas-breachstone"] := 5
stackData["ancient-reliquary-key"] := 5
stackData["divine-vessel"] := 5
stackData["orb-of-binding"] := 5
stackData["orb-of-horizons"] := 5
stackData["harbingers-orb"] := 5
stackData["engineers"] := 5
stackData["ancient-orb"] := 10
stackData["timeworn-reliquary-key"] := 5
stackData["xophs-charged-breachstone"] := 5
stackData["tuls-charged-breachstone"] := 5
stackData["eshs-charged-breachstone"] := 5
stackData["uul-charged-breachstone"] := 5
stackData["chayulas-charged-breachstone"] := 5
stackData["xophs-enriched-breachstone"] := 5
stackData["tuls-enriched-breachstone"] := 5
stackData["eshs-enriched-breachstone"] := 5
stackData["uul-enriched-breachstone"] := 5
stackData["chayulas-enriched-breachstone"] := 5
stackData["xophs-pure-breachstone"] := 5
stackData["tuls-pure-breachstone"] := 5
stackData["eshs-pure-breachstone"] := 5
stackData["uul-pure-breachstone"] := 5
stackData["chayulas-pure-breachstone"] := 5
stackData["timeless-karui-emblem"] := 5
stackData["timeless-maraketh-emblem"] := 5
stackData["timeless-eternal-emblem"] := 5
stackData["timeless-templar-emblem"] := 5
stackData["timeless-vaal-emblem"] := 5
stackData["fragment-of-enslavement"] := 1
stackData["fragment-of-eradication"] := 1
stackData["fragment-of-constriction"] := 1
stackData["fragment-of-purification"] := 1
stackData["fragment-of-shape"] := 5
stackData["fragment-of-knowledge"] := 5
stackData["fragment-of-terror"] := 5
stackData["fragment-of-emptiness"] := 5
stackData["awakeners-orb"] := 5
stackData["crusaders-exalted-orb"] := 5
stackData["redeemers-exalted-orb"] := 5
stackData["hunters-exalted-orb"] := 5
stackData["warlords-exalted-orb"] := 5
stackData["turbulent-catalyst"] := 5
stackData["imbued-catalyst"] := 5
stackData["abrasive-catalyst"] := 5
stackData["tempering-catalyst"] := 5
stackData["fertile-catalyst"] := 5
stackData["prismatic-catalyst"] := 5
stackData["intrinsic-catalyst"] := 5
stackData["simulacrum"] := 5
stackData["offer-tribute"] := 5
stackData["offer-dedication"] := 5
stackData["offer-gift"] := 5
stackData["prime-regrading-lens"] := 5
stackData["secondary-regrading-lens"] := 5
stackData["tempering-orb"] := 5
stackData["tailoring-orb"] := 5
stackData["rogues-marker"] := 5
stackData["ritual-vessel"] := 5
stackData["elevated-sextant"] := 5
stackData["orb-of-unmaking"] := 40
stackData["the-mavens-writ"] := 5
stackData["vaal-reliquary-key"] := 5
stackData["veiled-chaos-orb"] := 5
stackData["noxious-catalyst"] := 5
stackData["accelerating-catalyst"] := 5
stackData["unstable-catalyst"] := 5
stackData["xophs-flawless-breachstone"] := 5
stackData["tuls-flawless-breachstone"] := 5
stackData["eshs-flawless-breachstone"] := 5
stackData["uul-flawless-breachstone"] := 5
stackData["chayulas-flawless-breachstone"] := 5
stackData["uber-timeless-karui-emblem"] := 5
stackData["uber-timeless-maraketh-emblem"] := 5
stackData["uber-timeless-eternal-emblem"] := 5
stackData["uber-timeless-templar-emblem"] := 5
stackData["uber-timeless-vaal-emblem"] := 5
stackData["sacred-orb"] := 5
stackData["infused-engineers-orb"] := 5
stackData["enkindling-orb"] := 10
stackData["instilling-orb"] := 10
stackData["mirror-shard"] := 1
stackData["exalted-shard"] := 10
stackData["annulment-shard"] := 10
stackData["splinter-xoph"] := 10
stackData["splinter-tul"] := 10
stackData["splinter-esh"] := 10
stackData["splinter-uul"] := 10
stackData["splinter-chayula"] := 10
stackData["timeless-eternal-empire-splinter"] := 5
stackData["timeless-karui-splinter"] := 5
stackData["timeless-vaal-splinter"] := 5
stackData["timeless-templar-splinter"] := 5
stackData["timeless-maraketh-splinter"] := 5
stackData["simulacrum-splinter"] := 5
stackData["crescent-splinter"] := 5
stackData["tainted-chromatic-orb"] := 5
stackData["tainted-orb-of-fusing"] := 5
stackData["tainted-jewellers-orb"] := 5
stackData["tainted-chaos-orb"] := 5
stackData["tainted-exalted-orb"] := 5
stackData["tainted-mythic-orb"] := 5
stackData["tainted-armourers-scrap"] := 5
stackData["tainted-blacksmiths-whetstone"] := 5
stackData["tainted-divine-teardrop"] := 10
stackData["tainted-blessing"] := 10
stackData["tradeId"] := 5
stackData["tradeId"] := 5


tradeIdData := {}
tradeIdData["Ritual"] := "ritual"
tradeIdData["Splinter of Chayula"] := "splinter-chayula"
tradeIdData["Mirror Shard"] := "mirror-shard"
tradeIdData["Annulment Shard"] := "annulment-shard"
tradeIdData["Exalted Shard"] := "exalted-shard"
tradeIdData["Binding Shard"] := "binding-shard"
tradeIdData["Horizon Shard"] := "horizon-shard"
tradeIdData["Harbinger's Shard"] := "harbingers-shard"
tradeIdData["Engineer's Shard"] := "engineers-shard"
tradeIdData["Ancient Shard"] := "ancient-shard"
tradeIdData["Chaos Shard"] := "chaos-shard"
tradeIdData["Regal Shard"] := "regal-shard"
tradeIdData["Splinter of Xoph"] := "splinter-xoph"
tradeIdData["Splinter of Tul"] := "splinter-tul"
tradeIdData["Splinter of Esh"] := "splinter-esh"
tradeIdData["Splinter of Uul-Netol"] := "splinter-uul"
tradeIdData["Splinter of Chayula"] := "splinter-chayula"
tradeIdData["Timeless Eternal Empire Splinter"] := "timeless-eternal-empire-splinter"
tradeIdData["Timeless Karui Splinter"] := "timeless-karui-splinter"
tradeIdData["Timeless Vaal Splinter"] := "timeless-vaal-splinter"
tradeIdData["Timeless Templar Splinter"] := "timeless-templar-splinter"
tradeIdData["Timeless Maraketh Splinter"] := "timeless-maraketh-splinter"
tradeIdData["Simulacrum Splinter"] := "simulacrum-splinter"
tradeIdData["Crescent Splinter"] := "crescent-splinter"
tradeIdData["Ritual Splinter"] := "ritual-splinter"
tradeIdData["Tainted Chromatic Orb"] := "tainted-chromatic-orb"
tradeIdData["Tainted Orb of Fusing"] := "tainted-orb-of-fusing"
tradeIdData["Tainted Jeweller's Orb"] := "tainted-jewellers-orb"
tradeIdData["Tainted Chaos Orb"] := "tainted-chaos-orb"
tradeIdData["Tainted Exalted Orb"] := "tainted-exalted-orb"
tradeIdData["Tainted Mythic Orb"] := "tainted-mythic-orb"
tradeIdData["Tainted Armourer's Scrap"] := "tainted-armourers-scrap"
tradeIdData["Tainted Blacksmith's Whetstone"] := "tainted-blacksmiths-whetstone"
tradeIdData["Tainted Divine Teardrop"] := "tainted-divine-teardrop"
tradeIdData["Tainted Blessing"] := "tainted-blessing"
tradeIdData["Eldritch Exalted Orb"] := "eldritch-exalted-orb"
tradeIdData["Eldritch Orb of Annulment"] := "eldritch-orb-of-annulment"
tradeIdData["Lesser Eldritch Ember"] := "lesser-eldritch-ember"
tradeIdData["Greater Eldritch Ember"] := "greater-eldritch-ember"
tradeIdData["Grand Eldritch Ember"] := "grand-eldritch-ember"
tradeIdData["Exceptional Eldritch Ember"] := "exceptional-eldritch-ember"
tradeIdData["Lesser Eldritch Ichor"] := "lesser-eldritch-ichor"
tradeIdData["Greater Eldritch Ichor"] := "greater-eldritch-ichor"
tradeIdData["Grand Eldritch Ichor"] := "grand-eldritch-ichor"
tradeIdData["Exceptional Eldritch Ichor"] := "exceptional-eldritch-ichor"
tradeIdData["Surveyor's Compass"] := "surveyors-compass"
tradeIdData["Charged Compass"] := "charged-compass"
tradeIdData["Eldritch Chaos Orb"] := "eldritch-chaos-orb"
tradeIdData["Eldritch Exalted Orb"] := "eldritch-exalted-orb"
tradeIdData["Eldritch Orb of Annulment"] := "eldritch-orb-of-annulment"
tradeIdData["Lesser Eldritch Ember"] := "lesser-eldritch-ember"
tradeIdData["Greater Eldritch Ember"] := "greater-eldritch-ember"
tradeIdData["Grand Eldritch Ember"] := "grand-eldritch-ember"
tradeIdData["Exceptional Eldritch Ember"] := "exceptional-eldritch-ember"
tradeIdData["Lesser Eldritch Ichor"] := "lesser-eldritch-ichor"
tradeIdData["Greater Eldritch Ichor"] := "greater-eldritch-ichor"
tradeIdData["Grand Eldritch Ichor"] := "grand-eldritch-ichor"
tradeIdData["Exceptional Eldritch Ichor"] := "exceptional-eldritch-ichor"
tradeIdData["Orb of Conflict"] := "orb-of-conflict"
tradeIdData["Maven's Orb"] := "mavens-orb"
tradeIdData["Orb of Dominance"] := "mavens-orb"
tradeIdData["Fine Delirium Orb"] := "fine-delirium-orb"
tradeIdData["Singular Delirium Orb"] := "singular-delirium-orb"
tradeIdData["Thaumaturge's Delirium Orb"] := "thaumaturges-delirium-orb"
tradeIdData["Blacksmith's Delirium Orb"] := "blacksmiths-delirium-orb"
tradeIdData["Armoursmith's Delirium Orb"] := "armoursmiths-delirium-orb"
tradeIdData["Cartographer's Delirium Orb"] := "cartographers-delirium-orb"
tradeIdData["Jeweller's Delirium Orb"] := "jewellers-delirium-orb"
tradeIdData["Abyssal Delirium Orb"] := "abyssal-delirium-orb"
tradeIdData["Kalguuran Delirium Orb"] := "kalguuran-delirium-orb"
tradeIdData["Foreboding Delirium Orb"] := "foreboding-delirium-orb"
tradeIdData["Obscured Delirium Orb"] := "obscured-delirium-orb"
tradeIdData["Whispering Delirium Orb"] := "whispering-delirium-orb"
tradeIdData["Fragmented Delirium Orb"] := "fragmented-delirium-orb"
tradeIdData["Skittering Delirium Orb"] := "skittering-delirium-orb"
tradeIdData["Fossilised Delirium Orb"] := "fossilised-delirium-orb"
tradeIdData["Fine Delirium Orb"] := "portentous-delirium-orb"
tradeIdData["Diviner's Delirium Orb"] := "diviners-delirium-orb"
tradeIdData["Delirium Orb"] := "delirium-orb"
tradeIdData["Primal Delirium Orb"] := "primal-delirium-orb"
tradeIdData["Imperial Delirium Orb"] := "imperial-delirium-orb"
tradeIdData["Timeless Delirium Orb"] := "timeless-delirium-orb"
tradeIdData["Blighted Delirium Orb"] := "blighted-delirium-orb"
tradeIdData["Amorphous Delirium Orb"] := "amorphous-delirium-orb"
tradeIdData["Amorphous Delirium Orb"] := "amorphous-delirium-orb"
tradeIdData["Clear Oil"] := "clear-oil"
tradeIdData["Sepia Oil"] := "sepia-oil"
tradeIdData["Amber Oil"] := "amber-oil"
tradeIdData["Verdant Oil"] := "verdant-oil"
tradeIdData["Teal Oil"] := "teal-oil"
tradeIdData["Azure Oil"] := "azure-oil"
tradeIdData["Indigo Oil"] := "indigo-oil"
tradeIdData["Violet Oil"] := "violet-oil"
tradeIdData["Crimson Oil"] := "crimson-oil"
tradeIdData["Black Oil"] := "black-oil"
tradeIdData["Opalescent Oil"] := "opalescent-oil"
tradeIdData["Silver Oil"] := "silver-oil"
tradeIdData["Golden Oil"] := "golden-oil"
tradeIdData["Tainted Oil"] := "tainted-oil"
tradeIdData["Oil Extractor"] := "oil-extractor"
tradeIdData["Prime Sextant"] := "prime-sextant"
tradeIdData["Singular Scouting Report"] := "singular-scouting-report"
tradeIdData["Otherworldly Scouting Report"] := "otherworldly-scouting-report"
tradeIdData["Comprehensive Scouting Report"] := "comprehensive-scouting-report"
tradeIdData["Vaal Scouting Report"] := "vaal-scouting-report"
tradeIdData["Delirious Scouting Report"] := "delirious-scouting-report"
tradeIdData["Operative's Scouting Report"] := "operatives-scouting-report"
tradeIdData["Blighted Scouting Report"] := "blighted-scouting-report"
tradeIdData["Influenced Scouting Report"] := "influenced-scouting-report"
tradeIdData["Explorer's Scouting Report"] := "explorers-scouting-report"
tradeIdData["Silver Coin"] := "silver"


priceData := {}
listBuyCurrencyChaos := []
listBuyCurrencyExalt := []
numChaos := 0
numExalt := 0
listEssense := []

GetKeyItemInList(item, list)
{
	; MsgBox, %item%!
   For k, v in list
   {
	; MsgBox, %item%`n%v%
      if (v = item)
         return k
   }
   return false
}

AddTablePrice(js){
	global tradeIdData
	global stackData
	global skipData
	global priceData
	global listBuyCurrencyChaos
	global listBuyCurrencyExalt
	global listEssense
	For currency, cData in js.lines {
		cName       := cData.currencyTypeName
		if (cName = "")
			cName := cData.name
		tradeId := ""
		cName2 := ""
		For currency2, cData2 in js.currencyDetails
		{
			cName2       := cData2.name
			if (cName2 = cName)
			{
				tradeId:=cData2["tradeId"]
				break
			}
		}
		if (cName2 = "")
			tradeId := cData["detailsId"]
		if (tradeId = "")
			tradeId:=tradeIdData[cName2]
		if (tradeId = "")
			throw "Don't have trade Id with name " . cName
		
		if (RegExMatch(tradeId, "essence") <> 0)
			listEssense.Push(cName)
			
		tHave := 100
		tStack := stackData[tradeId]
		if (tStack > 0)
		{
		}else{
			; throw "Don't have stack count with name " . cName
			tStack = 10
		}
		cData["tradeId"] := tradeId
			
		CountStack := tHave / tStack
		KoefLn := Ln(1+CountStack)
		cData := GetIdealPrice(cData, KoefLn)

		if (cData.wantBuyPrice > cData.wantSellPrice){
			throw "Wrong Price" . cName . "`nBuy:" . cData.wantBuyPrice . "`nSell:" . cData.wantSellPrice
		}

		priceSellChaos := MatchGoodDivideSell(cData.MinCountCurrency, tStack, cData.wantSellPrice, 0)
		priceSellExalt := MatchGoodDivideSell(cData.MinCountCurrency, tStack, cData.wantSellPrice, 1)
		priceSellExaltFrac := GetGoodFracSell(cData.wantSellPrice)
		priceBuyChaos := MatchGoodDivideBuy(cData.MinCountCurrency, tStack, cData.wantBuyPrice, 0)
		priceBuyExalt := MatchGoodDivideBuy(cData.MinCountCurrency, tStack, cData.wantBuyPrice, 1)
		
		if ((priceSellChaos["get"]>0)and (priceSellChaos["receive"]>0)){
			priceSellChaosText := "~price " . priceSellChaos["get"] . "/" . priceSellChaos["receive"] . " chaos"
		}else{
			priceSellChaosText := "~skip"
		}
		if ((priceSellExalt["get"]>0)and (priceSellExalt["receive"]>0)){
			priceSellExaltText := "~price " . priceSellExalt["get"] . "/" . priceSellExalt["receive"] . " exalted"
		}else{
			priceSellExaltText := "~skip"
		}			
		if (priceSellExaltFrac>0.1){
			priceSellExaltFracText := "~price " . priceSellExaltFrac . " exalted"
		}else{
			priceSellExaltFracText := "~skip"
		}			
		if ((priceBuyChaos["get"]>0)and (priceBuyChaos["receive"]>0)){
			priceBuyChaosText := "~price " . priceBuyChaos["get"] . "/" . priceBuyChaos["receive"] . " " . cData.tradeId
		}else{
			priceBuyChaosText := "~skip"
		}		
		if ((priceBuyExalt["get"]>0)and (priceBuyExalt["receive"]>0)){
			priceBuyExaltText := "~price " . priceBuyExalt["get"] . "/" . priceBuyExalt["receive"] . " " . cData.tradeId
		}else{
			priceBuyExaltText := "~skip"
		}		
	
		priceData[cName] := {priceSellChaos:priceSellChaosText, priceSellExalt:priceSellExaltText, priceSellExaltFrac:priceSellExaltFracText, priceBuyChaos:priceBuyChaosText, priceBuyExalt:priceBuyExaltText}
		
		if (GetKeyItemInList(cData.tradeId, skipData) <> false)
		{
		}else{
			if (priceBuyChaosText != "~skip")
				listBuyCurrencyChaos.Push(priceBuyChaosText)
			if (priceBuyChaosText != "~skip")
				listBuyCurrencyExalt.Push(priceBuyExaltText)
		}
	}
}

UpdateTableForShards(){
	
}

CreateTablePrice(){
	global PoeNinja
	TempFile := "temp.json"
	
	For index, value in PoeNinja
	{			
		FileDelete %TempFile% 
		UrlDownloadToFile, %value%, %TempFile%
		if ErrorLevel
		{
		}
		else
		{
			FC := FileOpen(TempFile, "r")
			Price := FC.Read()
			parsedJSON := JSON.Load(Price)
			AddTablePrice(parsedJSON)
		}
	}
	
	UpdateTableForShards()
}

CreateTablePrice()

CreateNotePrice(text){
	MouseGetPos OutputVarX, OutputVarY
	MouseXDiff = -100
	if (OutputVarX < 140)
	{
		MouseXDiff := 40-OutputVarX
	}
	Click, Rel 0, 0 Right
	
	LeftTime = 1000
	
	ClickX := OutputVarX+MouseXDiff
	ClickY := OutputVarY+80
	ClickXCheck := ClickX-10
	ClickYCheck := ClickY+20
	PixelGetColor, BeforeColor, %ClickXCheck%, %ClickYCheck%
	
	while(LeftTime>0)
	{
		Sleep 140
		Click, %ClickX%, %ClickY%
		Sleep 100
		PixelGetColor,AfterColor, %ClickXCheck%, %ClickYCheck%
		; ToolTip, %BeforeColor%`n%AfterColor%, 0, 0
		; Sleep 2000
		if (BeforeColor = AfterColor){
			LeftTime := LeftTime - 240
		}else{
			break
		}
	}
	
	if (LeftTime < 0)
	{
		ToolTip, Can't open set price.%text% in clipboard, 0, 0
		clipboard := text
		return
	}
	; ToolTip, Click Rel 0 0 Right, 0, 0
	; Sleep 400
	
	
	
	
	; ToolTip, %BeforeColor%, 0, 0
	; Sleep 2000
	
	; Click, Rel %MouseXDiff%, 80 Left ; , Down
	; ToolTip, Click Rel %MouseXDiff% 80 Left, 0, 0
	; Sleep 400
	
	; PixelGetColor,AfterColor, OutputVarX+MouseXDiff, OutputVarY+100
	; ToolTip, %AfterColor%, 0, 0
	; Sleep 2000
	
	Send {Down}{Up}{Up}{Up}{Up}
	; ToolTip, Send {Down}{Up}{Up}{Up}{Up} , 0, 0
	Sleep 100
	Send {Enter}
	; ToolTip, Send {Enter} , 0, 0
	Sleep 100
	Send {Tab}
	; ToolTip, Send {Tab} , 0, 0
	Sleep 100
	Send, %text%
	; ToolTip, Send %text% , 0, 0
	Sleep, 100
	Send {Enter}

	MouseMove,  OutputVarX, OutputVarY

	ToolTip, Complete!, 0, 0
	
	SetTimer, HideMessage, -2500
}

GetCurrentItem(){
	clipboard := ""
	Send ^c
	ClipWait, 1
	if ErrorLevel
	{
		ToolTip, Can't define. Return from function, 0, 0
		return ""
	}
	return clipboard
}

GetInfoFromClipboard(text){
	last = ""
	Loop, parse, text, `n, `r
	{		
		if (A_Index = 3)
		{
			; NewName := StrReplace(A_LoopField, "'", "\\u0027")
			; ToolTip, %A_LoopField%`n%NewName%, 0, 0
			name = %A_LoopField%
		}
		if (RegExMatch(A_LoopField, "Note:")>0)
			last = %A_LoopField%
	}
	return {name: name, price: SubStr(last, 7)}
}



SearchInJSON(js, iName){

	; ToolTip, %js%`n%iName%, 0, 0
	For currency, cData in js.lines {
		cName       := cData.currencyTypeName
		if (cName <> iName)
		{
			continue
		}
		For currency2, cData2 in js.currencyDetails 
		{
			cName2       := cData2.name
				; ToolTip, %cName2%, 0, 0
			if (cName2 = cName)
			{
				tt:=cData2["tradeId"]
				; MsgBox, %tt%
				cData["tradeId"]:=cData2.tradeId
				return cData
			}
		}
	}
	return {tradeId:0}
}

; {"id":60221,"name":"Winged Abyss Scarab","stackSize":10,"itemClass":0,,"chaosValue":96.87,"exaltedValue":0.64,"count":99,"detailsId":"winged-abyss-scarab","listingCount":445}

GetIdealPrice(objData, KoefLn){
	global MinChaosProfit
	global CenterKoef
	global PowerKoef
	global sdvigPriceBuy
	global sdvigPriceSell
	
	chaosP := objData.chaosEquivalent
	if (chaosP = ""){
		chaosP := objData.chaosValue
		objData.chaosEquivalent := objData.chaosValue
	}
	; if (chaosP > 0)
	; {}else{
		; chaosP := objData.chaosValue
	; }
	
	if (objData.pay.pay_currency_id = 1)
	{
		if (objData.pay.value > 0){
			buyPrice := Min(objData.pay.value, chaosP*(1+sdvigPriceBuy))
		}else{
			buyPrice := chaosP*(1+sdvigPriceBuy)		
		}
	} else
	{
		if (objData.pay.value > 0){
			buyPrice := Min(1/objData.pay.value, chaosP*(1+sdvigPriceBuy))
		}else{
			buyPrice := chaosP*(1+sdvigPriceBuy)		
		}
	}
	if (objData.receive.pay_currency_id = 1)
	{
		if (objData.receive.value > 0){
			sellPrice := Max(objData.receive.value, (1+sdvigPriceSell)*chaosP)
		}else{
			sellPrice := (1+sdvigPriceSell)*chaosP
		}
	} else
	{
		if (objData.receive.value > 0){
			sellPrice := Max(1/objData.receive.value, (1+sdvigPriceSell)*chaosP)
		}else{
			sellPrice := (1+sdvigPriceSell)*chaosP
		}
	}
	
	
	; BD := (chaosP / buyPrice) ** (1/PowerKoef)
	; SD := (chaosP / sellPrice) ** (1/PowerKoef)
	wantBuyPrice := buyPrice ; / BD
	wantSellPrice := sellPrice ; / SD
	diffPrice := wantSellPrice - wantBuyPrice
	MinCountCurrency := MinChaosProfit	/	diffPrice
	; if (objData.currencyTypeName = "Sacred Orb")
		; MsgBox, buyPrice`t%buyPrice%`n sellPrice`t%sellPrice%`n BD`t%BD%`n SD`t%SD%`n wantBuyPrice`t%wantBuyPrice%`n wantSellPrice`t%wantSellPrice%`n diffPrice`t%diffPrice%`n MinCountCurrency`t%MinCountCurrency%`n  KoefLn`t%KoefLn%`n  CenterKoef`t%CenterKoef%`n 
	
	objData["wantBuyPrice"] := wantBuyPrice
	objData["wantSellPrice"] := wantSellPrice
	objData["MinCountCurrency"] := MinCountCurrency
	
	return objData
}


MatchGoodDivideSell(MinCountCurrency, iStack, wantSellPrice, isExalt){
; receive chaos or exalt
	global MaxCountStack
	global ExaltPrice
	
	; MsgBox, MinCountCurrency`t %MinCountCurrency% `n iStack`t %iStack% `n wantSellPrice`t %wantSellPrice% `n isExalt`t %isExalt% `n 
	
	isell	:=	10000
	ia := 0
	ib := 0
	if (isExalt){
		SizeLoopSell := MaxCountStack*iStack
		MinCountCurrencyInner := 2*MinCountCurrency
		wantSellPriceInner := wantSellPrice/ExaltPrice
	}else{
		SizeLoopSell := 2*iStack
		MinCountCurrencyInner := MinCountCurrency
		wantSellPriceInner := wantSellPrice
	}
	
	Loop, %SizeLoopSell%
	{
		if (A_Index<MinCountCurrencyInner)
		{
			continue
		}
		ta	:=	Ceil(wantSellPriceInner * A_Index)
		tsell := ta/A_Index
		if (ta>MaxCountStack*iStack)
		{
			break
		}
		if (tsell < isell)
		{
			ia := ta
			ib := A_Index
			isell := tsell
		}
	}
	return {get:ia, receive:ib}
}

GetGoodFracSell(wantSellPrice){
	global ExaltPrice
	temp := Ceil(wantSellPrice*10/ExaltPrice)
	big := Floor(temp/10)
	small := temp-big*10
	res = %big%.%small%
	return res
}


MatchGoodDivideBuy(MinCountCurrency, iStack, wantBuyPrice, isExalt){
; receive currency
	global MaxCountStack
	global ExaltPrice
	global MaxChaos
	global MaxExalt
	ibuy	:=	-1
	ic := 0
	idd := 0
	if (isExalt){
		SizeLoopSell := MaxCountStack*iStack
		MinCountCurrencyInner := 2*MinCountCurrency
		wantBuyPriceInner := wantBuyPrice/ExaltPrice
		MaxCount := MaxExalt
	}else{
		SizeLoopSell := 2*iStack
		MinCountCurrencyInner := MinCountCurrency
		wantBuyPriceInner := wantBuyPrice
		MaxCount := MaxChaos
	}
	Loop, %SizeLoopSell%
	{
		if (A_Index<MinCountCurrencyInner)
		{
			continue
		}
		tc	:=	Floor(wantBuyPriceInner * A_Index)
		tbuy := tc/A_Index
		if (tc>MaxCount)
		{
			break
		}
		if (tbuy > ibuy)
		{
			ic := tc
			idd := A_Index
			ibuy := tbuy
		}
	}
	return {get: idd, receive: ic}
}

DefineLastPrice(textPrice){

	; ToolTip, %textPrice%, 0, 0
	if (RegExMatch(textPrice, "~") = 0)
		return 3
	; ToolTip, %textPrice%, 0, 0
	if (RegExMatch(textPrice, "chaos") > 0)
		return 1
	; ToolTip, %textPrice%, 0, 0
	if (RegExMatch(textPrice, "\.") > 0)
		return 2
	; ToolTip, %textPrice%, 0, 0
	return 3
}

ToolTip, Поиск в инвентаре комлектов`nКамни`nСписок желания - сортировать по нужной осколки сделать зависящие от целого`nCкипать ненужные позиции`nИ раз в минуту - проверять есть ли запросы которые выгоднее моих закупок`nВ том числе и на гадальных картах`nНо здесь уже надо учитывать высокие позиции`nИ для легендарных ребят тоже надо.`nВ скрипте должна быть настройка - насколько сильно я хочу продавать и покупать`nЦену за экзальт должно считать автоматически а не константой в скрипте.`nУказывать мою сумму хаосов которую я могу тратить - закупка не должна быть выше этой суммы`nСверка цен входящих - по позиции покажи ожидаемое количество на отдачу`nИгнорируй и вставляй надпись NFT? Или со скипом так?  `nИспользуй БД PoE с github`nХрани настройки`nЧисти временные файлы за собой`nОценка карт и камней`nПо билду из PoB - какие мне нужны камни где их купить и какие умения выбирать на дереве`nСоставление для живого поиска из PoB нужные для билда вещи и хорошей торговли`nДля билдов вести расчёт соотношения атаки и защиты 1/1 - стекло 2/1 - норма 3/1 - танк`nРабота с вкладками?`nДля комплектов поиск излишков, которые можно не страшно продать`nНа клавишу global 820`nТипо биржевые сводки, чтобы видеть где есть выгодное. Возможно сразу с кнопками заказа или перехода на онлайн поиск`nПросто показать цену без установки`nУказывать желаемую кратность в дробях`nTooltip разделять на поток сообщений который проматчвается и выбором таймера уровня логов и т.д.`nУчесть для масел, осколков и эсенций что они превращаемые`nАвтовитрину считать по моей сумме денег - до 1/14 части и по выгодности торовли, 0, 0

SetTimer, HideMessage, -5000

F2::
	if (!WinActive("Path of Exile"))
		return
	
	readItem := GetCurrentItem()
	if (readItem = "")
		return
	
	infoCur := GetInfoFromClipboard(readItem)	
	nameCur := infoCur.name
	
	if (nameCur = "Exalted Orb"){
		if (RegExMatch(infoCur.price, listBuyCurrencyExalt[numExalt+1])>0)
			numExalt := Mod(numExalt + 1 , listBuyCurrencyExalt.Count())
		CreateNotePrice(listBuyCurrencyExalt[numExalt+1])
		return
	}
	if (nameCur = "Chaos Orb"){
		; tt1:=infoCur.price
		; tt2:=listBuyCurrencyChaos[numChaos+1]
		; ToolTip, %tt1%`n%tt2%, 0, 0
		if (RegExMatch(infoCur.price, listBuyCurrencyChaos[numChaos+1])>0)
			numChaos := Mod(numChaos + 1 , listBuyCurrencyChaos.Count())
		CreateNotePrice(listBuyCurrencyChaos[numChaos+1])
		return
	}
	
	if (nameCur = "Scroll Fragment"){
		realName := infoCur.price
		Prices := priceData[realName]
		ttsellPriceGlobalChaos := Prices.priceBuyChaos	
		ttsellPriceGlobalExalt := Prices.priceBuyExalt
		ToolTip, %realName% %ttsellPriceGlobalChaos% %ttsellPriceGlobalExalt%, 0, 0
	}else{	
		lastPrice := DefineLastPrice(infoCur.price)
		Prices := priceData[nameCur]
		tempT:=Prices.priceSellChaos
		; ToolTip, %lastPrice%`n%tempT%, 0, 0
		if (lastPrice = 1){
			if (Prices.priceSellExaltFrac != "~skip"){
				CreateNotePrice(Prices.priceSellExaltFrac)
			}else{
				lastPrice = 2
			}
		}
		if (lastPrice = 2){
			if (Prices.priceSellExalt != "~skip"){
				CreateNotePrice(Prices.priceSellExalt)
			}else{		
				lastPrice = 3
			}
		}
		if (lastPrice = 3){
			CreateNotePrice(Prices.priceSellChaos)		
		}
	}
	
	sellPriceGlobalChaos := Prices.priceBuyChaos
	; ToolTip, %sellPriceGlobalChaos%, 0, 0
	sellPriceGlobalExalt := Prices.priceBuyExalt
return

F3::
if (!WinActive("Path of Exile"))
		return
	
	readItem := GetCurrentItem()
	if (readItem = "")
		return
	
	infoCur := GetInfoFromClipboard(readItem)	
	nameCur := infoCur.name
	
	if (nameCur = "Exalted Orb"){
		CreateNotePrice(sellPriceGlobalExalt)
		return
	}
	if (nameCur = "Chaos Orb"){
		; ToolTip, %sellPriceGlobalChaos%, 0, 0
		CreateNotePrice(sellPriceGlobalChaos)
		return
	}
	if (nameCur = "Scroll Fragment"){
		nameCur := infoCur.price
	}
	Prices := priceData[nameCur]
	sellPriceGlobalChaos := Prices.priceBuyChaos	
	sellPriceGlobalExalt := Prices.priceBuyExalt
	ToolTip, %nameCur% %sellPriceGlobalChaos% %sellPriceGlobalExalt%, 0, 0
return

HideMessage:
	ToolTip,,0,0
return