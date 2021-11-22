#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force

#Include json.ahk

; All constants:
PoeCurencyURL := "https://poe.ninja/api/data/CurrencyOverview?league=Scourge&type=Currency"
PoeFragmentURL := "https://poe.ninja/api/data/CurrencyOverview?league=Scourge&type=Fragment"
PoeCurencyJSON := "poe.currency.json"
PoeFragmentJSON := "poe.fragment.json"
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CenterKoef := 1.1
PowerKoef := Max(CenterKoef-1, ln(500)-CenterKoef)
MaxChaos := 100
MaxExalt := 5
MaxCountStack :=40
sellPriceGlobalChaos := -1
sellPriceGlobalExalt := -1
sdvigPrice=0.06
MinChaosProfit :=0.5
Debug := false

ExaltPrice := 150

stackData := {regret:40, chaos:10, exalted:10, divine:10, alch:10, alt:20, regal:10, vaal:10, chisel:20, mirror:1, scour:30, gcp:20, chance:10, chrome:20}
; "tradeId":"fusing"
; "jewellers"
; "silver"
; "blessed"
; "bauble"
; "tradeId":"aug"
; "tradeId":"transmute"
; "tradeId":"Perandus Coin"
; "wisdom"
; "portal"
; "whetstone"
; "scrap"
; "name":"Eternal Orb","tradeId":"eternal"
; "Sacrifice at Dusk","tradeId":"dusk"
; "name":"Sacrifice at Midnight","tradeId":"mid"
; "name":"Sacrifice at Dawn","tradeId":"dawn"
;"name":"Sacrifice at Noon","tradeId":"noon"
;"name":"Mortal Grief","tradeId":"grie"
;"name":"Mortal Rage","tradeId":"rage"
;"name":"Mortal Ignorance","tradeId":"ign"
;"name":"Mortal Hope","tradeId":"hope"
;"name":"Eber\u0027s Key","tradeId":"eber"
;"name":"Yriel\u0027s Key","tradeId":"yriel"
;"name":"Inya\u0027s Key","tradeId":"inya"
;"name":"Volkuur\u0027s Key","tradeId":"volkuur"
;"name":"Fragment of the Hydra","tradeId":"hydra"
;"name":"Fragment of the Phoenix","tradeId":"phoenix"
;"name":"Fragment of the Minotaur","tradeId":"minot"
;"name":"Fragment of the Chimera","tradeId":"chimer"
;"name":"Offering to the Goddess","tradeId":"offer"
;"name":"Stacked Deck","tradeId":"stacked-deck"
;"name":"Simple Sextant","tradeId":"simple-sextant"
;"name":"Prime Sextant","tradeId":"prime-sextant"
;"name":"Awakened Sextant","tradeId":"awakened-sextant"
;"name":"Apprentice Cartographer\u0027s Seal"
;"name":"Journeyman Cartographer\u0027s Seal"
;"name":"Master Cartographer\u0027s Seal"
;"name":"Sacrifice Set","tradeId":"sacrifice-set"
;"name":"Mortal Set","tradeId":"mortal-set"},{"id":54,"icon":"https://web.poecdn.com/image/Art/2DItems/Maps/PaleCourtComplete.png?scale=1\u0026w=1\u0026h=1","name":"Pale Court Set","tradeId":"pale-court-set"},{"id":55,"icon":"https://web.poecdn.com/image/Art/2DItems/Maps/ShaperComplete.png?scale=1\u0026w=1\u0026h=1","name":"Shaper Set"},{"id":56,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0JyZWFjaFNoYXJkRmlyZSIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/c0deb5799d/BreachShardFire.png","name":"Splinter of Xoph"},{"id":57,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0JyZWFjaFNoYXJkQ29sZCIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/ef894cc215/BreachShardCold.png","name":"Splinter of Tul"},{"id":58,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0JyZWFjaFNoYXJkTGlnaHRuaW5nIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/de619878b0/BreachShardLightning.png","name":"Splinter of Esh"},{"id":59,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0JyZWFjaFNoYXJkUGh5c2ljYWwiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/310aff1de6/BreachShardPhysical.png","name":"Splinter of Uul-Netol"},{"id":60,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0JyZWFjaFNoYXJkQ2hhb3MiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/873da59e9c/BreachShardChaos.png","name":"Splinter of Chayula"},{"id":61,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0JyZWFjaFVwZ3JhZGVyRmlyZSIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/f9d0f29f08/BreachUpgraderFire.png","name":"Blessing of Xoph","tradeId":"blessing-xoph"},{"id":62,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0JyZWFjaFVwZ3JhZGVyQ29sZCIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/3f8a9bbe57/BreachUpgraderCold.png","name":"Blessing of Tul","tradeId":"blessing-tul"},{"id":63,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0JyZWFjaFVwZ3JhZGVyTGlnaHRuaW5nIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/d12318c95b/BreachUpgraderLightning.png","name":"Blessing of Esh","tradeId":"blessing-esh"},{"id":64,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0JyZWFjaFVwZ3JhZGVyUGh5c2ljYWwiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/7eab2a8de8/BreachUpgraderPhysical.png","name":"Blessing of Uul-Netol","tradeId":"blessing-uul-netol"},{"id":65,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0JyZWFjaFVwZ3JhZGVyQ2hhb3MiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/5542f2ce9a/BreachUpgraderChaos.png","name":"Blessing of Chayula","tradeId":"blessing-chayula"},{"id":66,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0JyZWFjaEZyYWdtZW50c0ZpcmUiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/071c4ccc28/BreachFragmentsFire.png","name":"Xoph\u0027s Breachstone","tradeId":"xophs-breachstone"},{"id":67,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0JyZWFjaEZyYWdtZW50c0NvbGQiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/210fc3b508/BreachFragmentsCold.png","name":"Tul\u0027s Breachstone","tradeId":"tuls-breachstone"},{"id":68,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0JyZWFjaEZyYWdtZW50c0xpZ2h0bmluZyIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/e66ff540ed/BreachFragmentsLightning.png","name":"Esh\u0027s Breachstone","tradeId":"eshs-breachstone"},{"id":69,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0JyZWFjaEZyYWdtZW50c1BoeXNpY2FsIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/2ab646ae46/BreachFragmentsPhysical.png","name":"Uul-Netol\u0027s Breachstone","tradeId":"uul-breachstone"},{"id":70,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0JyZWFjaEZyYWdtZW50c0NoYW9zIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/04b5c032f4/BreachFragmentsChaos.png","name":"Chayula\u0027s Breachstone","tradeId":"chayulas-breachstone"},{"id":71,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9WYXVsdE1hcCIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/035e4327dd/VaultMap.png","name":"Ancient Reliquary Key","tradeId":"ancient-reliquary-key"},{"id":72,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9TaW5GbGFza0VtcHR5IiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/65ed329fe5/SinFlaskEmpty.png","name":"Divine Vessel","tradeId":"divine-vessel"},{"id":73,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQW5udWxsT3JiIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/88cfdbe1e5/AnnullOrb.png","name":"Orb of Annulment","tradeId":"annul"},{"id":74,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQmluZGluZ09yYiIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/66ef64410c/BindingOrb.png","name":"Orb of Binding","tradeId":"orb-of-binding"},{"id":75,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSG9yaXpvbk9yYiIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/a48e326c68/HorizonOrb.png","name":"Orb of Horizons","tradeId":"orb-of-horizons"},{"id":76,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSGFyYmluZ2VyT3JiIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/3e31090ea7/HarbingerOrb.png","name":"Harbinger\u0027s Orb","tradeId":"harbingers-orb"},{"id":77,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvRW5naW5lZXJzT3JiIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/56b41a5ee5/EngineersOrb.png","name":"Engineer\u0027s Orb","tradeId":"engineers"},{"id":78,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQW5jaWVudE9yYiIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/08feb97abf/AncientOrb.png","name":"Ancient Orb","tradeId":"ancient-orb"},{"id":79,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQW5udWxsU2hhcmQiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/f7a8a838a6/AnnullShard.png","name":"Annulment Shard"},{"id":80,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvRXhhbHRlZFNoYXJkIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/a919870741/ExaltedShard.png","name":"Exalted Shard"},{"id":81,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvTWlycm9yU2hhcmQiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/6604b7aa32/MirrorShard.png","name":"Mirror Shard"},{"id":82,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9WYXVsdE1hcDMiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/618fdfad67/VaultMap3.png","name":"Timeworn Reliquary Key","tradeId":"timeworn-reliquary-key"},{"id":83,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL1hvcGhzQ2hhcmdlZEJyZWFjaHN0b25lIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/f7a05e5bb1/XophsChargedBreachstone.png","name":"Xoph\u0027s Charged Breachstone","tradeId":"xophs-charged-breachstone"},{"id":84,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL1R1bHNDaGFyZ2VkQnJlYWNoc3RvbmUiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/63ee33df22/TulsChargedBreachstone.png","name":"Tul\u0027s Charged Breachstone","tradeId":"tuls-charged-breachstone"},{"id":85,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0VzaHNDaGFyZ2VkQnJlYWNoc3RvbmUiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/19eeb5a053/EshsChargedBreachstone.png","name":"Esh\u0027s Charged Breachstone","tradeId":"eshs-charged-breachstone"},{"id":86,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL1V1bE5ldG9sc0NoYXJnZWRCcmVhY2hzdG9uZSIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/15e85c9e85/UulNetolsChargedBreachstone.png","name":"Uul-Netol\u0027s Charged Breachstone","tradeId":"uul-charged-breachstone"},{"id":87,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0NoYXl1bGFzQ2hhcmdlZEJyZWFjaHN0b25lIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/df8ac77370/ChayulasChargedBreachstone.png","name":"Chayula\u0027s Charged Breachstone","tradeId":"chayulas-charged-breachstone"},{"id":88,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL1hvcGhzRW5yaWNoZWRCcmVhY2hzdG9uZSIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/cc980d1aa4/XophsEnrichedBreachstone.png","name":"Xoph\u0027s Enriched Breachstone","tradeId":"xophs-enriched-breachstone"},{"id":89,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL1R1bHNFbnJpY2hlZEJyZWFjaHN0b25lIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/e3f127ab77/TulsEnrichedBreachstone.png","name":"Tul\u0027s Enriched Breachstone","tradeId":"tuls-enriched-breachstone"},{"id":90,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0VzaHNFbnJpY2hlZEJyZWFjaHN0b25lIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/fbc839157e/EshsEnrichedBreachstone.png","name":"Esh\u0027s Enriched Breachstone","tradeId":"eshs-enriched-breachstone"},{"id":91,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL1V1bE5ldG9sc0VucmljaGVkQnJlYWNoc3RvbmUiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/7aca605592/UulNetolsEnrichedBreachstone.png","name":"Uul-Netol\u0027s Enriched Breachstone","tradeId":"uul-enriched-breachstone"},{"id":92,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0NoYXl1bGFzRW5yaWNoZWRCcmVhY2hzdG9uZSIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/84053be861/ChayulasEnrichedBreachstone.png","name":"Chayula\u0027s Enriched Breachstone","tradeId":"chayulas-enriched-breachstone"},{"id":93,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL1hvcGhzUHVyZUJyZWFjaHN0b25lIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/901eb67c3b/XophsPureBreachstone.png","name":"Xoph\u0027s Pure Breachstone","tradeId":"xophs-pure-breachstone"},{"id":94,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL1R1bHNQdXJlQnJlYWNoc3RvbmUiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/3a2c181736/TulsPureBreachstone.png","name":"Tul\u0027s Pure Breachstone","tradeId":"tuls-pure-breachstone"},{"id":95,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0VzaHNQdXJlQnJlYWNoc3RvbmUiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/67717e35a3/EshsPureBreachstone.png","name":"Esh\u0027s Pure Breachstone","tradeId":"eshs-pure-breachstone"},{"id":96,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL1V1bE5ldG9sc1B1cmVCcmVhY2hzdG9uZSIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/e90400edd6/UulNetolsPureBreachstone.png","name":"Uul-Netol\u0027s Pure Breachstone","tradeId":"uul-pure-breachstone"},{"id":97,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0NoYXl1bGFzUHVyZUJyZWFjaHN0b25lIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/990514c659/ChayulasPureBreachstone.png","name":"Chayula\u0027s Pure Breachstone","tradeId":"chayulas-pure-breachstone"},{"id":98,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9LYXJ1aUZyYWdtZW50IiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/f05377f6c7/KaruiFragment.png","name":"Timeless Karui Emblem","tradeId":"timeless-karui-emblem"},{"id":99,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9NYXJha2V0aEZyYWdtZW50IiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/7c42d58a5e/MarakethFragment.png","name":"Timeless Maraketh Emblem","tradeId":"timeless-maraketh-emblem"},{"id":100,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9FdGVybmFsRW1waXJlRnJhZ21lbnQiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/c1776eeb6b/EternalEmpireFragment.png","name":"Timeless Eternal Emblem","tradeId":"timeless-eternal-emblem"},{"id":101,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9UZW1wbGFyRnJhZ21lbnQiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/e31c7a2a1e/TemplarFragment.png","name":"Timeless Templar Emblem","tradeId":"timeless-templar-emblem"},{"id":102,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9WYWFsRnJhZ21lbnQiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/7b02499e4e/VaalFragment.png","name":"Timeless Vaal Emblem","tradeId":"timeless-vaal-emblem"},{"id":103,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9LYXJ1aVNoYXJkIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/e9c55ce439/KaruiShard.png","name":"Timeless Karui Splinter"},{"id":104,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9NYXJha2V0aFNoYXJkIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/06ccc00c64/MarakethShard.png","name":"Timeless Maraketh Splinter"},{"id":105,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9FdGVybmFsRW1waXJlU2hhcmQiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/ee92812083/EternalEmpireShard.png","name":"Timeless Eternal Empire Splinter"},{"id":106,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9UZW1wbGFyU2hhcmQiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/1c070c1aa4/TemplarShard.png","name":"Timeless Templar Splinter"},{"id":107,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9WYWFsU2hhcmQiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/02b4b4473c/VaalShard.png","name":"Timeless Vaal Splinter"},{"id":108,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9BdGxhc01hcEd1YXJkaWFuRmlyZSIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/6327dee00e/AtlasMapGuardianFire.png","name":"Fragment of Enslavement","tradeId":"fragment-of-enslavement"},{"id":109,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9BdGxhc01hcEd1YXJkaWFuTGlnaHRuaW5nIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/22a9d1257c/AtlasMapGuardianLightning.png","name":"Fragment of Eradication","tradeId":"fragment-of-eradication"},{"id":110,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9BdGxhc01hcEd1YXJkaWFuSG9seSIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/ade615a113/AtlasMapGuardianHoly.png","name":"Fragment of Constriction","tradeId":"fragment-of-constriction"},{"id":111,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9BdGxhc01hcEd1YXJkaWFuQ2hhb3MiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/767832e457/AtlasMapGuardianChaos.png","name":"Fragment of Purification","tradeId":"fragment-of-purification"},{"id":112,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9VYmVyRWxkZXIwMyIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/dd71531c9f/UberElder03.png","name":"Fragment of Shape","tradeId":"fragment-of-shape"},{"id":113,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9VYmVyRWxkZXIwNCIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/4a2bab8955/UberElder04.png","name":"Fragment of Knowledge","tradeId":"fragment-of-knowledge"},{"id":114,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9VYmVyRWxkZXIwMSIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/061cd63c5e/UberElder01.png","name":"Fragment of Terror","tradeId":"fragment-of-terror"},{"id":115,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9VYmVyRWxkZXIwMiIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/ced2590995/UberElder02.png","name":"Fragment of Emptiness","tradeId":"fragment-of-emptiness"},{"id":116,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvVHJhbnNmZXJPcmIiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/6db384ea6e/TransferOrb.png","name":"Awakener\u0027s Orb","tradeId":"awakeners-orb"},{"id":117,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSW5mbHVlbmNlIEV4YWx0cy9DcnVzYWRlck9yYiIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/0449a66634/CrusaderOrb.png","name":"Crusader\u0027s Exalted Orb","tradeId":"crusaders-exalted-orb"},{"id":118,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSW5mbHVlbmNlIEV4YWx0cy9FeXJpZU9yYiIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/6157e9ce59/EyrieOrb.png","name":"Redeemer\u0027s Exalted Orb","tradeId":"redeemers-exalted-orb"},{"id":119,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSW5mbHVlbmNlIEV4YWx0cy9CYXNpbGlza09yYiIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/c17ac5e60c/BasiliskOrb.png","name":"Hunter\u0027s Exalted Orb","tradeId":"hunters-exalted-orb"},{"id":120,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSW5mbHVlbmNlIEV4YWx0cy9Db25xdWVyb3JPcmIiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/14d882831a/ConquerorOrb.png","name":"Warlord\u0027s Exalted Orb","tradeId":"warlords-exalted-orb"},{"id":121,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQ2F0YWx5c3RzL1R1cmJ1bGVudENhdGFseXN0IiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/fc41fe8950/TurbulentCatalyst.png","name":"Turbulent Catalyst","tradeId":"turbulent-catalyst"},{"id":122,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQ2F0YWx5c3RzL0ltYnVlZENhdGFseXN0IiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/9053293cf6/ImbuedCatalyst.png","name":"Imbued Catalyst","tradeId":"imbued-catalyst"},{"id":123,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQ2F0YWx5c3RzL0FicmFzaXZlQ2F0YWx5c3QiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/c4e7f7f379/AbrasiveCatalyst.png","name":"Abrasive Catalyst","tradeId":"abrasive-catalyst"},{"id":124,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQ2F0YWx5c3RzL1RlbXBlcmluZ0NhdGFseXN0IiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/7b6277022e/TemperingCatalyst.png","name":"Tempering Catalyst","tradeId":"tempering-catalyst"},{"id":125,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQ2F0YWx5c3RzL0ZlcnRpbGVDYXRhbHlzdCIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/4b4ca5d929/FertileCatalyst.png","name":"Fertile Catalyst","tradeId":"fertile-catalyst"},{"id":126,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQ2F0YWx5c3RzL1ByaXNtYXRpY0NhdGFseXN0IiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/5e51d41a0e/PrismaticCatalyst.png","name":"Prismatic Catalyst","tradeId":"prismatic-catalyst"},{"id":127,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQ2F0YWx5c3RzL0ludHJpbnNpY0NhdGFseXN0IiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/107ffb799e/IntrinsicCatalyst.png","name":"Intrinsic Catalyst","tradeId":"intrinsic-catalyst"},{"id":128,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9EZWxpcml1bUZyYWdtZW50IiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/92fba984ee/DeliriumFragment.png","name":"Simulacrum","tradeId":"simulacrum"},{"id":129,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9EZWxpcml1bVNwbGludGVyIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/ae73b9445e/DeliriumSplinter.png","name":"Simulacrum Splinter"},{"id":130,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9MYWJ5cmludGhIYXJ2ZXN0IiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/b1cfaffbce/LabyrinthHarvest.png","name":"Tribute to the Goddess","tradeId":"offer-tribute"},{"id":131,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9MYWJ5cmludGhIYXJ2ZXN0SW5mdXNlZDIiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/3e8b597bd1/LabyrinthHarvestInfused2.png","name":"Dedication to the Goddess","tradeId":"offer-dedication"},{"id":132,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9MYWJ5cmludGhIYXJ2ZXN0SW5mdXNlZDEiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/95aadb1d9f/LabyrinthHarvestInfused1.png","name":"Gift to the Goddess","tradeId":"offer-gift"},{"id":133,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQWx0ZXJuYXRlU2tpbGxHZW1DdXJyZW5jeSIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/723fd6fbdd/AlternateSkillGemCurrency.png","name":"Prime Regrading Lens","tradeId":"prime-regrading-lens"},{"id":134,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQWx0ZXJuYXRlU3VwcG9ydEdlbUN1cnJlbmN5IiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/a4910912e4/AlternateSupportGemCurrency.png","name":"Secondary Regrading Lens","tradeId":"secondary-regrading-lens"},{"id":135,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvRGl2aW5lRW5jaGFudEJvZHlBcm1vdXJDdXJyZW5jeSIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/41418e201d/DivineEnchantBodyArmourCurrency.png","name":"Tempering Orb","tradeId":"tempering-orb"},{"id":136,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvRGl2aW5lRW5jaGFudFdlYXBvbkN1cnJlbmN5IiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/c5f4a79b45/DivineEnchantWeaponCurrency.png","name":"Tailoring Orb","tradeId":"tailoring-orb"},{"id":137,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSGVpc3QvSGVpc3RDb2luQ3VycmVuY3kiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/987a8953f9/HeistCoinCurrency.png","name":"Rogue\u0027s Marker","tradeId":"rogues-marker"},{"id":138,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvTWF2ZW5PcmIiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/8396ed7d8d/MavenOrb.png","name":"Maven\u0027s Orb","tradeId":"mavens-orb"},{"id":139,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvUml0dWFsL0VmZmlneSIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/445939b722/Effigy.png","name":"Ritual Vessel","tradeId":"ritual-vessel"},{"id":140,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQXRsYXNSYWRpdXNUaWVyNCIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/5aa797a16b/AtlasRadiusTier4.png","name":"Elevated Sextant","tradeId":"elevated-sextant"},{"id":141,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvUmVncmV0T3JiIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/a2ebb4b5a3/RegretOrb.png","name":"Orb of Unmaking","tradeId":"orb-of-unmaking"},{"id":142,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQXRsYXMvTWF2ZW5LZXlGcmFnbWVudCIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/1782453393/MavenKeyFragment.png","name":"Crescent Splinter"},{"id":143,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQXRsYXMvTWF2ZW5LZXkiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/ad4c12144c/MavenKey.png","name":"The Maven\u0027s Writ","tradeId":"the-mavens-writ"},{"id":144,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9WYXVsdE1hcDQiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/0288439591/VaultMap4.png","name":"Vaal Reliquary Key","tradeId":"vaal-reliquary-key"},{"id":145,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvVmVpbGVkQ2hhb3NPcmIiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/fe00a81cbc/VeiledChaosOrb.png","name":"Veiled Chaos Orb","tradeId":"veiled-chaos-orb"},{"id":146,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQ2F0YWx5c3RzL0NoYW9zUGh5c2ljYWxDYXRhbHlzdCIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/bbdf8917e4/ChaosPhysicalCatalyst.png","name":"Noxious Catalyst","tradeId":"noxious-catalyst"},{"id":147,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQ2F0YWx5c3RzL1NwZWVkTW9kaWZpZXJDYXRhbHlzdCIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/592075333a/SpeedModifierCatalyst.png","name":"Accelerating Catalyst","tradeId":"accelerating-catalyst"},{"id":148,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQ2F0YWx5c3RzL0NyaXRpY2FsTW9kaWZpZXJDYXRhbHlzdCIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/18e5522c0e/CriticalModifierCatalyst.png","name":"Unstable Catalyst","tradeId":"unstable-catalyst"},{"id":149,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL1hvcGhzRmxhd2xlc3NCcmVhY2hzdG9uZSIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/ed1fa03ff6/XophsFlawlessBreachstone.png","name":"Xoph\u0027s Flawless Breachstone","tradeId":"xophs-flawless-breachstone"},{"id":150,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL1R1bHNGbGF3bGVzc0JyZWFjaHN0b25lIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/3a646b7375/TulsFlawlessBreachstone.png","name":"Tul\u0027s Flawless Breachstone","tradeId":"tuls-flawless-breachstone"},{"id":151,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0VzaHNGbGF3bGVzc0JyZWFjaHN0b25lIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/b2fe284562/EshsFlawlessBreachstone.png","name":"Esh\u0027s Flawless Breachstone","tradeId":"eshs-flawless-breachstone"},{"id":152,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL1V1bE5ldG9sc0ZsYXdsZXNzQnJlYWNoc3RvbmUiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/22915fdf3f/UulNetolsFlawlessBreachstone.png","name":"Uul-Netol\u0027s Flawless Breachstone","tradeId":"uul-flawless-breachstone"},{"id":153,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvQnJlYWNoL0NoYXl1bGFzRmxhd2xlc3NCcmVhY2hzdG9uZSIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/0d6f8da0ec/ChayulasFlawlessBreachstone.png","name":"Chayula\u0027s Flawless Breachstone","tradeId":"chayulas-flawless-breachstone"},{"id":154,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9UaW1lbGVzc0NvbmZsaWN0RXRlcm5hbCIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/6a6e66a71c/TimelessConflictEternal.png","name":"Unrelenting Timeless Karui Emblem","tradeId":"uber-timeless-karui-emblem"},{"id":155,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9UaW1lbGVzc0NvbmZsaWN0TWFyYWtldGgiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/31d3f4f939/TimelessConflictMaraketh.png","name":"Unrelenting Timeless Maraketh Emblem","tradeId":"uber-timeless-maraketh-emblem"},{"id":156,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9UaW1lbGVzc0NvbmZsaWN0S2FydWkiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/d7f863e549/TimelessConflictKarui.png","name":"Unrelenting Timeless Eternal Emblem","tradeId":"uber-timeless-eternal-emblem"},{"id":157,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9UaW1lbGVzc0NvbmZsaWN0VGVtcGxhciIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/4e0d302db8/TimelessConflictTemplar.png","name":"Unrelenting Timeless Templar Emblem","tradeId":"uber-timeless-templar-emblem"},{"id":158,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvTWFwcy9UaW1lbGVzc0NvbmZsaWN0VmFhbCIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/2245d648ba/TimelessConflictVaal.png","name":"Unrelenting Timeless Vaal Emblem","tradeId":"uber-timeless-vaal-emblem"},{"id":159,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvU2FjcmVkT3JiIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/f5a07465c5/SacredOrb.png","name":"Sacred Orb","tradeId":"sacred-orb"},{"id":160,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvVGFpbnRlZEJsZXNzaW5nIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/a712d4cf74/TaintedBlessing.png","name":"Tainted Blessing"},{"id":161,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSGVsbHNjYXBlL0hlbGxzY2FwZUNocm9tYXRpY09yYiIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/c0a50953c2/HellscapeChromaticOrb.png","name":"Tainted Chromatic Orb"},{"id":162,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSGVsbHNjYXBlL0hlbGxzY2FwZU9yYk9mRnVzaW5nIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/a97eb273c3/HellscapeOrbOfFusing.png","name":"Tainted Orb of Fusing"},{"id":163,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSGVsbHNjYXBlL0hlbGxzY2FwZUpld2VsbGVyc09yYiIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/7ade99596b/HellscapeJewellersOrb.png","name":"Tainted Jeweller\u0027s Orb"},{"id":165,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSGVsbHNjYXBlL0hlbGxzY2FwZUV4YWx0ZWRPcmIiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/7cb146de94/HellscapeExaltedOrb.png","name":"Tainted Exalted Orb"},{"id":166,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSGVsbHNjYXBlL0hlbGxzY2FwZU15dGhpY09yYiIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/3cc4ad8930/HellscapeMythicOrb.png","name":"Tainted Mythic Orb"},{"id":167,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSGVsbHNjYXBlL0hlbGxzY2FwZUJsYWNrc21pdGhXaGV0c3RvbmUiLCJ3IjoxLCJoIjoxLCJzY2FsZSI6MX1d/c1551a2a62/HellscapeBlacksmithWhetstone.png","name":"Tainted Blacksmith\u0027s Whetstone"},{"id":168,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSGVsbHNjYXBlL0hlbGxzY2FwZUFybW91cmVyc1NjcmFwIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/05e0065a80/HellscapeArmourersScrap.png","name":"Tainted Armourer\u0027s Scrap"},{"id":169,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSGVsbHNjYXBlL0hlbGxzY2FwZUNoYW9zT3JiIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/bd934ad92b/HellscapeChaosOrb.png","name":"Tainted Chaos Orb"},{"id":170,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSGVsbHNjYXBlL0hlbGxzY2FwZVRlYXJkcm9wT3JiIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/e3cd0195e1/HellscapeTeardropOrb.png","name":"Tainted Divine Teardrop"},{"id":171,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvSW5mdXNlZEVuZ2luZWVyc09yYiIsInciOjEsImgiOjEsInNjYWxlIjoxfV0/af16686b10/InfusedEngineersOrb.png","name":"Infused Engineer\u0027s Orb","tradeId":"infused-engineers-orb"},{"id":172,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvRXhwZWRpdGlvbi9GbGFza1BsYXRlIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/c03aace282/FlaskPlate.png","name":"Enkindling Orb","tradeId":"enkindling-orb"},{"id":173,"icon":"https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvQ3VycmVuY3kvRXhwZWRpdGlvbi9GbGFza0luamVjdG9yIiwidyI6MSwiaCI6MSwic2NhbGUiOjF9XQ/08e3793591/FlaskInjector.png","name":"Instilling Orb","tradeId":"instilling-orb"}],"language":{"name":"en","translations":{}}}

