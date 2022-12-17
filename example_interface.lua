local actionbar = {}

local root = DUI.newMainContainer({
    child = DUI.newHorizontalContainer({
        color = COLOR.BLACK,
        children = {
            DUI.newHorizontalContainer({ --sidebar container
                color = COLOR.BLUE,
                sizeFactor = 0.4,
                children = {
                    DUI.newVerticalContainer({ -- actionbar
                        color = COLOR.WHITE,
                        sizeFactor = 0.2,
                        padding = 3,
                        margin = 5,
                        children = {
                            DUI.newButton({sizeFactor = 0.333, dependencyIndex = 1}, STYLE.ACTIONBARBUTTON),
                            DUI.newButton({sizeFactor = 0.333, dependencyIndex = 2,margin = 8}, STYLE.ACTIONBARBUTTON),
                            DUI.newButton({sizeFactor = 0.2, dependencyIndex = 3}, STYLE.ACTIONBARBUTTON),
                            DUI.newButton({sizeFactor = 1, color = COLOR.RED})
                        }
                    })
                }          
            })

        }
    })
})
return root