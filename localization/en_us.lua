return {
    dialogue = {
        virgil = {
            displayName = "Virgil",
            gardenGreeting = {
                {text="So... you have arrived.", func=function() util.dialogue:obscure() end},
                {text="Dante."},
                {text="Do not be alarmed."},
                {text="You stand in the Garden... the last place that still answers to the living."},
                {text="I am Virgil.", func=function() util.dialogue:unObscure() end},
                {text="And for now... I will guide you"},
                {text="..."},
                {text="There is work to be done before you descend."},
                {text="To your right stands the Altar."},
                {text="Go to it."}
            },
            altarEnter = {
                {text="Good."},
                {text="This is where intention takes form."},
                {text="Proceed with the Altar to use divine craftsmanship"}
            },
            altarExplain = {
                {text="Each symbol before you... is a virtue."},
                {text="Choose one."}
            },
            altarSelect = {
                {text="You may shape it further."},
                {text="Add more, or leave it pure."},
                {text="For now. Bind it."},
                {text="The eye finalises what you have chosen."}
            },
            seedCreated = {
                {text="There."},
                {text="A seed... born from virtue."},
                {text="Take it."},
                {text="Return to the Garden."}
            },
            returnToGarden = {
                {text="The soil awaits what you have made."},
                {text="Plant it."}
            },
            afterPlant = {
                {text="A bud of virtue is only the start."},
                {text="Whilst being a divine treasure, these flowers still require sustenance."},
                {text='Tend it carefully. What is nearby may help.'}
            },
            flowerBloomed = {
                {text="With even a singular flower, you are able to progress into the depths of Hell"},
                {text="Meet me in the room to the left when you are ready to descend..."}
            },
            doorwayEnter = {
                {text="Behind me stands The Gates To Hell, the bridge from Heaven to Hell."},
                {text="You are here for one specific purpose."},
                {text="You see, Hell is in need of a... cleansing"},
                {text="These flowers shall assist you in your endeavour."},
                {text="Proceed with the gates to prepare for descent."}
            },
            doorwaySelect = {
                {text="In this menu you may select which bloomed flowers you would like to assist you."},
                {text="You may only bring a maximum of four flowers with you however."},
                {text="Once your party is ready, step onto the pentagram to leave this plane."},
                {text="I may not join you within the depths. From here your choices are your own"},
                {text="Good luck. Dante..."}
            }
        }
    },
    taskPerformance = {
        perfect = {text="PERFECT"},
        great = {text="GREAT"},
        good = {text="GOOD"},
        bad = {text="BAD"},
        miss = {text="MISS"}
    },
    taskModifierTypes = {
        attack = {text="Attack"},
        shield = {text="Shield"},
        effect = {text="Effect"}
    },
    enemyData = {
        crawler = {
            name = {text="Crawler"},
            layer = {text="Limbo"},
            description = {text="A hunk of amalgamated flesh and muscles forced to roam limbo in a porcelain vessel"},
            affinities1 = {
                {text="Limbo"}
            }
        },
        harpy = {
            name = {text="Harpy"},
            layer = {text="Limbo"},
            description = {text="Something something description"},
            affinities1 = {
                {text="Limbo"}
            }
        }
    }
}