tradeIdData := {}
tradeIdData["Splinter of Chayula"] := "splinter-chayula"

priceData := {}
listBuyCurrencyChaos := []
listBuyCurrencyExalt := []
numChaos := 0
numExalt := 0

AddTablePrice(js){
	global tradeIdData
	global stackData
	global priceData
	global listBuyCurrencyChaos
	global listBuyCurrencyExalt
	For currency, cData in js.lines {
		cName       := cData.currencyTypeName
		tradeId := ""
		For currency2, cData2 in js.currencyDetails
		{
			cName2       := cData2.name
			if (cName2 = cName)
			{
				tradeId:=cData2["tradeId"]
				break
			}
		}
		if (tradeId = "")
			tradeId:=tradeIdData[name]
		if (tradeId = "")
			throw "Don't have trade Id with name " . cName
		
		tHave := 100
		tStack := stackData[tradeId]
		if (tStack > 0)
		{
		}else{
			throw "Don't have stack count with name " . cName
			; tStack = 10
		}
		cData["tradeId"] := tradeId
			
		CountStack := tHave / tStack
		KoefLn := Ln(1+CountStack)
		objData := GetIdealPrice(cData, KoefLn)

		priceSellChaos := MatchGoodDivideSell(cData.MinCountCurrency, tStack, cData.wantSellPrice, 0)
		priceSellExalt := MatchGoodDivideSell(cData.MinCountCurrency, tStack, cData.wantSellPrice, 1)
		priceSellExaltFrac := GetGoodFracSell(cData.wantSellPrice)
		priceBuyChaos := MatchGoodDivideBuy(cData.MinCountCurrency, tStack, cData.wantBuyPrice, 0)
		priceBuyExalt := MatchGoodDivideBuy(cData.MinCountCurrency, tStack, cData.wantBuyPrice, 1)
		
		priceSellChaosText := "~price " . priceSellChaos["get"] . "/" . priceSellChaos["receive"] . " chaos"
		priceSellExaltText := "~price " . priceSellExalt["get"] . "/" . priceSellExalt["receive"] . " exalt"
		priceSellExaltFracText := "~price " . priceSellExaltFrac . " exalt"
		priceBuyChaosText := "~price " . priceBuyChaos["get"] . "/" . priceBuyChaos["receive"] . " " . objData.tradeId
		priceBuyExaltText := "~price " . priceBuyExalt["get"] . "/" . priceBuyExalt["receive"] . " " . objData.tradeId
	
		priceData[cName] := {priceSellChaos:priceSellChaosText, priceSellExalt:priceSellExaltText, priceSellExaltFrac:priceSellExaltFracText, priceBuyChaos:priceBuyChaosText, priceBuyExalt:priceBuyExaltText}
		listBuyCurrencyChaos.Push(priceBuyChaosText)
		listBuyCurrencyExalt.Push(priceBuyExaltText)
	}
}

