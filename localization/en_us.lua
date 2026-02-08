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
                {text="Creation is only the beginning of your damnation."}
            }
        }
    }
}