CreateTablePrice(){
	global PoeCurencyJSON
	global PoeFragmentJSON
	
	FC := FileOpen(PoeCurencyJSON, "r")
	Currency := FC.Read()
	parsedJSONCurrency := JSON.Load(Currency)
	FF := FileOpen(PoeFragmentJSON, "r")
	Fragment := FF.Read()
	parsedJSONFragment := JSON.Load(Fragment)
	
	AddTablePrice(parsedJSONCurrency)
	AddTablePrice(parsedJSONFragment)	
}

GetUpdatePOE(){
	global PoeCurencyURL
	global PoeFragmentURL
	global PoeCurencyJSON
	global PoeFragmentJSON
	TestFile := "temp.json"
	; if !FileExist(PoeCurencyJSON)
	; {
		; OutputVar1 := -1
	; }else{
		; FileGetTime, OutputVar1, %PoeCurencyJSON%, M
		; EnvSub, OutputVar1, %A_Now%, days
	; }
	; if !FileExist(PoeFragmentJSON)
	; {
		; OutputVar2 := -1
	; }else{
		; FileGetTime, OutputVar2, %PoeFragmentJSON%, M
		; EnvSub, OutputVar2, %A_Now%, days
	; }
	; if ((OutputVar1 > -1) and (OutputVar2 > -1))
	; {
		; return
	; }
	FileDelete %TestFile% 
	UrlDownloadToFile, %PoeCurencyURL%, %TestFile%
	if ErrorLevel
	{
	}
	else
	{
		FileMove, %TestFile%, %PoeCurencyJSON%, 1
	}
	UrlDownloadToFile, %PoeFragmentURL%, %TestFile%
	if ErrorLevel
	{
	}
	else
	{
		FileMove, %TestFile%, %PoeFragmentJSON%, 1
	}
	CreateTablePrice()
	return
}


GetUpdatePOE()

GetFullPriceByData(name)
{
	global stackData
	global tradeIdData
	objData := SearchInJSONFiles(name)
	if (objData.tradeId = ""){
		objData.tradeId:=tradeIdData[name]
	}
	tt:=objData.tradeId
	; MsgBox, %tt%
	
		
	tHave := 100
	tStack := stackData[objData.tradeId]
	if (tStack > 0)
	{
	}else{
		tStack = 10
	}
	CountStack := tHave / tStack
	KoefLn := Ln(1+CountStack)
	objData := GetIdealPrice(objData, KoefLn)
	; MsgBox, %tStack%`n%CountStack%`n%KoefLn%

	priceSellChaos := MatchGoodDivideSell(objData.MinCountCurrency, tStack, objData.wantSellPrice, 0)
	priceSellExalt := MatchGoodDivideSell(objData.MinCountCurrency, tStack, objData.wantSellPrice, 1)
	priceSellExaltFrac := GetGoodFracSell(objData.wantSellPrice)
	priceBuyChaos := MatchGoodDivideBuy(objData.MinCountCurrency, tStack, objData.wantBuyPrice, 0)
	priceBuyExalt := MatchGoodDivideBuy(objData.MinCountCurrency, tStack, objData.wantBuyPrice, 1)
	
	
	; textSell = ~price %ia%/%ib% chaos
	; textBuy = ~price %idd%/%ic% %currencyName%
	; return {get: ic, receive: idd}
	
	priceSellChaosText := "~price " . priceSellChaos["get"] . "/" . priceSellChaos["receive"] . " chaos"
	priceSellExaltText := "~price " . priceSellExalt["get"] . "/" . priceSellExalt["receive"] . " exalt"
	priceSellExaltFracText := "~price " . priceSellExaltFrac . " exalt"
	priceBuyChaosText := "~price " . priceBuyChaos["get"] . "/" . priceBuyChaos["receive"] . " " . objData.tradeId
	priceBuyExaltText := "~price " . priceBuyExalt["get"] . "/" . priceBuyExalt["receive"] . " " . objData.tradeId
	
	; MsgBox, %priceSellChaosText%`n%priceSellExaltText%`n%priceSellExaltFracText%`n%priceBuyChaosText%`n%priceBuyExaltText%
	
	return {priceSellChaos:priceSellChaosText, priceSellExalt:priceSellExaltText, priceSellExaltFrac:priceSellExaltFracText, priceBuyChaos:priceBuyChaosText, priceBuyExalt:priceBuyExaltText}
}

CreateNotePrice(text){
	MouseGetPos OutputVarX, OutputVarY
	MouseXDiff = -100
	if (OutputVarX < 80)
	{
		MouseXDiff = -40
	}
	Click, Rel 0, 0 Right
	Sleep 100
	Click, Rel %MouseXDiff%, 80 Left, Down
	Sleep 100
	Click, Rel 0, 0 Left, Up
	Sleep 200
	Click, Rel 0, 0 Left
	Sleep 200
	; Click, Rel 0, 0 Left
	
	; Send +{Tab}
	Sleep 100
	Send {Down}{Up}{Up}{Up}{Up}
	Sleep 200
	Send {Enter}
	Sleep 100
	Send {Tab}
	Sleep 100
	Send, %text%
	Sleep, 100
	Send {Enter}

	; MsgBox, Complete!
}

GetCurrentItem(){
	clipboard := ""
	Send ^c
	ClipWait, 1
	if ErrorLevel
	{
		MsgBox, Can't define. Return from function
		return ""
	}
	return clipboard
}

GetInfoFromClipboard(text){
	last = ""
	Loop, parse, text, `n, `r
	{
		last = %A_LoopField%
		if (A_Index = 3)
		{
			; NewName := StrReplace(A_LoopField, "'", "\\u0027")
			; MsgBox, %A_LoopField%`n%NewName%
			name = %A_LoopField%
		}
	}
	return {name: name, price: last}
}



SearchInJSON(js, iName){

	; MsgBox, %js%`n%iName%
	For currency, cData in js.lines {
		cName       := cData.currencyTypeName
		if (cName <> iName)
		{
			continue
		}
		For currency2, cData2 in js.currencyDetails 
		{
			cName2       := cData2.name
				; MsgBox, %cName2%
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

SearchInJSONFiles(iName){
	global PoeCurencyJSON
	global PoeFragmentJSON
	
	FC := FileOpen(PoeCurencyJSON, "r")
	Currency := FC.Read()
	parsedJSONCurrency := JSON.Load(Currency)
	FF := FileOpen(PoeFragmentJSON, "r")
	Fragment := FF.Read()
	parsedJSONFragment := JSON.Load(Fragment)
	
	objData := SearchInJSON(parsedJSONCurrency, iName)
	if (objData.tradeId = 0){
		objData := SearchInJSON(parsedJSONFragment, iName)
	}
	return objData
}

GetIdealPrice(objData, KoefLn){
	global MinChaosProfit
	global CenterKoef
	global PowerKoef
	global sdvigPrice
	
	if (objData.pay.pay_currency_id = 1)
	{
		if (objData.pay.value > 0){
			buyPrice := Min(objData.pay.value, objData.chaosEquivalent*(1-sdvigPrice))
		}else{
			buyPrice := objData.chaosEquivalent*(1-sdvigPrice)		
		}
	} else
	{
		if (objData.pay.value > 0){
			buyPrice := Min(1/objData.pay.value, objData.chaosEquivalent*(1-sdvigPrice))
		}else{
			buyPrice := objData.chaosEquivalent*(1-sdvigPrice)		
		}
	}
	if (objData.receive.pay_currency_id = 1)
	{
		sellPrice := Max(objData.receive.value, (1+2*sdvigPrice)*objData.chaosEquivalent)
	} else
	{
		sellPrice := Max(1/objData.receive.value, (1+2*sdvigPrice)*objData.chaosEquivalent)
	}
	
	
	BD := (objData.chaosEquivalent / buyPrice) ** (1/PowerKoef)
	SD := (objData.chaosEquivalent / sellPrice) ** (1/PowerKoef)
	wantBuyPrice := buyPrice / BD
	wantSellPrice := sellPrice / SD
	diffPrice := wantSellPrice - wantBuyPrice
	MinCountCurrency := MinChaosProfit	/	diffPrice
	
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
		SizeLoopSell := 5*iStack
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
	if (RegExMatch(textPrice, "~") = 0)
		return 3
	if (RegExMatch(textPrice, "chaos") > 0)
		return 1
	if (RegExMatch(textPrice, ".") > 0)
		return 2
	return 3
}

F2::
	if (!WinActive("Path of Exile"))
		return
	
	readItem := GetCurrentItem()
	if (readItem = "")
		return
	
	infoCur := GetInfoFromClipboard(readItem)
	
	nameCur := infoCur.name
	Prices := priceData[nameCur]
	lastPrice := DefineLastPrice(infoCur.price)
	if (lastPrice = 1){
		CreateNotePrice(Prices.priceSellExaltFrac)
	}else if (lastPrice = 2){
		CreateNotePrice(Prices.priceSellExalt)
	}else{
		CreateNotePrice(Prices.priceSellChaos)
	}
	
	sellPriceGlobalChaos := Prices.priceBuyChaos
	sellPriceGlobalExalt := Prices.priceBuyExalt
return

F3::
	; Exalted Orb
	if (!WinActive("Path of Exile"))
		return
		
		readItem := GetCurrentItem()
	if (readItem = "")
		return
	
	infoCur := GetInfoFromClipboard(readItem)
	nameCur := infoCur.name
	
	if (nameCur = "Exalted Orb"){
		CreateNotePrice(listBuyCurrencyExalt[numExalt+1])
		numExalt := Mod(numExalt + 1 , listBuyCurrencyExalt.Length)
	}
	if (nameCur = "Chaos Orb"){
		CreateNotePrice(listBuyCurrencyChaos[numChaos+1])
		numChaos := Mod(numChaos + 1 , listBuyCurrencyChaos.Length)
		CreateNotePrice(sellPriceGlobalExalt)
	}
return

; WinActivate, Untitled - Notepad
; WinWaitActive, Untitled - Notepad
